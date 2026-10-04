import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/app.dart';
import '../../../../../core/presentation/widgets/app_alert.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../blocs/password_reset/password_reset_bloc.dart';
import '../widgets/components/header.dart';
import '../widgets/widgets.dart';

class PasswordResetView extends StatefulWidget {
  const PasswordResetView({super.key});

  @override
  State<PasswordResetView> createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<PasswordResetView> {
  final _passwordResetViewFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PasswordResetBloc(Modular.get<SendPasswordResetEmailUseCase>()),

      child: BlocConsumer<PasswordResetBloc, PasswordResetState>(
        listenWhen: (p, c) => p.process != c.process || p.error != c.error,
        listener: (context, state) async {
          if (state.process == PasswordResetProcess.successful) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Password Reset Email Sent Successfully!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
            Modular.to.navigate(AppRoute.signIn.str);
          }
        },

        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.cs.surfaceDim,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: Padding(
                  padding: const EdgeInsets.all(28.0).copyWith(top: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TopBar(),

                      const Column(
                        spacing: 16,
                        children: [
                          AuthBanner(),

                          Header(
                            title: 'Forgot Your Password?',
                            subtitle: 'Reset your password with email',
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          _PasswordResetViewForm(
                            formKey: _passwordResetViewFormKey,
                          ),

                          const _PasswordResetViewFooter(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PasswordResetViewForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const _PasswordResetViewForm({required this.formKey});

  @override
  State<_PasswordResetViewForm> createState() => _PasswordResetViewFormState();
}

class _PasswordResetViewFormState extends State<_PasswordResetViewForm> {
  final GlobalKey<EmailFieldState> _emailKey = GlobalKey<EmailFieldState>();

  @override
  Widget build(BuildContext context) {
    final PasswordResetState state = WatchContext(
      context,
    ).watch<PasswordResetBloc>().state;

    return Column(
      spacing: 8,
      children: [
        if (state.process == PasswordResetProcess.failed &&
            state.error != null) ...[
          AppAlert(
            title: 'Password Reset Failed',
            value: state.error!.message,
            variant: AlertVariant.danger,
            icon: Icons.report_gmailerrorred_outlined,
          ),
        ],

        if (state.process == PasswordResetProcess.idle &&
            Modular.args.data is PasswordResetConfirmFailure) ...[
          AppAlert(
            title: 'Password Reset Confirmation Failed',
            value: Modular.args.data?.message ?? 'Confirmation Error',
            variant: AlertVariant.danger,
            icon: Icons.report_gmailerrorred_outlined,
          ),
        ],

        Form(
          key: widget.formKey,
          child: Column(
            spacing: 16,
            children: [
              EmailField(key: _emailKey),

              const SizedBox(height: 16),

              AppButton(
                onPress: () {
                  if (state.process == PasswordResetProcess.inProgress) {
                    return;
                  }

                  if (widget.formKey.currentState!.validate()) {
                    ReadContext(context).read<PasswordResetBloc>().add(
                      PasswordResetRequested(
                        PasswordResetParam(
                          email: _emailKey.currentState!.widget.email,
                        ),
                      ),
                    );
                  }
                },
                child: state.process == PasswordResetProcess.inProgress
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text('Send Password Reset Email'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PasswordResetViewFooter extends StatelessWidget {
  const _PasswordResetViewFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Remember your password?"),
            AppTextButton(
              text: 'Sign In',
              onPress: () async =>
                  await Modular.to.pushNamed(AppRoute.signIn.str),
            ),
          ],
        ),
      ],
    );
  }
}
