import 'package:flutter/material.dart';
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
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
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
            onTap: () => Navigator.pushNamed(
              context,
              '/strand/${index + 1}',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: KinnectColors.amber,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
