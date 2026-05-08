import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../theme/colors.dart';

class KinshipAlertMapScreen extends StatelessWidget {
  const KinshipAlertMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Kinship Alerts'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 12,
            ),
            markers: {
              const Marker(
                markerId: MarkerId('kin1'),
                position: LatLng(37.7749, -122.4194),
              ),
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: KinnectColors.surface,
              padding: const EdgeInsets.all(16),
              child: const Column(
                children: [
                  Text('Sarah Kim', style: TextStyle(color: KinnectColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('0.4 miles away • 12.5% Kin Score', style: TextStyle(color: KinnectColors.accent)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

