import 'package:flutter/material.dart';
import '../../extensions/build_context_extensions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AsyncPageLoader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showLoading;
  final IconData icon;

  const AsyncPageLoader({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.showLoading = false,
  });

  factory AsyncPageLoader.loading({
    Key? key,
    String? title,
    String? subtitle,
  }) => AsyncPageLoader(
    key: key,
    icon: Icons.sync_rounded,
    title: title ?? 'Loading',
    subtitle: subtitle ?? 'Just a moment.',
    showLoading: true,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (showLoading)
                SizedBox(
                  width: 88,
                  height: 88,
                  child: LoadingAnimationWidget.halfTriangleDot(
                    color: context.cs.primary, //.withValues(alpha: .35),
                    size: 65,
                  ),
                )
              else
                Icon(
                  icon,
                  size: 72,
                  color: context.cs.primary.withValues(alpha: .85),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.cs.onSurface.withValues(alpha: .9),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: context.tt.bodyMedium?.copyWith(
                color: context.cs.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
