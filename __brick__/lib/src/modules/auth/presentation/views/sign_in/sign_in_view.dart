import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/presentation/widgets/widgets.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../blocs/remembered_email/remembered_email_bloc.dart';
import '../../blocs/sign_in/sign_in_bloc.dart';
import '../widgets/widgets.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SignInBloc(
            signIn: Modular.get<SignInWithEmailAndPasswordUseCase>(),
          ),
        ),
        BlocProvider(
          create: (_) => RememberedEmailBloc(
            getRememberedEmail: Modular.get<GetRememberedEmailUseCase>(),
          )..add(const RememberedEmailRequested()),
        ),
      ],
      child: BlocListener<SignInBloc, SignInState>(
        listenWhen: (p, c) => p != c,
        listener: (context, state) async {
          if (state.isSuccess) {
            AppSnackBar.success(context, 'Sign In successful');

            Modular.to.navigate(AppRoute.home.str);
          }
        },
        child: AuthScaffold(
          title: 'Welcome Back',
          subtitle: 'Sign In into your account',
          form: _SignInForm(formKey: _signInFormKey),
          footer: AuthFooter(
            prompt: "Don't have account?",
            actionText: 'Sign Up',
            onAction: () => Modular.to.pushNamed(AppRoute.signUp.str),
          ),
        ),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const _SignInForm({required this.formKey});

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _saveInfo = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _applyRememberedEmail(String? email) {
    if (email == null || email.isEmpty) return;

    _emailController.text = email;
    setState(() => _saveInfo = true);
  }

  @override
  Widget build(BuildContext context) {
    final SignInState state = WatchContext(context).watch<SignInBloc>().state;

    return BlocListener<RememberedEmailBloc, RememberedEmailState>(
      listenWhen: (p, c) => p != c,
      listener: (context, remembered) => _applyRememberedEmail(remembered.data),
      child: Column(
        spacing: 8,
        children: [
          if (state.failure case final failure?) ...[
            AppAlert(
              title: 'Sign In Failed',
              value: failure.message,
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

                PasswordField(
                  controller: _passwordController,
                  enforceStrength: false,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CheckboxField(
                      isChecked: _saveInfo,
                      onToggle: () => setState(() => _saveInfo = !_saveInfo),
                      suffix: Text('Remember my email'),
                    ),
                    AppTextButton(
                      text: 'Forgot Password?',
                      onPress: () async {
                        await Modular.to.pushNamed(AppRoute.resetPassword.str);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                AppButton(
                  onPress: () {
                    if (widget.formKey.currentState!.validate()) {
                      ReadContext(context).read<SignInBloc>().add(
                        SignInRequested(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          saveInfo: _saveInfo,
                        ),
                      );
                    }
                  },
                  isLoading: state.isInProgress,
                  title: 'Sign In',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
