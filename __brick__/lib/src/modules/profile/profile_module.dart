import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/constants/constants.dart';
import 'data/repositories/profile_repository.dart';
import 'domain/repositories/i_profile_repository.dart';
import 'domain/use_cases/use_cases.dart';
import 'presentation/views/views.dart';

class ProfileModule extends Module {
  final List<ModularRoute> _routes = [
    ChildRoute(AppRoute.updateProfile.base, child: (_) => UpdateProfileView()),
  ];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IProfileRepository>(
      () => ProfileRepository(
        auth: Modular.get<FirebaseAuth>(),
        store: Modular.get<FirebaseFirestore>(),
        storage: Modular.get<FirebaseStorage>(),
      ),
    );

    i.addLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(
        profileRepository: Modular.get<IProfileRepository>(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    for (final ModularRoute route in _routes) {
      r.add(route);
    }
  }
}
