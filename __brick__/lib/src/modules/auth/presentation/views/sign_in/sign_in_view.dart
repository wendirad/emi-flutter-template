import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../core/presentation/widgets/widgets.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../blocs/sign_in/sign_in_bloc.dart';
import '../widgets/components/header.dart';
import '../widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SignInBloc(Modular.get<SignInWithEmailAndPasswordUseCase>()),
      child: BlocConsumer<SignInBloc, SignInState>(
        listenWhen: (p, c) => p.process != c.process || p.error != c.error,
        listener: (context, state) async {
          if (state.process == SignInProcess.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Sign In successful'),
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
                            title: 'Welcome Back',
                            subtitle: 'Sign In into your account',
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          _SignInForm(formKey: _signInFormKey),

                          const _SignInFooter(),
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

class _SignInForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const _SignInForm({required this.formKey});

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final signInInfoSave = prefs.getBool('signInInfoSave') ?? false;

      if (signInInfoSave) {
        final savedEmail = prefs.getString('email') ?? '';

        if (!mounted) return;

        if (savedEmail.isNotEmpty) _emailController.text = savedEmail;

        ReadContext(context).read<SignInBloc>().add(const SignInToggleSaveInfo());
      }
    } catch (e) {
      debugPrint('Error loading saved email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final SignInState state = WatchContext(context).watch<SignInBloc>().state;

    return Column(
      spacing: 8,
      children: [
        if (state.process == SignInProcess.failed && state.error != null) ...[
          AppAlert(
            title: 'Sign In Failed',
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
              EmailField(controller: _emailController),

              PasswordField(
                controller: _passwordController,
                enforceStrength: false,
                showPassword: state.showPassword,
                onShowPasswordToggle: () => ReadContext(
                  context,
                ).read<SignInBloc>().add(SignInToggleShowPassword()),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CheckboxField(
                    isChecked: state.saveInfo,
                    onToggle: () => ReadContext(
                      context,
                    ).read<SignInBloc>().add(SignInToggleSaveInfo()),
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
                  if (state.process == SignInProcess.inProgress) return;

                  if (widget.formKey.currentState!.validate()) {
                    ReadContext(context).read<SignInBloc>().add(
                      SignInRequested(
                        SignInParam(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          saveInfo: state.saveInfo,
                        ),
                      ),
                    );
                  }
                },
                child: state.process == SignInProcess.inProgress
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text('Sign In'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SignInFooter extends StatelessWidget {
  const _SignInFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have account?"),
            AppTextButton(
              text: 'Sign Up',
              onPress: () async =>
                  await Modular.to.pushNamed(AppRoute.signUp.str),
            ),
          ],
        ),
      ],
    );
  }
}
