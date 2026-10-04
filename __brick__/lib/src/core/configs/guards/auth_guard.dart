import 'package:flutter_modular/flutter_modular.dart';
import '../../app.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: AppRoute.signIn.str);

  @override
  Future<bool> canActivate(String path, ModularRoute router) async {
    return await Modular.get<IAuthRepository>().isAuthenticated;
  }
}
