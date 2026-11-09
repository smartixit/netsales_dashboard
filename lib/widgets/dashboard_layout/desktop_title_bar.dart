import 'package:desktop_windowing/desktop_windowing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

/// Enterprise frameless desktop window title bar with native drag and window controls.
class DesktopTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const DesktopTitleBar({
    super.key,
    this.title,
    this.showControls = true,
    this.backgroundColor,
    this.foregroundColor,
    this.leading,
    this.actions,
  });

  final String? title;
  final bool showControls;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? leading;
  final List<Widget>? actions;

  static const double titleBarHeight = 38.0;

  @override
  Size get preferredSize => const Size.fromHeight(titleBarHeight);

  bool get _isDesktop =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS);

  @override
  Widget build(BuildContext context) {
    if (!_isDesktop) {
      return const SizedBox.shrink();
    }

    final colors = context.colors;
    final windowing = Get.isRegistered<DesktopWindowingController>()
        ? Get.find<DesktopWindowingController>()
        : null;

    final bg = backgroundColor ?? colors.surface;
    final fg = foregroundColor ?? colors.onSurface.withValues(alpha: 0.82);

    return Container(
      height: titleBarHeight,
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.28),
            width: 0.8,
          ),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRect(
          child: Row(
            children: [
              // ── Comprehensive Draggable Area (Icon + Title + Central Region) ──
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (details) {
                    windowing?.startDragging();
                  },
                  onDoubleTap: () {
                    windowing?.performTitleBarDoubleClick();
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // إذا كانت المساحة المتوفرة في لحظة التصغير أقل من الحد الأدنى للعناصر الثابتة (37dp)
                      if (constraints.maxWidth < 40) {
                        return const SizedBox.shrink();
                      }

                      return Row(
                        children: [
                          AppSpacing.hMd,
                          leading ??
                              Image.asset(
                                'assets/images/brand_icon.png',
                                width: 17,
                                height: 17,
                                fit: BoxFit.contain,
                                errorBuilder: (context, obj, e) => Icon(
                                  Icons.hub_rounded,
                                  size: 16,
                                  color: colors.primary,
                                ),
                              ),
                          AppSpacing.hSm,
                          Expanded(
                            child: Text(
                              title ?? 'NetSales Platform Dashboard',
                              style: AppTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.5,
                                color: fg,
                                letterSpacing: 0.15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // ── Optional Trailing Actions ──
              ...?actions,

              // ── Native-Style Window Caption Buttons ──
              if (showControls && windowing != null) ...[
                _WindowCaptionButton(
                  icon: Icons.remove_rounded,
                  tooltip: 'تصغير النافذة',
                  onPressed: windowing.minimize,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: windowing.isMaximizedListenable,
                  builder: (context, isMax, _) {
                    return _WindowCaptionButton(
                      icon: isMax
                          ? Icons.filter_none_rounded
                          : Icons.crop_square_rounded,
                      tooltip: isMax ? 'استعادة' : 'تكبير',
                      iconSize: 13,
                      onPressed: windowing.toggleMaximize,
                    );
                  },
                ),
                _WindowCaptionButton(
                  icon: Icons.close_rounded,
                  tooltip: 'إغلاق',
                  isClose: true,
                  onPressed: windowing.close,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WindowCaptionButton extends StatelessWidget {
  const _WindowCaptionButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.isClose = false,
    this.iconSize = 14.0,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final bool isClose;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final button = SizedBox(
      width: 44,
      height: DesktopTitleBar.titleBarHeight,
      child: IconButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return isClose
                  ? const Color(0xFFE81123)
                  : colors.onSurface.withValues(alpha: 0.08);
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (isClose && states.contains(WidgetState.hovered)) {
              return Colors.white;
            }
            return colors.onSurface.withValues(alpha: 0.85);
          }),
          shape: WidgetStateProperty.all(const RoundedRectangleBorder()),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          minimumSize: WidgetStateProperty.all(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        icon: Icon(icon, size: iconSize),
        onPressed: onPressed,
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        waitDuration: const Duration(milliseconds: 600),
        child: button,
      );
    }
    return button;
  }
}
