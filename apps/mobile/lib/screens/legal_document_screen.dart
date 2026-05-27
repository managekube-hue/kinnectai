import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';

class LegalDocumentScreen extends StatefulWidget {
  final String documentType; // 'terms' or 'privacy'
  
  const LegalDocumentScreen({
    super.key,
    required this.documentType,
  });

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _title = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    // Determine URL and title based on document type
    final url = widget.documentType == 'terms'
        ? 'https://kinnectai.app/legal/terms'
        : 'https://kinnectai.app/legal/privacy';
    
    _title = widget.documentType == 'terms'
        ? 'Terms of Service'
        : 'Privacy Policy';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(KinnectColors.background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _title,
          style: KinnectTextStyles.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          
          if (_isLoading)
            Container(
              color: KinnectColors.background,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(KinnectColors.accent),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildVersionInfo(),
    );
  }

  Widget _buildVersionInfo() {
    return Container(
      padding: const EdgeInsets.all(KinnectSpacing.md),
      decoration: const BoxDecoration(
        color: KinnectColors.surface,
        border: Border(
          top: BorderSide(
            color: KinnectColors.textMuted,
            width: 1,
          ),
        ),
      ),
      child: const SafeArea(
        child: Text(
          'v1.0 â€” Updated 2026-01-15',
          style: KinnectTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

