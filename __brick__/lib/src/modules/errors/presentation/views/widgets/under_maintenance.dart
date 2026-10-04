import 'package:flutter/foundation.dart';
import '../views.dart';

class UnderMaintenance extends ErrorInfo {
  UnderMaintenance({
    super.key,
    String? title,
    String? description,
    super.button,
    String? buttonText,
    AsyncCallback? onPress,
  }) : super(
         title: title ?? "Under Maintenance",
         description:
             description ??
             "We're sorry, but the service is currently under maintenance. Please try again later.",
         buttonText: buttonText ?? "Try again",
         onPress: onPress ?? () async {},
       );
}
