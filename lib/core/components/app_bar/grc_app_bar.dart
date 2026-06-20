import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:grc/core/components/app_bar/app_breadcrumbs.dart';
import 'package:grc/core/config/app_colors.dart';

class GrcAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<GrcBreadcrumbItem>? breadcrumbs;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool? centerTitle;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const GrcAppBar({
    super.key,
    required this.title,
    this.breadcrumbs,
    this.titleWidget,
    this.leading,
    this.actions,
    this.centerTitle,
    this.elevation,
    this.scrolledUnderElevation,
    this.backgroundColor,
    this.foregroundColor,
  });

  bool get _showBreadcrumbs =>
      kIsWeb && breadcrumbs != null && breadcrumbs!.length > 1;

  Widget _buildTitle(BuildContext context) {
    if (titleWidget != null && !_showBreadcrumbs) {
      return titleWidget!;
    }

    if (_showBreadcrumbs) {
      return BreadCrumb(
        items: [
          for (var i = 0; i < breadcrumbs!.length; i++)
            _toBreadCrumbItem(
              context,
              breadcrumbs![i],
              isLast: i == breadcrumbs!.length - 1,
            ),
        ],
        divider: const Icon(
          Icons.chevron_right,
          size: 16,
          color: Color(AppColors.textSecondary),
        ),
        overflow: ScrollableOverflow(
          keepLastDivider: false,
          direction: Axis.horizontal,
        ),
      );
    }

    if (titleWidget != null) {
      return titleWidget!;
    }

    return Text(title);
  }

  BreadCrumbItem _toBreadCrumbItem(
    BuildContext context,
    GrcBreadcrumbItem item, {
    required bool isLast,
  }) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleMedium?.copyWith(
      fontSize: 15,
      fontWeight: isLast ? FontWeight.w600 : FontWeight.w500,
      color: isLast
          ? const Color(AppColors.text)
          : const Color(AppColors.primary),
    );

    if (isLast || !item.isNavigable) {
      return BreadCrumbItem(
        content: Text(
          item.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style?.copyWith(color: const Color(AppColors.text)),
        ),
      );
    }

    return BreadCrumbItem(
      content: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      actions: actions,
      centerTitle: _showBreadcrumbs ? false : (centerTitle ?? true),
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      title: _buildTitle(context),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
