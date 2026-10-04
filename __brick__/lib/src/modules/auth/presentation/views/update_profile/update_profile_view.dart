import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../core/presentation/widgets/widgets.dart';
import '../../../domain/entities/auth_entities.dart';
import '../../../domain/use_cases/update_profile_use_case.dart';
import '../../../domain/validators/text_validator.dart';
import '../../blocs/update_profile/update_profile_bloc.dart';
import '../../../../../core/presentation/errors/errors.dart';
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

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrefilledData();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
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
              UpdateProfileBloc(updateProfile: Modular.get<UpdateProfileUseCase>()),
          child: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
            listenWhen: (p, c) => p != c,
            listener: (context, state) async {
              if (state.isSuccess) {
                AppSnackBar.success(context, 'Profile Update Successful!');
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
                      if (state.failure case final failure?) ...[
                        AppAlert(
                          title: 'Profile Update Failure',
                          value: failure.message,
                          variant: AlertVariant.danger,
                          icon: Icons.report_gmailerrorred_outlined,
                        ),
                      ],
                      if (user is BusinessUser) ...[
                        ProfileFormField(
                          controller: _businessNameController,
                          labelText: 'Business Name',
                          icon: Icons.business_center,
                        ),
                      ],
                      ProfileFormField(
                        controller: _firstNameController,
                        labelText: 'First Name',
                        icon: Icons.text_fields,
                      ),

                      ProfileFormField(
                        controller: _lastNameController,
                        labelText: 'Last Name',
                        icon: Icons.text_fields,
                      ),

                      AppButton(
                        onPress: () {
                          if (!widget.formKey.currentState!.validate()) return;

                          ReadContext(context).read<UpdateProfileBloc>().add(
                            UpdateProfileRequested(businessName: user is BusinessUser
                                    ? _businessNameController.text.trim()
                                    : null,
                                firstName: _firstNameController.text.trim(),
                                lastName: _lastNameController.text.trim(),
                                profilePicture: _profilePicture,
                                removeProfilePicture: _removeProfilePicture),
                          );
                        },
                        isLoading: state.isInProgress,
                title: 'Update Profile',
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
    final user = Modular.args.data;
    if (user is! AuthUser) return;

    if (user is BusinessUser) {
      _businessNameController.text = user.businessName;
    }
    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
  }
}

class ProfileFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;

  const ProfileFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: TextValidator().call,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        suffixIcon: Icon(icon, color: context.cs.primary),
        floatingLabelStyle: context.tt.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: context.cs.tertiary,
        ),
        contentPadding: EdgeInsets.all(18).copyWith(top: 24, bottom: 24),
      ),
    );
  }
}
