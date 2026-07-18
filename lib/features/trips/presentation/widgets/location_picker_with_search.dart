import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../../../core/services/places_service.dart';

/// Enhanced interactive location picker with Google Places Autocomplete
class LocationPickerWithSearch extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final String title;
  final String? apiKey;

  const LocationPickerWithSearch({
    super.key,
    this.initialLat,
    this.initialLng,
    required this.title,
    this.apiKey,
  });

  @override
  State<LocationPickerWithSearch> createState() =>
      _LocationPickerWithSearchState();
}

class _LocationPickerWithSearchState extends State<LocationPickerWithSearch> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  bool _isLoading = true;
  String? _selectedAddress;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  Timer? _debounce;
  bool _isSearching = false;
  List<PlacePrediction> _predictions = [];
  bool _showPredictions = false;

  // Default to Dubai, UAE
  static const _defaultLocation = LatLng(25.2048, 55.2708);

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLat != null && widget.initialLng != null
        ? LatLng(widget.initialLat!, widget.initialLng!)
        : null;

    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Location location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        // Don't request service automatically - just use default location
        setState(() => _isLoading = false);
        return;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        // Don't request permission automatically - just use default location
        setState(() => _isLoading = false);
        return;
      }

      final locationData = await location.getLocation();
      final currentPos = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );

      setState(() {
        _isLoading = false;
      });

      // Only center the map on current location, DON'T set it as selected
      if (_mapController != null && _selectedLocation == null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentPos, 15),
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Use current location as the selected location (mobile only)
  Future<void> _useCurrentLocation() async {
    setState(() {
      _isSearching = true;
      _showPredictions = false;
    });

    try {
      // Use location package for mobile
      Location location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception('Location service not enabled');
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permission denied');
        }
      }

      final locationData = await location.getLocation();
      final currentPos = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );

      setState(() {
        _selectedLocation = currentPos;
        _isSearching = false;
      });

      // Get address for current location
      await _getAddressFromLatLng(currentPos);

      // Animate to current location
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentPos, 15),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Using your current location')),
        );
      }
    } catch (e) {
      debugPrint('❌ Error getting current location: $e');
      setState(() => _isSearching = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not get current location: ${e.toString()}'),
          ),
        );
      }
    }
  }

  /// Get autocomplete predictions from Google Places API via Cloud Functions
  Future<void> _getPlacePredictions(String input) async {
    if (input.isEmpty || input.length < 2) {
      setState(() {
        _predictions = [];
        // Keep dropdown visible on mobile to show "My Current Location"
        _showPredictions = !kIsWeb || input.isNotEmpty;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final placesService = PlacesService();
      debugPrint('🔍 Fetching autocomplete for: $input');

      final predictions = await placesService.getAutocomplete(
        input,
        components: 'country:ae|country:eg|country:sa',
      );

      debugPrint('📡 Got ${predictions.length} predictions');

      if (predictions.isNotEmpty) {
        setState(() {
          _predictions = predictions;
          _showPredictions = true;
          _isSearching = false;
        });
      } else {
        // No results found - keep dropdown visible on mobile for "My Current Location"
        setState(() {
          _predictions = [];
          _showPredictions = !kIsWeb; // Keep visible on mobile
          _isSearching = false;
        });
        if (mounted && input.length >= 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No locations found for "$input". Try a different search.',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Autocomplete error: $e');
      setState(() {
        _isSearching = false;
        _predictions = [];
        _showPredictions =
            !kIsWeb; // Keep visible on mobile for "My Current Location"
      });
    }
  }

  /// Get place details and coordinates from place ID via Cloud Functions
  Future<void> _selectPlace(PlacePrediction prediction) async {
    setState(() {
      _isSearching = true;
      _showPredictions = false;
      _searchController.text = prediction.description;
    });

    try {
      final placesService = PlacesService();
      debugPrint('🔍 Fetching details for place: ${prediction.placeId}');

      final details = await placesService.getPlaceDetails(prediction.placeId);

      if (details != null) {
        final latLng = LatLng(details.lat, details.lng);

        setState(() {
          _selectedLocation = latLng;
          _selectedAddress = details.address;
          _searchController.text = details.address;
          _isSearching = false;
        });

        debugPrint('✅ Place selected: ${details.address}');

        // Animate to location
        await _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 15),
        );
      } else {
        throw Exception('Place details not found');
      }
    } catch (e) {
      debugPrint('❌ Place details error: $e');
      setState(() => _isSearching = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not load place details')),
        );
      }
    }
  }

  /// Get address from coordinates using Cloud Functions (not used in current flow)
  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      final placesService = PlacesService();
      debugPrint(
        '🔍 Reverse geocoding: ${latLng.latitude}, ${latLng.longitude}',
      );

      final address = await placesService.reverseGeocode(
        latLng.latitude,
        latLng.longitude,
      );

      if (address != null) {
        setState(() {
          _selectedAddress = address;
          _searchController.text = address;
        });
        debugPrint('✅ Got address: $address');
      } else {
        // Fallback to coordinates
        setState(() {
          _selectedAddress =
              '${latLng.latitude.toStringAsFixed(6)}, ${latLng.longitude.toStringAsFixed(6)}';
          _searchController.text = _selectedAddress!;
        });
      }
    } catch (e) {
      debugPrint('❌ Error getting address: $e');
      setState(() {
        _selectedAddress =
            '${latLng.latitude.toStringAsFixed(6)}, ${latLng.longitude.toStringAsFixed(6)}';
        _searchController.text = _selectedAddress!;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _getPlacePredictions(query);
    });
  }

  // Map tapping is disabled - users must select from autocomplete
  void _onMapTap(LatLng latLng) {
    // Do nothing - force users to use autocomplete only
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      Navigator.of(context).pop({
        'lat': _selectedLocation!.latitude,
        'lng': _selectedLocation!.longitude,
        'address':
            _selectedAddress ??
            '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: _onSearchChanged,
                    onTap: () {
                      setState(() {
                        _showPredictions = true;
                      });
                    },
                    readOnly: false,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                      hintText:
                          'Search for a place (e.g., "Dubai Mall", "Cairo Tower")',
                      helperText:
                          'Type to see suggestions, then tap one to select',
                      helperMaxLines: 2,
                      prefixIcon: _isSearching
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _predictions = [];
                                  _showPredictions = false;
                                  _selectedLocation = null;
                                  _selectedAddress = null;
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),

                  // Autocomplete suggestions dropdown
                  if (_showPredictions && (_predictions.isNotEmpty || !kIsWeb))
                    Builder(
                      builder: (context) {
                        debugPrint(
                          '🎨 Rendering dropdown: showPredictions=$_showPredictions, predictions=${_predictions.length}, isWeb=$kIsWeb',
                        );
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          constraints: const BoxConstraints(
                            minHeight: 50,
                            maxHeight: 250,
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            children: [
                              // "My Current Location" option (only on mobile - web geolocation has issues)
                              if (!kIsWeb)
                                ListTile(
                                  dense: true,
                                  leading: const Icon(
                                    Icons.my_location,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                  title: const Text(
                                    'My Current Location',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  onTap: _useCurrentLocation,
                                ),
                              if (!kIsWeb && _predictions.isNotEmpty)
                                const Divider(height: 8),
                              if (_predictions.isNotEmpty) ...[
                                // Place predictions
                                ..._predictions.map(
                                  (prediction) => ListTile(
                                    dense: true,
                                    leading: const Icon(
                                      Icons.location_on,
                                      size: 20,
                                    ),
                                    title: Text(
                                      prediction.mainText,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      prediction.secondaryText,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    onTap: () => _selectPlace(prediction),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Instructions
            if (!_showPredictions && _selectedLocation == null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Start typing a location name to see suggestions, then select one from the list.',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),

            // Map
            Container(
              height: 280,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _selectedLocation ?? _defaultLocation,
                          zoom: 14,
                        ),
                        onMapCreated: (controller) {
                          _mapController = controller;
                          if (_selectedLocation != null) {
                            controller.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                _selectedLocation!,
                                15,
                              ),
                            );
                          }
                        },
                        onTap: _onMapTap,
                        markers: _selectedLocation != null
                            ? {
                                Marker(
                                  markerId: const MarkerId('selected'),
                                  position: _selectedLocation!,
                                  draggable:
                                      false, // Disable dragging - force autocomplete
                                ),
                              }
                            : {},
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        mapType: MapType.normal,
                        compassEnabled: true,
                        rotateGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                      ),
                    ),
            ),

            // Selected location info or warning
            if (_selectedLocation != null && _selectedAddress != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Selected Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedAddress!,
                            style: const TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else if (_searchController.text.isNotEmpty && !_showPredictions)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please select a location from the suggestions list',
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),

            // Confirm button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedLocation != null
                      ? _confirmLocation
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: _selectedLocation != null
                        ? null
                        : Colors.grey[300],
                  ),
                  child: Text(
                    _selectedLocation != null
                        ? 'Confirm Location'
                        : 'Select a location from suggestions',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
