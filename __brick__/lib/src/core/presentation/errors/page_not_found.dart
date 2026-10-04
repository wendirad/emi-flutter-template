import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../constants/app_route.dart';
import 'error_info.dart';

class PageNotFound extends ErrorInfo {
  PageNotFound({
    super.key,
    String? title,
    String? description,
    String? buttonText,
    super.button,
    AsyncCallback? onPress,
  }) : super(
         title: title ?? "Lost in Space!",
         description:
             description ??
             "The page you are looking for seems to be missing. Please go back or visit the homepage.",
         buttonText: buttonText ?? "Back",
         onPress:
             onPress ??
             () async {
               final canPop = await Modular.to.maybePop();
               if (!canPop) {
                 await Modular.to.pushReplacementNamed(
                   AppRoute.home.str,
                 );
               }
             },
       );
}
