import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../core/presentation/widgets/widgets.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../auth/auth.dart';
import '../../../../../core/presentation/errors/errors.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CurrentUserBloc(getCurrentUser: Modular.get<GetCurrentUserUseCase>())
            ..add(const CurrentUserRequested()),
      child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
        builder: (context, state) {
          if (state.data case final user?) {
            return _SettingsContent(user: user);
          }

          if (state.failure case final failure?) {
            return ErrorView(
              title: 'Oops!',
              description: failure.message,
              onButtonPress: () async => ReadContext(
                context,
              ).read<CurrentUserBloc>().add(const CurrentUserRequested()),
            );
          }

          return AsyncPageLoader.loading();
        },
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  final AuthUser user;

  const _SettingsContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        title: Text(
          AppRoute.current.title ?? 'Settings',
          style: context.tt.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile
              _ProfileSettings(user: user),
              const SizedBox(height: 24),

              // General Settings
              _GeneralSettings(),
              const SizedBox(height: 24),

              // Account
              _AccountSettings(),
              const SizedBox(height: 24),

              // Sign Out
              BlocProvider(
                create: (context) => SignOutBloc(signOut: Modular.get<SignOutUseCase>()),
                child: const SignOutCard(),
              ),
              const SizedBox(height: 32),

              // App Version
              _AppVersion(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSettings extends StatelessWidget {
  final AuthUser user;

  const _ProfileSettings({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              top: -15,
              right: -10,
              child: IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async => await Modular.to.pushNamed(
                  AppRoute.updateProfile.str,
                  arguments: user,
                ),
                tooltip: 'Edit Profile',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              ),
            ),
            Row(
              children: [
                UserAvatar(initials: user.initials, photoUrl: user.photoUrl),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        style: context.tt.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email ?? 'No email',
                        style: context.tt.bodyMedium?.copyWith(
                          color: context.cs.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneralSettings extends StatelessWidget {
  const _GeneralSettings();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            'General',
            style: context.tt.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.palette_outlined,
                title: 'Theme',
                subtitle: 'Switch between light and dark mode',
                trailing: _ThemeToggle(),
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                trailing: Switch(
                  value: true, // TODO: Get from settings state
                  onChanged: (value) {
                    // TODO: Update notification settings
                  },
                ),
                onTap: () {
                  // TODO: Navigate to notification settings
                },
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: 'English (US)',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to language settings
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final themeService = Modular.get<ThemeService>();

    return Switch(value: isDark, onChanged: (_) => themeService.toggleTheme());
  }
}

class _AccountSettings extends StatelessWidget {
  const _AccountSettings();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            'Account',
            style: context.tt.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your account password',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to change password
                },
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Open privacy policy
                },
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                subtitle: 'Read our terms of service',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Open terms of service
                },
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'App version and information',
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await Modular.to.pushNamed(AppRoute.about.str);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AppVersion extends StatelessWidget {
  const _AppVersion();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'Version 0.1.0',
          style: context.tt.bodySmall?.copyWith(
            color: context.cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = context.cs.primary;
    final titleColor = context.cs.onSurface;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.cs.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: context.tt.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: context.tt.bodySmall?.copyWith(
                color: context.cs.onSurface.withValues(alpha: 0.6),
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
