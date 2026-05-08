import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/colors.dart';

class StewardAgreementScreen extends StatelessWidget {
  const StewardAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Steward Agreement'),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadRequest(Uri.parse('https://kinnect.ai/legal/steward-agreement')),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: KinnectColors.surface,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KinnectColors.accent,
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('I Accept', style: TextStyle(color: KinnectColors.background, fontSize: 16)),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Decline', style: TextStyle(color: KinnectColors.textSecondary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
