import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/models/tracking_model.dart';
import '../providers/tracking_provider.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  final String tripId;
  final bool isDriver;
  final double? originLat;
  final double? originLng;
  final double? destLat;
  final double? destLng;
  final String? originName;
  final String? destName;

  const TrackingScreen({
    super.key,
    required this.tripId,
    this.isDriver = false,
    this.originLat,
    this.originLng,
    this.destLat,
    this.destLng,
    this.originName,
    this.destName,
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
              activeTrackColor: Colors.green.withValues(alpha: 0.5),
              activeThumbColor: Colors.green,
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
    // Determine initial position
    LatLng initialPosition;
    if (location != null) {
      initialPosition = LatLng(location.latitude, location.longitude);
    } else if (widget.originLat != null && widget.originLng != null) {
      initialPosition = LatLng(widget.originLat!, widget.originLng!);
    } else {
      initialPosition = const LatLng(0, 0);
    }

    // Build markers
    final markers = <Marker>{};

    // Origin marker
    if (widget.originLat != null && widget.originLng != null) {
      markers.add(Marker(
        markerId: const MarkerId('origin'),
        position: LatLng(widget.originLat!, widget.originLng!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Pickup', snippet: widget.originName ?? 'Origin'),
      ));
    }

    // Destination marker
    if (widget.destLat != null && widget.destLng != null) {
      markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(widget.destLat!, widget.destLng!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Dropoff', snippet: widget.destName ?? 'Destination'),
      ));
    }

    // Driver location marker
    if (location != null) {
      markers.add(Marker(
        markerId: const MarkerId('driver'),
        position: LatLng(location.latitude, location.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Driver Location'),
      ));
    }

    // Build route polyline
    final polylines = <Polyline>{};
    if (widget.originLat != null && widget.originLng != null &&
        widget.destLat != null && widget.destLng != null) {
      polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: [
          LatLng(widget.originLat!, widget.originLng!),
          LatLng(widget.destLat!, widget.destLng!),
        ],
        color: Colors.blue,
        width: 4,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ));
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: initialPosition, zoom: 12),
      markers: markers,
      polylines: polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (controller) {
        _mapController = controller;
        _fitMapToBounds();
      },
    );
  }

  void _fitMapToBounds() {
    if (_mapController == null) return;

    final points = <LatLng>[];
    if (widget.originLat != null && widget.originLng != null) {
      points.add(LatLng(widget.originLat!, widget.originLng!));
    }
    if (widget.destLat != null && widget.destLng != null) {
      points.add(LatLng(widget.destLat!, widget.destLng!));
    }

    if (points.length >= 2) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b),
          points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b),
        ),
        northeast: LatLng(
          points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b),
          points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b),
        ),
      );
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
    }
  }

  Widget _buildInfoPanel(TripTracking? tracking, LiveLocation? location) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -2)),
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

