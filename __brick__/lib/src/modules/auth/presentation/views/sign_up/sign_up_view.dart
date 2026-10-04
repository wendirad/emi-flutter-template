import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../core/presentation/widgets/widgets.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../blocs/sign_up/sign_up_bloc.dart';
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
          SignUpBloc(signUp: Modular.get<SignUpWithEmailAndPasswordUseCase>()),
      child: BlocListener<SignUpBloc, SignUpState>(
        listenWhen: (p, c) => p != c,
        listener: (context, state) async {
          if (state.isSuccess) {
            AppSnackBar.success(context, 'Sign up successful');
            Modular.to.navigate(AppRoute.home.str);
          }
        },
        child: AuthScaffold(
          title: 'Register',
          subtitle: 'Create your new account',
          form: _SignUpForm(formKey: _signUpFormKey),
          footer: AuthFooter(
            prompt: 'Already have an account?',
            actionText: 'Sign In',
            onAction: () => Modular.to.pushNamed(AppRoute.signIn.str),
          ),
        ),
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
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _businessNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SignUpState state = WatchContext(context).watch<SignUpBloc>().state;

    return Column(
      spacing: 8,
      children: [
        if (state.failure case final failure?) ...[
          AppAlert(
            title: 'Sign Up Failed',
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
              AppTextField(
                controller: _businessNameController,
                hintText: 'Business Name',
                icon: Icon(Icons.business_center, color: context.cs.secondary),
              ),

              EmailField(controller: _emailController),

              PasswordField(
                controller: _passwordController,
              ),

              PasswordField(
                controller: _confirmPasswordController,
                confirms: _passwordController,
                hintText: 'Confirm Password',
              ),

              const SizedBox(height: 16),

              AppButton(
                onPress: () {
                  if (widget.formKey.currentState!.validate()) {
                    ReadContext(context).read<SignUpBloc>().add(
                      SignUpRequested(email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          businessName: _businessNameController.text.trim(),
                      ),
                    );
                  }
                },
                isLoading: state.isInProgress,
                title: 'Sign Up',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
