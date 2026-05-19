import 'package:flutter/material.dart';

import 'package:unik_mobile/core/theme/app_theme.dart';

class ToastAnimatedBubble extends StatefulWidget {
  const ToastAnimatedBubble({
    required this.message,
    required this.decoration,
    required this.visibleFor,
    required this.onDismissed,
    super.key,
  });

  final String message;

  final Decoration decoration;

  final Duration visibleFor;

  final VoidCallback onDismissed;

  @override
  State<ToastAnimatedBubble> createState() => _ToastAnimatedBubbleState();
}

class _ToastAnimatedBubbleState extends State<ToastAnimatedBubble>
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

    final TextStyle baseStyle =
        Theme.of(context).textTheme.bodyMedium ??
        const TextStyle(fontSize: 15, height: 1.35);

    return Align(
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position:
              Tween<Offset>(
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
                    decoration: widget.decoration,
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
