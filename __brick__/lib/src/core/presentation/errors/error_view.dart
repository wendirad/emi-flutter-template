import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../app.dart';
import 'no_connection.dart';
import 'no_data.dart';
import 'page_not_found.dart';
import 'under_maintenance.dart';
import 'unknown_error.dart';

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
                  child: Illustration(switch (errorType) {
                    ErrorTypes.pageNotFound => Illustrations.pageNotFound,
                    ErrorTypes.noConnection => Illustrations.noConnection,
                    ErrorTypes.underMaintenance =>
                      Illustrations.underMaintenance,
                    ErrorTypes.noData => Illustrations.noData,
                    _ => Illustrations.unknownError,
                  }, fit: BoxFit.scaleDown),
                ),
              ),

              const Spacer(flex: 2),

              (switch (errorType) {
                ErrorTypes.pageNotFound => PageNotFound.new,
                ErrorTypes.noConnection => NoConnection.new,
                ErrorTypes.underMaintenance => UnderMaintenance.new,
                ErrorTypes.noData => NoData.new,
                _ => UnknownError.new,
              })(
                title: title,
                description: description,
                button: button,
                buttonText: buttonText,
                onPress: onButtonPress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
