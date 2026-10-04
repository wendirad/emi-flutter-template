import '../utils/utils.dart';

class EndPoints {
  static final String avatarsPublicProvider = EnvLoader.instance.getString(
    'avatarsPublicProvider',
  );
}
