import 'package:location/location.dart';

class LocationPermissionService {
  final Location _location = Location();

  /// Check if location services are enabled and permissions are granted
  Future<LocationPermissionStatus> checkLocationPermission() async {
    try {
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      // Check if location service is enabled with timeout
      serviceEnabled = await _location.serviceEnabled().timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );

      if (!serviceEnabled) {
        return LocationPermissionStatus.serviceDisabled;
      }

      // Check if permission is granted with timeout
      permissionGranted = await _location.hasPermission().timeout(
        const Duration(seconds: 5),
        onTimeout: () => PermissionStatus.denied,
      );

      if (permissionGranted == PermissionStatus.denied) {
        return LocationPermissionStatus.permissionDenied;
      }

      return LocationPermissionStatus.granted;
    } catch (e) {
      return LocationPermissionStatus.serviceDisabled;
    }
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      // First check if service is enabled
      bool serviceEnabled = await _location.serviceEnabled().timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );

      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService().timeout(
          const Duration(seconds: 10),
          onTimeout: () => false,
        );
        if (!serviceEnabled) {
          return false;
        }
      }

      // Then request permission
      PermissionStatus permissionGranted = await _location
          .hasPermission()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => PermissionStatus.denied,
          );

      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission().timeout(
          const Duration(seconds: 30),
          onTimeout: () => PermissionStatus.denied,
        );
      }

      return permissionGranted == PermissionStatus.granted;
    } catch (e) {
      return false;
    }
  }

  /// Get current location
  Future<LocationData?> getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return null;
      }
      return await _location.getLocation();
    } catch (e) {
      return null;
    }
  }
}

enum LocationPermissionStatus { granted, permissionDenied, serviceDisabled }
