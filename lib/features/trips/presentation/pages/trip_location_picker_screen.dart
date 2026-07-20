import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class TripLocationSelection {
  const TripLocationSelection({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  String get coordinateLabel =>
      '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
}

class TripLocationPickerScreen extends StatefulWidget {
  const TripLocationPickerScreen({
    super.key,
    required this.title,
    this.initialLatitude,
    this.initialLongitude,
  });

  final String title;
  final double? initialLatitude;
  final double? initialLongitude;

  @override
  State<TripLocationPickerScreen> createState() =>
      _TripLocationPickerScreenState();
}

class _TripLocationPickerScreenState extends State<TripLocationPickerScreen> {
  static final Uri _openStreetMapCopyrightUri = Uri.parse(
    'https://www.openstreetmap.org/copyright',
  );

  late LatLng _selected;

  Future<void> _openOpenStreetMapCopyright() async {
    try {
      final launched = await launchUrl(
        _openStreetMapCopyrightUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open map licence details.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open map licence details.')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final validInitial =
        widget.initialLatitude != null &&
        widget.initialLongitude != null &&
        (widget.initialLatitude != 0 || widget.initialLongitude != 0);
    _selected = validInitial
        ? LatLng(widget.initialLatitude!, widget.initialLongitude!)
        : const LatLng(39.8283, -98.5795);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.touch_app_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tap the map to place the pin. You can pan and zoom before confirming.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _selected,
                initialZoom: widget.initialLatitude == null ? 3.5 : 13,
                minZoom: 2,
                maxZoom: 18,
                onTap: (_, location) => setState(() => _selected = location),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${_selected.latitude.toStringAsFixed(5)}, ${_selected.longitude.toStringAsFixed(5)}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: () => Navigator.pop(
                      context,
                      TripLocationSelection(
                        latitude: _selected.latitude,
                        longitude: _selected.longitude,
                      ),
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text('Use this location'),
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
