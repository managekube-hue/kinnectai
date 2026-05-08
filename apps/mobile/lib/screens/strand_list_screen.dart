import 'package:flutter/material.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';

class StrandListScreen extends StatefulWidget {
  const StrandListScreen({super.key});

  @override
  State<StrandListScreen> createState() => _StrandListScreenState();
}

class _StrandListScreenState extends State<StrandListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Strands'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Strand ${index + 1}'),
            subtitle: const Text('Family lineage strand'),
            leading: Icon(Icons.account_tree, color: Colors.grey[400]),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => AppNav.push(context, '/strand/${index + 1}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: KinnectColors.accent,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}



