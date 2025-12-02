import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/models/tracking_model.dart';
import '../providers/tracking_provider.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  final String tripId;
  final bool isDriver;

  const TrackingScreen({
    super.key,
    required this.tripId,
    this.isDriver = false,
  });

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  GoogleMapController? _mapController;
  final LocationTrackingService _trackingService = LocationTrackingService();
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    if (widget.isDriver) {
      _initDriverTracking();
    }
  }

  Future<void> _initDriverTracking() async {
    final hasPermission = await _trackingService.requestPermission();
    if (!hasPermission && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission required for tracking')),
      );
    }
  }

  @override
  void dispose() {
    _trackingService.stopLocationUpdates();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackingAsync = ref.watch(tripTrackingProvider(widget.tripId));
    final liveLocationAsync = ref.watch(liveLocationProvider(widget.tripId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Tracking'),
        actions: [
          if (widget.isDriver)
            Switch(
              value: _isTracking,
              onChanged: (value) => _toggleTracking(value),
              activeColor: Colors.green,
            ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          liveLocationAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (location) => _buildMap(location),
          ),
          // Info Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: trackingAsync.when(
              loading: () => const SizedBox(),
              error: (e, _) => const SizedBox(),
              data: (tracking) => _buildInfoPanel(tracking, liveLocationAsync.value),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isDriver
          ? FloatingActionButton.extended(
              onPressed: _isTracking ? _shareLocation : null,
              icon: const Icon(Icons.share_location),
              label: const Text('Share'),
              backgroundColor: _isTracking ? null : Colors.grey,
            )
          : null,
    );
  }

  Widget _buildMap(LiveLocation? location) {
    final initialPosition = location != null
        ? LatLng(location.latitude, location.longitude)
        : const LatLng(0, 0);

    final markers = <Marker>{};
    if (location != null) {
      markers.add(Marker(
        markerId: const MarkerId('driver'),
        position: LatLng(location.latitude, location.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Driver Location'),
      ));
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: initialPosition, zoom: 15),
      markers: markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (controller) {
        _mapController = controller;
        if (location != null) {
          controller.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(location.latitude, location.longitude),
              15,
            ),
          );
        }
      },
    );
  }

  Widget _buildInfoPanel(TripTracking? tracking, LiveLocation? location) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: tracking?.isActive == true ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tracking?.isActive == true ? 'LIVE' : 'INACTIVE',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Trip #${widget.tripId.substring(0, 8)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (location != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(Icons.speed, '${(location.speed ?? 0).toStringAsFixed(1)} km/h', 'Speed'),
                _buildInfoItem(Icons.explore, '${(location.heading ?? 0).toStringAsFixed(0)}°', 'Heading'),
                _buildInfoItem(Icons.gps_fixed, '${(location.accuracy ?? 0).toStringAsFixed(0)}m', 'Accuracy'),
              ],
            ),
          ],
          if (tracking?.estimatedDurationMinutes != null) ...[
            const SizedBox(height: 12),
            Text(
              'ETA: ${tracking!.estimatedDurationMinutes} min',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Future<void> _toggleTracking(bool enable) async {
    if (enable) {
      await _trackingService.startLocationUpdates(
        tripId: widget.tripId,
        userId: 'current_user_id', // Replace with actual user ID
      );
    } else {
      _trackingService.stopLocationUpdates();
    }
    setState(() => _isTracking = enable);
  }

  void _shareLocation() {
    // Share tracking link
    final trackingLink = 'https://fitareeaee.app/track/${widget.tripId}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share link: $trackingLink')),
    );
  }
}

