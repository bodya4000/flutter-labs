import 'package:flutter/material.dart';

import 'package:unik_mobile/core/theme/app_theme.dart';

enum AppToastVariant { neutral, error, success }

abstract final class AppToast {
  static OverlayEntry? _active;

  static void dismiss() {
    _active?.remove();
    _active = null;
  }

  static void show(
    BuildContext context,
    String message, {
    AppToastVariant variant = AppToastVariant.neutral,
    Duration visibleFor = const Duration(milliseconds: 2400),
  }) {
    final overlay =
        Overlay.maybeOf(context, rootOverlay: true) ??
        Overlay.maybeOf(context);
    if (overlay == null || message.trim().isEmpty) {
      return;
    }

    dismiss();

    late OverlayEntry entry;
    var removed = false;
    void teardown() {
      if (removed) {
        return;
      }
      removed = true;
      if (_active == entry) {
        _active = null;
      }
      entry.remove();
    }

    entry = OverlayEntry(
      builder: (ctx) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: _ToastBubble(
                  message: message.trim(),
                  variant: variant,
                  visibleFor: visibleFor,
                  onDismissed: teardown,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    _active = entry;
    overlay.insert(entry);
  }
}

class _ToastBubble extends StatefulWidget {
  const _ToastBubble({
    required this.message,
    required this.variant,
    required this.visibleFor,
    required this.onDismissed,
  });

  final String message;
  final AppToastVariant variant;
  final Duration visibleFor;
  final VoidCallback onDismissed;

  @override
  State<_ToastBubble> createState() => _ToastBubbleState();
}

class _ToastBubbleState extends State<_ToastBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
      reverseDuration: const Duration(milliseconds: 280),
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.33, 1, 0.68, 1),
      reverseCurve: const Cubic(0.33, 0, 1, 0.36),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runCycle();
    });
  }

  Future<void> _runCycle() async {
    if (!mounted) {
      return;
    }
    await _controller.forward(from: 0);
    if (!mounted) {
      return;
    }
    await Future<void>.delayed(widget.visibleFor);
    if (!mounted) {
      return;
    }
    await _controller.reverse();
    if (!mounted) {
      return;
    }
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    widget.onDismissed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final Decoration decoration = switch (widget.variant) {
      AppToastVariant.neutral => BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 28,
            offset: Offset(0, 12),
            color: Color(0x66000000),
          ),
        ],
      ),
      AppToastVariant.error => BoxDecoration(
        color: const Color(0xFF3B1F29),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppTheme.error.withValues(alpha: 0.55),
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 28,
            offset: Offset(0, 12),
            color: Color(0x66000000),
          ),
        ],
      ),
      AppToastVariant.success => BoxDecoration(
        color: const Color(0xFF1F3B30),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: const Color(0xFF4ADE80).withValues(alpha: 0.45),
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 28,
            offset: Offset(0, 12),
            color: Color(0x66000000),
          ),
        ],
      ),
    };

    final TextStyle baseStyle =
        Theme.of(context).textTheme.bodyMedium ??
        const TextStyle(fontSize: 15, height: 1.35);

    return Align(
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.42),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _controller,
              curve: const Cubic(0.33, 1, 0.68, 1),
              reverseCurve: const Cubic(0.33, 0, 1, 0.36),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.s24,
              right: AppSpacing.s24,
              top: AppSpacing.s24 + padding.top,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Material(
                type: MaterialType.transparency,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: DecoratedBox(
                    decoration: decoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s20,
                        vertical: AppSpacing.s16,
                      ),
                      child: Text(
                        widget.message,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: baseStyle.copyWith(
                          color: AppTheme.onSurface,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
