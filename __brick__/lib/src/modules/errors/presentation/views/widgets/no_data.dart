import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../views.dart';

class NoData extends ErrorInfo {
  NoData({
    super.key,
    String? title,
    String? description,
    String? buttonText,
    super.button,
    AsyncCallback? onPress,
  }) : super(
         title: title ?? "No Data Found!",
         description:
             description ??
             "No items were found. Try refreshing, or go back to the home screen.",
         buttonText: buttonText ?? "Retry",
         onPress:
             onPress ??
             () async {
               final String path = Modular.to.path;
               if (Modular.to.canPop()) {
                 await Modular.to.popAndPushNamed(path);
               } else {
                 await Modular.to.pushNamed(path);
               }
             },
       );
}
