import '../utils/utils.dart';

/// External links, read from `.env`. A link that is not set is empty, and the
/// screens that show it hide the entry.
class AppLinks {
  const AppLinks._();

  static String get privacyPolicy => _link('privacyPolicyUrl');
  static String get termsOfService => _link('termsOfServiceUrl');
  static String get facebook => _link('facebookUrl');
  static String get twitter => _link('twitterUrl');
  static String get linkedin => _link('linkedinUrl');

  static String _link(String key) => EnvLoader.instance.getString(key);
}
