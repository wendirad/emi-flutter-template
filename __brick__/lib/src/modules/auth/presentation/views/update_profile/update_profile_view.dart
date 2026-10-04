import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../core/app.dart';
import '../../../../../core/presentation/widgets/app_alert.dart';
import '../../../domain/entities/auth_entities.dart';
import '../../../domain/use_cases/update_profile_use_case.dart';
import '../../../domain/validators/text_validator.dart';
import '../../blocs/update_profile/update_profile_bloc.dart';
import '../../../../errors/presentation/views/error_view.dart';
import 'widgets/photo_update_widget.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final GlobalKey<FormState> _profileUpdateFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
        title: Text(
          AppRoute.current.title ?? 'Update Profile',
          style: context.tt.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: _ProfileUpdateForm(formKey: _profileUpdateFormKey),
        ),
      ),
    );
  }
}

class _ProfileUpdateForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const _ProfileUpdateForm({required this.formKey});

  @override
  State<_ProfileUpdateForm> createState() => _ProfileUpdateFormState();
}

class _ProfileUpdateFormState extends State<_ProfileUpdateForm> {
  File? _profilePicture;
  bool _removeProfilePicture = false;

  final GlobalKey<_ProfileFormFieldState> _businessNameKey =
      GlobalKey<_ProfileFormFieldState>();
  final GlobalKey<_ProfileFormFieldState> _firstNameKey =
      GlobalKey<_ProfileFormFieldState>();
  final GlobalKey<_ProfileFormFieldState> _lastNameKey =
      GlobalKey<_ProfileFormFieldState>();

  @override
  void initState() {
    super.initState();
    _loadPrefilledData();
  }

  @override
  Widget build(BuildContext context) {
    final user = Modular.args.data;

    if (user == null || user is! AuthUser) {
      return ErrorView(
        errorType: ErrorTypes.noData,
        title: 'User Data Not Found',
        description:
            'Unable to load user data. Please try again later or contact support.',
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PhotoUpdateWidget(
          initials: user.initials,
          photoUrl: user.photoUrl,
          onPhotoSelected: (selectedPhoto) => setState(() {
            _profilePicture = selectedPhoto;
            _removeProfilePicture = false;
          }),
          onPhotoRemoved: () => setState(() {
            _profilePicture = null;
            _removeProfilePicture = true;
          }),
        ),

        if (user is BusinessUser) ...[
          Text(
            user.businessName,
            style: context.tt.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.cs.inversePrimary.withAlpha(200),
            ),
          ),
        ],

        SizedBox(height: 16),

        Text(
          user.email!,
          style: context.tt.titleLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: context.cs.inversePrimary.withAlpha(150),
          ),
        ),
        BlocProvider(
          create: (context) =>
              UpdateProfileBloc(Modular.get<UpdateProfileUseCase>()),
          child: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
            listenWhen: (p, c) => p.process != c.process || p.error != c.error,
            listener: (context, state) async {
              if (state.process == ProfileUpdateStatus.successful) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Profile Update Successful!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
                await Modular.to.popAndPushNamed(AppRoute.settings.str);
              }
            },
            builder: (context, state) {
              return Form(
                key: widget.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0).copyWith(top: 64),
                  child: Column(
                    spacing: 32,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (state.process == ProfileUpdateStatus.failed &&
                          state.error != null) ...[
                        AppAlert(
                          title: 'Profile Update Failure',
                          value: state.error!.message,
                          variant: AlertVariant.danger,
                          icon: Icons.report_gmailerrorred_outlined,
                        ),
                      ],
                      if (user is BusinessUser) ...[
                        ProfileFormField(
                          key: _businessNameKey,
                          labelText: 'Business Name',
                          icon: Icons.business_center,
                        ),
                      ],
                      ProfileFormField(
                        key: _firstNameKey,
                        labelText: 'First Name',
                        icon: Icons.text_fields,
                      ),

                      ProfileFormField(
                        key: _lastNameKey,
                        labelText: 'Last Name',
                        icon: Icons.text_fields,
                      ),

                      AppButton(
                        onPress: () {
                          if (state.process == ProfileUpdateStatus.inProgress) {
                            return;
                          }

                          if (!widget.formKey.currentState!.validate()) return;

                          ReadContext(context).read<UpdateProfileBloc>().add(
                            ProfileUpdateRequested(
                              UpdateProfileParam(
                                businessName:
                                    _businessNameKey.currentState?.widget.text,
                                firstName:
                                    _firstNameKey.currentState?.widget.text,
                                lastName:
                                    _lastNameKey.currentState?.widget.text,
                                profilePicture: _profilePicture,
                                removeProfilePicture: _removeProfilePicture,
                              ),
                            ),
                          );
                        },
                        child: state.process == ProfileUpdateStatus.inProgress
                            ? LoadingAnimationWidget.halfTriangleDot(
                                color: Colors.white,
                                size: 30,
                              )
                            : Text('Update Profile'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _loadPrefilledData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Modular.args.data;

      if (mounted) {
        if ((user is BusinessUser) && _businessNameKey.currentState != null) {
          _businessNameKey.currentState?.widget.controller.text =
              user.businessName;
        }

        if (user.firstName != null && _firstNameKey.currentState != null) {
          _firstNameKey.currentState?.widget.controller.text = user.firstName!;
        }

        if (user.lastName != null && _lastNameKey.currentState != null) {
          _lastNameKey.currentState?.widget.controller.text = user.lastName!;
        }
      }
    });
  }
}

class ProfileFormField extends StatefulWidget {
  final String labelText;
  final IconData icon;

  const ProfileFormField({
    super.key,
    required this.labelText,
    required this.icon,
  });

  @override
  State<ProfileFormField> createState() => _ProfileFormFieldState();

  TextValidator get validator {
    final state = _getState();
    return state._validator;
  }

  TextEditingController get controller {
    final state = _getState();
    return state._controller;
  }

  String get text {
    final state = _getState();
    return state._controller.text.trim();
  }

  _ProfileFormFieldState _getState() {
    if (key is! GlobalKey<_ProfileFormFieldState>) {
      throw StateError(
        'ProfileFormField getters require a GlobalKey<_ProfileFormFieldState> as the widget key. '
        'Example: ProfileFormField(key: GlobalKey<_ProfileFormFieldState>())',
      );
    }
    final state = (key as GlobalKey<_ProfileFormFieldState>).currentState;
    if (state == null) {
      throw StateError(
        'EmailField state is not available. Make sure the widget is mounted.',
      );
    }
    return state;
  }
}

class _ProfileFormFieldState extends State<ProfileFormField> {
  late final TextValidator _validator;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _validator = TextValidator();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: TextValidator().call,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: widget.labelText,
        suffixIcon: Icon(widget.icon, color: context.cs.primary),
        floatingLabelStyle: context.tt.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: context.cs.tertiary,
        ),
        contentPadding: EdgeInsets.all(18).copyWith(top: 24, bottom: 24),
      ),
    );
  }
}
