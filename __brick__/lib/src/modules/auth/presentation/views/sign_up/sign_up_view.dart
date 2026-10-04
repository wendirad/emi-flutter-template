import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../core/presentation/widgets/widgets.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../blocs/sign_up/sign_up_bloc.dart';
import '../widgets/components/header.dart';
import '../widgets/widgets.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SignUpBloc(Modular.get<SignUpWithEmailAndPasswordUseCase>()),
      child: BlocConsumer<SignUpBloc, SignUpState>(
        listenWhen: (p, c) => p.process != c.process || p.error != c.error,
        listener: (context, state) async {
          if (state.process == SignUpProcess.successful) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Sign up successful'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
            Modular.to.navigate(AppRoute.home.str);
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
                            title: 'Register',
                            subtitle: 'Create your new account',
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          _SignUpForm(formKey: _signUpFormKey),

                          const _SignUpFooter(),
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

class _SignUpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const _SignUpForm({required this.formKey});

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final GlobalKey<AppTextFieldState> _businessNameKey =
      GlobalKey<AppTextFieldState>();
  final GlobalKey<EmailFieldState> _emailKey = GlobalKey<EmailFieldState>();
  final GlobalKey<PasswordFieldState> _passwordKey =
      GlobalKey<PasswordFieldState>();
  final GlobalKey<PasswordFieldState> _confirmPasswordKey =
      GlobalKey<PasswordFieldState>();

  @override
  Widget build(BuildContext context) {
    final SignUpState state = WatchContext(context).watch<SignUpBloc>().state;

    return Column(
      spacing: 8,
      children: [
        if (state.process == SignUpProcess.failed && state.error != null) ...[
          AppAlert(
            title: 'Sign Up Failed',
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
              AppTextField(
                key: _businessNameKey,
                hintText: 'Business Name',
                icon: Icon(Icons.business_center, color: context.cs.secondary),
              ),

              EmailField(key: _emailKey),

              PasswordField(
                key: _passwordKey,
                showPassword: state.showPassword,
                onShowPasswordToggle: () => ReadContext(
                  context,
                ).read<SignUpBloc>().add(SignUpToggleShowPassword()),
              ),

              PasswordField(
                key: _confirmPasswordKey,
                passwordKey: _passwordKey,
                showPassword: state.showConfirmPassword,
                hintText: 'Confirm Password',
                isConfirmPassword: true,
                onShowPasswordToggle: () => ReadContext(
                  context,
                ).read<SignUpBloc>().add(SignUpToggleShowConfirmPassword()),
              ),

              const SizedBox(height: 16),

              AppButton(
                onPress: () {
                  if (state.process == SignUpProcess.inProgress) return;

                  if (widget.formKey.currentState!.validate()) {
                    ReadContext(context).read<SignUpBloc>().add(
                      SignUpRequested(
                        SignUpParam(
                          email: _emailKey.currentState!.widget.email,
                          password: _passwordKey.currentState!.widget.password,
                          businessName:
                              _businessNameKey.currentState!.widget.text,
                        ),
                      ),
                    );
                  }
                },
                child: state.process == SignUpProcess.inProgress
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text('Sign Up'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SignUpFooter extends StatelessWidget {
  const _SignUpFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already have an account?'),
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
