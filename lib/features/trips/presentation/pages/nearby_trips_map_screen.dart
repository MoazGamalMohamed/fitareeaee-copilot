import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../domain/entities/trip.dart';
import '../providers/trip_provider.dart';

class NearbyTripsMapScreen extends ConsumerStatefulWidget {
  const NearbyTripsMapScreen({super.key});

  @override
  ConsumerState<NearbyTripsMapScreen> createState() => _NearbyTripsMapScreenState();
}

class _NearbyTripsMapScreenState extends ConsumerState<NearbyTripsMapScreen> {
  GoogleMapController? _mapController;
  final Location _location = Location();
  LatLng? _currentLocation;
  bool _isLoading = true;
  String? _errorMessage;
  Trip? _selectedTrip;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          setState(() {
            _errorMessage = 'Location services are disabled';
            _isLoading = false;
          });
          return;
        }
      }

      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != PermissionStatus.granted) {
          setState(() {
            _errorMessage = 'Location permission denied';
            _isLoading = false;
          });
          return;
        }
      }

      final locationData = await _location.getLocation();
      setState(() {
        _currentLocation = LatLng(
          locationData.latitude ?? 0,
          locationData.longitude ?? 0,
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting location: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(availableTripsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => context.push('/trips'),
            tooltip: 'List View',
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerOnCurrentLocation,
            tooltip: 'My Location',
          ),
        ],
      ),
      body: _buildBody(tripsAsync),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/trips/create'),
        icon: const Icon(Icons.add),
        label: const Text('Create Trip'),
      ),
    );
  }

  Widget _buildBody(AsyncValue<List<Trip>> tripsAsync) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initLocation,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return tripsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading trips: $e')),
      data: (trips) => _buildMapWithTrips(trips),
    );
  }

  Widget _buildMapWithTrips(List<Trip> trips) {
    final markers = _buildMarkers(trips);
    final initialPosition = _currentLocation ?? const LatLng(0, 0);

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: initialPosition, zoom: 12),
          markers: markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (controller) => _mapController = controller,
          onTap: (_) => setState(() => _selectedTrip = null),
        ),
        if (_selectedTrip != null) _buildTripInfoCard(_selectedTrip!),
      ],
    );
  }

  Set<Marker> _buildMarkers(List<Trip> trips) {
    final markers = <Marker>{};
    for (final trip in trips) {
      markers.add(Marker(
        markerId: MarkerId('trip_${trip.id}'),
        position: LatLng(trip.originLat, trip.originLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          trip.isOffer ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueOrange,
        ),
        infoWindow: InfoWindow(
          title: trip.isOffer ? 'Offering' : 'Requesting',
          snippet: '${trip.originAddress} → ${trip.destinationAddress}',
        ),
        onTap: () => setState(() => _selectedTrip = trip),
      ));
    }
    return markers;
  }

  Widget _buildTripInfoCard(Trip trip) {
    return Positioned(
      bottom: 100,
      left: 16,
      right: 16,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: trip.isOffer ? Colors.blue : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      trip.isOffer ? 'OFFERING' : 'REQUESTING',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(label: Text(trip.typeDisplay, style: const TextStyle(fontSize: 10)), visualDensity: VisualDensity.compact),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _selectedTrip = null), visualDensity: VisualDensity.compact),
                ],
              ),
              const SizedBox(height: 8),
              Text('${trip.originAddress} → ${trip.destinationAddress}', style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(trip.priceDisplay, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(trip.timeDisplay, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => context.push('/trips/${trip.id}'), child: const Text('View Details'))),
            ],
          ),
        ),
      ),
    );
  }

  void _centerOnCurrentLocation() {
    if (_currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(_currentLocation!, 14));
    }
  }
}
