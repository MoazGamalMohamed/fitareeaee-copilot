import 'package:flutter/material.dart';
import '../../../../core/services/location_permission_service.dart';

class LocationPermissionGate extends StatefulWidget {
  final Widget child;

  const LocationPermissionGate({
    super.key,
    required this.child,
  });

  @override
  State<LocationPermissionGate> createState() => _LocationPermissionGateState();
}

class _LocationPermissionGateState extends State<LocationPermissionGate> {
  final LocationPermissionService _locationService = LocationPermissionService();
  bool _isChecking = true;
  bool _hasPermission = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    setState(() {
      _isChecking = true;
      _errorMessage = '';
    });

    final status = await _locationService.checkLocationPermission();

    setState(() {
      _isChecking = false;
      _hasPermission = status == LocationPermissionStatus.granted;
      
      if (!_hasPermission) {
        if (status == LocationPermissionStatus.serviceDisabled) {
          _errorMessage = 'Location services are disabled. Please enable location services to use this app.';
        } else {
          _errorMessage = 'Location permission is required to use this app.';
        }
      }
    });
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isChecking = true;
      _errorMessage = '';
    });

    final hasPermission = await _locationService.requestLocationPermission();

    setState(() {
      _isChecking = false;
      _hasPermission = hasPermission;
      
      if (!hasPermission) {
        _errorMessage = 'Location permission is required. Please grant location access in your device settings.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Checking location permission...'),
            ],
          ),
        ),
      );
    }

    if (!_hasPermission) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_rounded,
                  size: 100,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 24),
                Text(
                  'Location Access Required',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage.isNotEmpty
                      ? _errorMessage
                      : 'Fitareeaee needs access to your location to provide ride-sharing services. This helps us match you with drivers and track your trips.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _requestPermission,
                  icon: const Icon(Icons.location_on),
                  label: const Text('Grant Location Access'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _checkPermission,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
