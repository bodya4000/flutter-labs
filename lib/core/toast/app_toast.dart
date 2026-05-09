import 'package:flutter/material.dart';

import 'package:unik_mobile/core/toast/toast_animation_bubble.dart';
import 'package:unik_mobile/core/toast/toast_contract.dart';
import 'package:unik_mobile/core/toast/toast_tray_decoration.dart';

export 'toast_contract.dart';

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
        Overlay.maybeOf(context, rootOverlay: true) ?? Overlay.maybeOf(context);
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

    final trimmed = message.trim();
    entry = OverlayEntry(
      builder: (ctx) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: ToastAnimatedBubble(
                  message: trimmed,
                  decoration: toastTrayDecoration(variant),
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
