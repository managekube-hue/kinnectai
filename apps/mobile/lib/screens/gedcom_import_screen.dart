import 'package:flutter/material.dart';
import '../theme/colors.dart';

class GedcomImportScreen extends StatefulWidget {
  const GedcomImportScreen({super.key});

  @override
  State<GedcomImportScreen> createState() => _GedcomImportScreenState();
}

class _GedcomImportScreenState extends State<GedcomImportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Import GEDCOM'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Import Family Tree',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Upload a GEDCOM file to import your family tree data',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // File upload area
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: KinnectColors.accent),
                  borderRadius: BorderRadius.circular(12),
                  color: KinnectColors.surfaceElevated.withOpacity(0.5),
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 48,
                      color: KinnectColors.accent,
                    ),
                    const SizedBox(height: 16),
                    const Text('Tap to select GEDCOM file'),
                    const SizedBox(height: 8),
                    Text(
                      'or drag and drop',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(onPressed: () {}, child: const Text('Import')),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
