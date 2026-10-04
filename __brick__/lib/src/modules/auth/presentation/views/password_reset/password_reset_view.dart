import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/presentation/widgets/widgets.dart';
import '../../../domain/failures/auth_failures.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../blocs/password_reset/password_reset_bloc.dart';
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

      child: BlocListener<PasswordResetBloc, PasswordResetState>(
        listenWhen: (p, c) => p.process != c.process || p.error != c.error,
        listener: (context, state) async {
          if (state.process == PasswordResetProcess.successful) {
            AppSnackBar.success(context, 'Password Reset Email Sent Successfully!');
            Modular.to.navigate(AppRoute.signIn.str);
          }
        },
        child: AuthScaffold(
          title: 'Forgot Your Password?',
          subtitle: 'Reset your password with email',
          form: _PasswordResetViewForm(formKey: _passwordResetViewFormKey),
          footer: AuthFooter(
            prompt: 'Remember your password?',
            actionText: 'Sign In',
            onAction: () => Modular.to.pushNamed(AppRoute.signIn.str),
          ),
        ),
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
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
              EmailField(controller: _emailController),

              const SizedBox(height: 16),

              AppButton(
                onPress: () {
                  if (widget.formKey.currentState!.validate()) {
                    ReadContext(context).read<PasswordResetBloc>().add(
                      PasswordResetRequested(
                        SendPasswordResetEmailParam(
                          email: _emailController.text.trim(),
                        ),
                      ),
                    );
                  }
                },
                isLoading: state.process == PasswordResetProcess.inProgress,
                title: 'Send Password Reset Email',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
