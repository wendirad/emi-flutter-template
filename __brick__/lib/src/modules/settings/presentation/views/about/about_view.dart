import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/extensions/build_context_extensions.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        title: Text(
          AppRoute.current.title ?? 'About',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 32,
            children: [
              // App Logo/Icon
              _AppIcon(),

              // App Name and Version
              _AppInfo(),

              // App Description
              _AppDescription(),

              // Version Info
              _VersionInfo(),

              // Social Media Links
              _SocialMedia(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [context.cs.primary, context.cs.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: context.cs.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset(Illustrations.splashScreenMain),
    );
  }
}

class _AppInfo extends StatelessWidget {
  const _AppInfo();

  @override
  Widget build(BuildContext context) {
    return Text(
      '{{project_name.titleCase()}}',
      style: context.tt.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.cs.onSurface,
      ),
    );
  }
}

class _AppDescription extends StatelessWidget {
  const _AppDescription();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI-powered virtual receptionist that answers calls, gathers key info, texts concise summaries, and cleverly stalls spam callers.',
              style: context.tt.bodyMedium?.copyWith(
                color: context.cs.onSurface.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VersionInfo extends StatelessWidget {
  const _VersionInfo();

  @override
  Widget build(BuildContext context) {
    final int year = DateTime.now().year;
    return Column(
      children: [
        Text(
          'Version 0.1.0',
          style: context.tt.bodySmall?.copyWith(
            color: context.cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.copyright_outlined), Text('$year')],
        ),
      ],
    );
  }
}

class _SocialMedia extends StatelessWidget {
  const _SocialMedia();

  Future<bool> canLaunchUrl(Uri url) async {
    return UrlLauncherPlatform.instance.canLaunch(url.toString());
  }

  Future<void> _launchUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $url'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Follow Us',
          style: context.tt.titleSmall?.copyWith(
            color: context.cs.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 0.7,
              child: FlutterSocialButton(
                onTap: () =>
                    _launchUrl('https://example.com/', context),
                mini: true,
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: FlutterSocialButton(
                onTap: () =>
                    _launchUrl('https://example.com/', context),
                mini: true,
                buttonType: ButtonType.google,
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: FlutterSocialButton(
                onTap: () =>
                    _launchUrl('https://example.com/', context),
                mini: true,
                buttonType: ButtonType.facebook,
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: FlutterSocialButton(
                onTap: () => _launchUrl('https://example.com/', context),
                mini: true,
                buttonType: ButtonType.twitter,
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: FlutterSocialButton(
                onTap: () => _launchUrl(
                  'https://example.com/',
                  context,
                ),
                mini: true,
                buttonType: ButtonType.linkedin,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
