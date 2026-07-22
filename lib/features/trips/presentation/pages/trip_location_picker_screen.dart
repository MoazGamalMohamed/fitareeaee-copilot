import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as device_location;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/location/open_street_map_geocoder.dart';

class TripLocationSelection {
  const TripLocationSelection({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.country,
  });

  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? country;

  String get coordinateLabel =>
      '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';

  String get readableLabel {
    final normalizedAddress = address?.trim() ?? '';
    return normalizedAddress.isEmpty ? coordinateLabel : normalizedAddress;
  }
}

typedef DeviceLocationProvider = Future<LatLng?> Function();

class TripLocationPickerScreen extends StatefulWidget {
  const TripLocationPickerScreen({
    super.key,
    required this.title,
    this.initialLatitude,
    this.initialLongitude,
    this.geocoder,
    this.deviceLocationProvider,
  });

  final String title;
  final double? initialLatitude;
  final double? initialLongitude;
  final AddressGeocoder? geocoder;
  final DeviceLocationProvider? deviceLocationProvider;

  @override
  State<TripLocationPickerScreen> createState() =>
      _TripLocationPickerScreenState();
}

class _TripLocationPickerScreenState extends State<TripLocationPickerScreen> {
  static final Uri _openStreetMapCopyrightUri = Uri.parse(
    'https://www.openstreetmap.org/copyright',
  );

  final _mapController = MapController();
  final _searchController = TextEditingController();
  late final AddressGeocoder _geocoder;
  late LatLng _selected;
  List<GeocodedPlace> _results = const [];
  GeocodedPlace? _selectedPlace;
  bool _searching = false;
  bool _resolvingPin = false;
  bool _locating = false;
  String? _searchError;
  int _pinRequestSequence = 0;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  String _copy(String english, String arabic) => _isArabic ? arabic : english;

