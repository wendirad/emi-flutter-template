import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/app.dart';
import '../../../../../core/presentation/widgets/app_alert.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../blocs/confirm_password_reset/confirm_password_reset_bloc.dart';
import '../widgets/components/header.dart';
import '../widgets/widgets.dart';

class ConfirmPasswordResetView extends StatefulWidget {
  const ConfirmPasswordResetView({super.key});

  @override
  State<ConfirmPasswordResetView> createState() =>
      _ConfirmPasswordResetViewState();
}

class _ConfirmPasswordResetViewState extends State<ConfirmPasswordResetView> {
  final _confirmPasswordResetViewFormKey = GlobalKey<FormState>();

  late final String? verificationCode;

  @override
  void initState() {
    super.initState();
    _checkVerificationCode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ConfirmPasswordResetBloc(Modular.get<ConfirmPasswordResetUseCase>()),
      child: BlocConsumer<ConfirmPasswordResetBloc, ConfirmPasswordResetState>(
        listenWhen: (p, c) => p.process != c.process || p.error != c.error,
        listener: (context, state) {
          if (state.process == ConfirmPasswordResetProcess.successful) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Password Reset Successfully!'),
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
                            title: 'Confirm Password',
                            subtitle: 'Set your new password',
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          _ConfirmPasswordResetViewForm(
                            formKey: _confirmPasswordResetViewFormKey,
                            code: verificationCode,
                          ),
                          const _ConfirmPasswordResetViewFooter(),
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

  void _checkVerificationCode() {
    verificationCode = Modular.args.data is VerifyPasswordResetCodeParam
        ? Modular.args.data?.code
        : Modular.args.data?['code'];

    if (verificationCode == null) {
      Modular.to.navigate(
        AppRoute.resetPassword.str,
        arguments: PasswordResetConfirmFailure.fromCode('invalid-action-code'),
      );
    }
  }
}

class _ConfirmPasswordResetViewForm extends StatefulWidget {
  final String? code;
  final GlobalKey<FormState> formKey;

  const _ConfirmPasswordResetViewForm({
    required this.formKey,
    required this.code,
  });

  @override
  State<_ConfirmPasswordResetViewForm> createState() =>
      _ConfirmPasswordResetViewFormState();
}

class _ConfirmPasswordResetViewFormState
    extends State<_ConfirmPasswordResetViewForm> {
  final GlobalKey<PasswordFieldState> _newPasswordKey =
      GlobalKey<PasswordFieldState>();
  final GlobalKey<PasswordFieldState> _confirmNewPasswordKey =
      GlobalKey<PasswordFieldState>();

  @override
  Widget build(BuildContext context) {
    final ConfirmPasswordResetState state = WatchContext(
      context,
    ).watch<ConfirmPasswordResetBloc>().state;

    return Column(
      spacing: 8,
      children: [
        if (state.process == ConfirmPasswordResetProcess.failed &&
            state.error != null) ...[
          AppAlert(
            title: 'Password Reset Failed',
            value: state.error!.message,
            variant: AlertVariant.danger,
            icon: Icons.report_gmailerrorred_outlined,
          ),
        ],

        Form(
          key: widget.formKey,
          child: Column(
            spacing: 16,
            children: [
              PasswordField(
                key: _newPasswordKey,
                showPassword: state.showPassword,
                onShowPasswordToggle: () => ReadContext(context)
                    .read<ConfirmPasswordResetBloc>()
                    .add(ConfirmPasswordResetToggleShowPassword()),
              ),

              PasswordField(
                key: _confirmNewPasswordKey,
                passwordKey: _newPasswordKey,
                showPassword: state.showConfirmPassword,
                hintText: 'Confirm Password',
                isConfirmPassword: true,
                onShowPasswordToggle: () => ReadContext(context)
                    .read<ConfirmPasswordResetBloc>()
                    .add(ConfirmPasswordResetToggleShowConfirmPassword()),
              ),

              const SizedBox(height: 16),

              AppButton(
                onPress: () {
                  if (state.process == ConfirmPasswordResetProcess.inProgress) {
                    return;
                  }

                  if (widget.formKey.currentState!.validate()) {
                    ReadContext(context).read<ConfirmPasswordResetBloc>().add(
                      ConfirmPasswordResetRequested(
                        ConfirmPasswordResetParam(
                          code: widget.code ?? '',
                          newPassword:
                              _newPasswordKey.currentState!.widget.password,
                        ),
                      ),
                    );
                  }
                },
                child: state.process == ConfirmPasswordResetProcess.inProgress
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text('Reset Password'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConfirmPasswordResetViewFooter extends StatelessWidget {
  const _ConfirmPasswordResetViewFooter();

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
