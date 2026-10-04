import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../views.dart';

class UnknownError extends ErrorInfo {
  UnknownError({
    super.key,
    String? title,
    String? description,
    super.button,
    String? buttonText,
    AsyncCallback? onPress,
  }) : super(
         title: title ?? "Something went wrong",
         description:
             description ??
             "We're sorry, but something unexpected happened. Please try again later.",
         buttonText: "Try again",
         onPress:
             onPress ?? () async => await Modular.to.pushNamed(Modular.to.path),
       );
}
