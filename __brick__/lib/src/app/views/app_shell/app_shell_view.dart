import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/constants/constants.dart';
import '../../../core/extensions/build_context_extensions.dart';
import '../../../modules/auth/auth.dart';
import 'widgets/app_navigation_bar.dart';
import '../../../core/presentation/widgets/widgets.dart';

class AppShellView extends StatefulWidget {
  const AppShellView({super.key});

  @override
  State<AppShellView> createState() => _AppShellViewState();
}

class _AppShellViewState extends State<AppShellView> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: Modular.get<IAuthRepository>(),
      child: BlocProvider(
        create: (ctx) => AuthSessionBloc(
          authRepository: ReadContext(ctx).read<IAuthRepository>(),
        )..add(AuthSessionUserSubscriptionRequested()),
        child: BlocListener<AuthSessionBloc, AuthSessionState>(
          listenWhen: (p, c) => p.status != c.status || p.error != c.error,
          listener: (context, state) => _handleAuthState(context, state),
          child: _RouterOutlet(),
        ),
      ),
    );
  }

  void _handleAuthState(BuildContext context, AuthSessionState state) async {
    if (!state.isAuthenticated) {
      if (state.error != null) {
        AppSnackBar.error(context, state.error!.message);
      }

      Modular.to.navigate(AppRoute.signIn.str);
    }
  }
}

class _RouterOutlet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: context.cs.surfaceDim,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: RouterOutlet(),
      ),
      bottomNavigationBar: AppNavigationBar(),
    );
  }
}
