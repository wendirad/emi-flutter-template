import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'error_info.dart';

class NoConnection extends ErrorInfo {
  NoConnection({
    super.key,
    super.button,
    String? title,
    String? description,
    String? buttonText,
    AsyncCallback? onPress,
  }) : super(
         title: title ?? "No Connection",
         description:
             description ??
             "We're sorry, but you are not connected to the internet. Please check your connection and try again.",
         buttonText: buttonText ?? "Try again",
         onPress: onPress ?? () async => Modular.to.navigate(Modular.to.path),
       );
}
