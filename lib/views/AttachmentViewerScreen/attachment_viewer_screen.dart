import 'package:flutter/material.dart';
import '../../widgets/analytics_screen_mixin.dart';

/// Foto do anexo em tela cheia, com zoom por pinça.
class AttachmentViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const AttachmentViewerScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<AttachmentViewerScreen> createState() => _AttachmentViewerScreenState();
}

class _AttachmentViewerScreenState extends State<AttachmentViewerScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'AttachmentViewerScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 5,
        child: Center(
          child: Image.network(
            widget.url,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : const CircularProgressIndicator(color: Colors.white),
            errorBuilder: (_, _, _) => Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
