import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';

class RealTimeLocationTracker extends StatelessWidget {
  const RealTimeLocationTracker({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    if (locationProvider.currentLocation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Real-Time Location Tracker')),
        body: const Center(
          child: Text(
            'Please enable location permissions and services.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Location Tracker'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          controller.animateCamera(
            CameraUpdate.newLatLng(locationProvider.currentLocation!),
          );
        },
        initialCameraPosition: CameraPosition(
          target: locationProvider.currentLocation!,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: locationProvider.currentLocation!,
            infoWindow: InfoWindow(
              title: 'My Current Location',
              snippet:
                  '${locationProvider.currentLocation!.latitude}, ${locationProvider.currentLocation!.longitude}',
            ),
          ),
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            points: locationProvider.polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        },
      ),
    );
  }
}
