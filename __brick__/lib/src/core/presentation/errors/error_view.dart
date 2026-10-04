import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../constants/constants.dart';
import '../../extensions/build_context_extensions.dart';
import '../widgets/illustration.dart';
import 'error_info.dart';

class ErrorView extends StatelessWidget {
  final ErrorTypes errorType;
  final String? title;
  final String? description;
  final Widget? button;
  final String? buttonText;
  final AsyncCallback? onButtonPress;

  const ErrorView({
    super.key,
    this.errorType = ErrorTypes.unknownError,
    this.title,
    this.description,
    this.buttonText,
    this.onButtonPress,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    final _ErrorContent content = _ErrorContent.of(errorType);

    return Container(
      color: context.cs.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Illustration(
                    content.illustration,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              ErrorInfo(
                title: title ?? content.title,
                description: description ?? content.description,
                button: button,
                buttonText: buttonText ?? content.buttonText,
                onPress: onButtonPress ?? content.onPress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Default illustration, copy and retry action for each [ErrorTypes] value.
class _ErrorContent {
  final String illustration;
  final String title;
  final String description;
  final String buttonText;
  final AsyncCallback onPress;

  const _ErrorContent({
    required this.illustration,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPress,
  });

  static _ErrorContent of(ErrorTypes type) => switch (type) {
    ErrorTypes.pageNotFound => _ErrorContent(
      illustration: Illustrations.pageNotFound,
      title: 'Lost in Space!',
      description:
          'The page you are looking for seems to be missing. Please go back or visit the homepage.',
      buttonText: 'Back',
      onPress: () async {
        final canPop = await Modular.to.maybePop();
        if (!canPop) {
          await Modular.to.pushReplacementNamed(AppRoute.home.str);
        }
      },
    ),
    ErrorTypes.noConnection => _ErrorContent(
      illustration: Illustrations.noConnection,
      title: 'No Connection',
      description:
          "We're sorry, but you are not connected to the internet. Please check your connection and try again.",
      buttonText: 'Try again',
      onPress: () async => Modular.to.navigate(Modular.to.path),
    ),
    ErrorTypes.underMaintenance => _ErrorContent(
      illustration: Illustrations.underMaintenance,
      title: 'Under Maintenance',
      description:
          "We're sorry, but the service is currently under maintenance. Please try again later.",
      buttonText: 'Try again',
      onPress: () async {},
    ),
    ErrorTypes.noData => _ErrorContent(
      illustration: Illustrations.noData,
      title: 'No Data Found!',
      description:
          'No items were found. Try refreshing, or go back to the home screen.',
      buttonText: 'Retry',
      onPress: () async {
        final String path = Modular.to.path;
        if (Modular.to.canPop()) {
          await Modular.to.popAndPushNamed(path);
        } else {
          await Modular.to.pushNamed(path);
        }
      },
    ),
    ErrorTypes.unknownError => _ErrorContent(
      illustration: Illustrations.unknownError,
      title: 'Something went wrong',
      description:
          "We're sorry, but something unexpected happened. Please try again later.",
      buttonText: 'Try again',
      onPress: () async => await Modular.to.pushNamed(Modular.to.path),
    ),
  };
}
