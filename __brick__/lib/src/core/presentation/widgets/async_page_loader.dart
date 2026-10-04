import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../extensions/build_context_extensions.dart';
import '../../failures/failure.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../errors/errors.dart';

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

  static Widget fromSnapshot<T>({
    required AsyncSnapshot<T> snapshot,
    Key? key,
    Widget Function(T data)? builder,
  }) {
    return switch (snapshot.connectionState) {
      ConnectionState.none => ErrorView(key: key, errorType: ErrorTypes.noData),
      ConnectionState.waiting ||
      ConnectionState.active => AsyncPageLoader.loading(key: key),
      ConnectionState.done => _onSnapshotDone<T>(key, snapshot, builder),
    };
  }

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

  static Widget _onSnapshotDone<T>(
    Key? key,
    AsyncSnapshot<T> snapshot,
    Widget Function(T data)? builder,
  ) {
    if (snapshot.hasError) {
      return ErrorView(
        key: key,
        title: 'Oops!',
        description: snapshot.error.toString(),
      );
    }

    if (snapshot.hasData && snapshot.data != none()) {
      if (builder == null) {
        return ErrorView(
          key: key,
          errorType: ErrorTypes.unknownError,
          title: 'Oops',
          description: "Something didn't work. Try again!",
        );
      }

      if (snapshot.data is Failure) {
        return ErrorView(
          key: key,
          errorType: ErrorTypes.unknownError,
          title: 'Oops',
          description: snapshot.data.toString(),
        );
      }

      return builder(snapshot.data as T);
    }

    return ErrorView(
      key: key,
      errorType: ErrorTypes.noData,
      title: 'Nothing to show',
      description: "There isn't anything here yet.",
    );
  }
}
