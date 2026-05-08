import 'package:flutter/material.dart';
import '../theme/colors.dart';

class MemoryEditScreen extends StatefulWidget {
  final String memoryId;

  const MemoryEditScreen({super.key, required this.memoryId});

  @override
  State<MemoryEditScreen> createState() => _MemoryEditScreenState();
}

class _MemoryEditScreenState extends State<MemoryEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Edit Memory'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  filled: true,
                  fillColor: KinnectColors.darkCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: KinnectColors.grey40),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description field
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: KinnectColors.darkCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: KinnectColors.grey40),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tags field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tags (comma separated)',
                  filled: true,
                  fillColor: KinnectColors.darkCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: KinnectColors.grey40),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 8),

              // Delete button
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Delete Memory'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