  @override
  void initState() {
    super.initState();
    _geocoder = widget.geocoder ?? OpenStreetMapGeocoder();
    final validInitial =
        widget.initialLatitude != null &&
        widget.initialLongitude != null &&
        (widget.initialLatitude != 0 || widget.initialLongitude != 0);
    _selected = validInitial
        ? LatLng(widget.initialLatitude!, widget.initialLongitude!)
        : const LatLng(39.8283, -98.5795);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.length < 3) {
      setState(() {
        _searchError = _copy(
          'Enter at least 3 characters.',
          'أدخل 3 أحرف على الأقل.',
        );
        _results = const [];
      });
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _searching = true;
      _searchError = null;
    });
    try {
      final results = await _geocoder.search(
        query,
        language: _isArabic ? 'ar' : 'en',
      );
      if (!mounted) return;
      setState(() {
        _results = results;
        if (results.isEmpty) {
          _searchError = _copy(
            'No addresses found. Add a city or postal code, or place a pin.',
            'لم يتم العثور على عنوان. أضف مدينة أو رمزاً بريدياً، أو ضع دبوساً.',
          );
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _results = const [];
        _searchError = _copy(
          'Address search is temporarily unavailable. You can still place a pin.',
          'البحث عن العنوان غير متاح مؤقتاً. لا يزال بإمكانك وضع دبوس.',
        );
      });
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _selectPlace(GeocodedPlace place) {
    final point = LatLng(place.latitude, place.longitude);
    setState(() {
      _selected = point;
      _selectedPlace = place;
      _results = const [];
      _searchError = null;
      _searchController.text = place.displayName;
    });
    _mapController.move(point, 16);
  }

  Future<void> _selectPin(LatLng location, {double zoom = 16}) async {
    final requestSequence = ++_pinRequestSequence;
    setState(() {
      _selected = location;
      _selectedPlace = null;
      _results = const [];
      _resolvingPin = true;
      _searchError = null;
    });
    _mapController.move(location, zoom);
    try {
      final place = await _geocoder.reverse(
        location.latitude,
        location.longitude,
        language: _isArabic ? 'ar' : 'en',
      );
      if (!mounted || requestSequence != _pinRequestSequence) return;
      setState(() {
        _selectedPlace = place;
        if (place != null) _searchController.text = place.displayName;
      });
    } catch (_) {
      if (!mounted || requestSequence != _pinRequestSequence) return;
      setState(() {
        _searchError = _copy(
          'The pin is saved, but its street address could not be loaded.',
          'تم حفظ الدبوس، ولكن تعذر تحميل عنوان الشارع.',
        );
      });
    } finally {
      if (mounted && requestSequence == _pinRequestSequence) {
        setState(() => _resolvingPin = false);
      }
    }
  }

  Future<void> _useMyLocation() async {
    setState(() => _locating = true);
    try {
      final point = widget.deviceLocationProvider != null
          ? await widget.deviceLocationProvider!()
          : await _readDeviceLocation();
      if (!mounted) return;
      if (point == null) {
        _showMessage(
          _copy(
            'Location permission is required to use your current location.',
            'يلزم إذن الموقع لاستخدام موقعك الحالي.',
          ),
        );
        return;
      }
      await _selectPin(point);
    } catch (_) {
      if (mounted) {
        _showMessage(
          _copy(
            'Current location could not be read. Check location services and try again.',
            'تعذر قراءة الموقع الحالي. تحقق من خدمات الموقع وحاول مرة أخرى.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<LatLng?> _readDeviceLocation() async {
    final location = device_location.Location();
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await location.requestService();
    if (!serviceEnabled) return null;
    var permission = await location.hasPermission();
    if (permission == device_location.PermissionStatus.denied) {
      permission = await location.requestPermission();
    }
    if (permission != device_location.PermissionStatus.granted &&
        permission != device_location.PermissionStatus.grantedLimited) {
      return null;
    }
    final data = await location.getLocation();
    if (data.latitude == null || data.longitude == null) return null;
    return LatLng(data.latitude!, data.longitude!);
  }

  Future<void> _openOpenStreetMapCopyright() async {
    try {
      final launched = await launchUrl(
        _openStreetMapCopyrightUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        _showMessage(
          _copy(
            'Could not open map licence details.',
            'تعذر فتح تفاصيل ترخيص الخريطة.',
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        _showMessage(
          _copy(
            'Could not open map licence details.',
            'تعذر فتح تفاصيل ترخيص الخريطة.',
          ),
        );
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final selectedAddress = _selectedPlace?.displayName;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                children: [
                  TextField(
                    key: const ValueKey('map-address-search-field'),
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      labelText: _copy('Search address', 'ابحث عن عنوان'),
                      hintText: _copy(
                        'Street, city, state or postal code',
                        'الشارع أو المدينة أو الرمز البريدي',
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        key: const ValueKey('map-address-search-button'),
                        tooltip: _copy('Search', 'بحث'),
                        onPressed: _searching ? null : _search,
                        icon: _searching
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : const Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _copy(
                            'Choose a result or tap the map for a precise pin.',
                            'اختر نتيجة أو اضغط على الخريطة لوضع دبوس دقيق.',
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      TextButton.icon(
                        key: const ValueKey('map-current-location-button'),
                        onPressed: _locating ? null : _useMyLocation,
                        icon: _locating
                            ? const SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.my_location, size: 18),
                        label: Text(_copy('My location', 'موقعي')),
                      ),
                    ],
                  ),
                  if (_searchError case final error?)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        error,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_results.isNotEmpty)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 210),
              child: Material(
                elevation: 4,
                child: ListView.separated(
                  key: const ValueKey('map-address-results'),
                  shrinkWrap: true,
                  itemCount: _results.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final place = _results[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(
                        place.displayName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _selectPlace(place),
                    );
                  },
                ),
              ),
            ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selected,
                initialZoom: widget.initialLatitude == null ? 3.5 : 13,
                minZoom: 2,
                maxZoom: 18,
                onTap: (_, location) => _selectPin(location),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.fitareeaee.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selected,
                      width: 54,
                      height: 54,
                      child: const Icon(
                        Icons.location_pin,
                        size: 48,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SimpleAttributionWidget(
                  source: const Text('OpenStreetMap contributors'),
                  onTap: _openOpenStreetMapCopyright,
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_resolvingPin)
                    const LinearProgressIndicator(minHeight: 2)
                  else
                    Text(
                      selectedAddress ??
                          _copy(
                            'Pin: ${_selected.latitude.toStringAsFixed(5)}, ${_selected.longitude.toStringAsFixed(5)}',
                            'الدبوس: ${_selected.latitude.toStringAsFixed(5)}, ${_selected.longitude.toStringAsFixed(5)}',
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    key: const ValueKey('map-confirm-location-button'),
                    onPressed: () => Navigator.pop(
                      context,
                      TripLocationSelection(
                        latitude: _selected.latitude,
                        longitude: _selected.longitude,
                        address: _selectedPlace?.displayName,
                        city: _selectedPlace?.city,
                        country: _selectedPlace?.country,
                      ),
                    ),
                    icon: const Icon(Icons.check),
                    label: Text(
                      _copy('Use this location', 'استخدم هذا الموقع'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
