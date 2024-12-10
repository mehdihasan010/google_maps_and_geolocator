import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  LatLng? _currentLocation;
  LatLng? _previousLocation;
  final List<LatLng> _polylineCoordinates = [];
  Timer? _timer;

  LatLng? get currentLocation => _currentLocation;
  LatLng? get previousLocation => _previousLocation;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;

  LocationProvider() {
    _initializeLocationUpdates();
  }

  /// Initialize location updates and handle permissions
  Future<void> _initializeLocationUpdates() async {
    if (!await _checkAndRequestPermission()) {
      // Notify listeners if permissions are denied
      notifyListeners();
      return;
    }

    // Start updating the location periodically
    await _startLocationUpdates();
  }

  /// Check and request location permissions
  Future<bool> _checkAndRequestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Start fetching the user's location periodically
  Future<void> _startLocationUpdates() async {
    // Get the initial location
    Position position = await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentLocation = LatLng(position.latitude, position.longitude);
    _polylineCoordinates.add(_currentLocation!);
    notifyListeners();

    // Start periodic updates
    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      Position newPosition = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );
      _previousLocation = _currentLocation;
      _currentLocation = LatLng(newPosition.latitude, newPosition.longitude);

      // Add polyline points
      if (_previousLocation != null) {
        _polylineCoordinates.add(_previousLocation!);
        _polylineCoordinates.add(_currentLocation!);
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
