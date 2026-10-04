import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../app.dart';
import '../../../../modules/auth/presentation/blocs/auth_session/auth_session_bloc.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
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
