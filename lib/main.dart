import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/location_provider.dart';
import 'screens/real_time_location_tracker.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real-Time Location Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RealTimeLocationTracker(),
    );
  }
}
