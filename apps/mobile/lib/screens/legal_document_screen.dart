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
        ? 'https://kinnectai.com/legal/terms' // TODO: Replace with actual CDN URL
        : 'https://kinnectai.com/legal/privacy'; // TODO: Replace with actual CDN URL
    
    _title = widget.documentType == 'terms'
        ? 'Terms of Service'
        : 'Privacy Policy';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(KinnectColors.darkBg)
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
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.white),
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
              color: KinnectColors.darkBg,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(KinnectColors.amber),
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
        color: KinnectColors.darkSurface,
        border: Border(
          top: BorderSide(
            color: KinnectColors.grey40,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Text(
          'v1.0 — Updated 2026-01-15',
          style: KinnectTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
