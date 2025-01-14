// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:thesis_app/dependencies/injection_container.dart' as _i901;
import 'package:thesis_app/features/auth/data/datasources/auth_data_source.dart'
    as _i745;
import 'package:thesis_app/features/auth/data/repositories/auth_repository.dart'
    as _i487;
import 'package:thesis_app/features/auth/domain/usecases/sign_in_use_case.dart'
    as _i570;
import 'package:thesis_app/features/auth/domain/usecases/sign_out_use_case.dart'
    as _i803;
import 'package:thesis_app/features/auth/domain/usecases/sign_up_use_case.dart'
    as _i317;
import 'package:thesis_app/features/auth/presentation/cubit/auth_cubit.dart'
    as _i268;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseModule = _$FirebaseModule();
    gh.factory<_i745.AuthDataSource>(() => _i745.AuthDataSource());
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i59.User>(() => firebaseModule.user);
    gh.factory<_i487.AuthRepository>(
        () => _i487.AuthRepository(gh<_i745.AuthDataSource>()));
    gh.factory<_i570.SignInUseCase>(
        () => _i570.SignInUseCase(gh<_i487.AuthRepository>()));
    gh.factory<_i803.SignOutUseCase>(
        () => _i803.SignOutUseCase(gh<_i487.AuthRepository>()));
    gh.factory<_i317.SignUpUseCase>(
        () => _i317.SignUpUseCase(gh<_i487.AuthRepository>()));
    gh.factory<_i268.AuthCubit>(() => _i268.AuthCubit(
          gh<_i570.SignInUseCase>(),
          gh<_i317.SignUpUseCase>(),
          gh<_i803.SignOutUseCase>(),
          gh<_i487.AuthRepository>(),
        ));
    return this;
  }
}

class _$FirebaseModule extends _i901.FirebaseModule {}
