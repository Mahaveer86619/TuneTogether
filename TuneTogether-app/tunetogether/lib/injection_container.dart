import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunetogether/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:tunetogether/features/auth/data/sources/auth_datasource.dart';
import 'package:tunetogether/features/auth/domain/repositories/auth_repository.dart';
import 'package:tunetogether/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:tunetogether/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:tunetogether/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tunetogether/features/home/data/repositories/home_repository_impl.dart';
import 'package:tunetogether/features/home/data/sources/remote_source.dart';
import 'package:tunetogether/features/home/domain/repositories/home_repositories.dart';
import 'package:tunetogether/features/home/domain/usecases/get_joined_groups_details_by_id_usecase.dart';
import 'package:tunetogether/features/home/domain/usecases/get_user_details_usecase.dart';
import 'package:tunetogether/features/home/presentation/bloc/home_bloc.dart';
import 'package:tunetogether/features/join_groups/data/repository/join_group_repository_impl.dart';
import 'package:tunetogether/features/join_groups/data/sources/join_groups_sources.dart';
import 'package:tunetogether/features/join_groups/domain/repository/join_group_repository.dart';
import 'package:tunetogether/features/join_groups/domain/usecases/get_public_groups_usecase.dart';
import 'package:tunetogether/features/join_groups/presentation/bloc/join_group_bloc.dart';

import 'common/app_user_cubit/app_user_cubit.dart';

final sl = GetIt.instance;

Future<void> registerDependencies() async {
  await other();
  await core();
  await dataSources();
  await repositories();
  await useCases();
  await blocs();
}

Future<void> other() async {
  //* Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  //* Register FlutterSecureStorage
  const secureStorage = FlutterSecureStorage();
  sl.registerSingleton<FlutterSecureStorage>(secureStorage);

  //* Register Logger
  final logger = Logger();
  sl.registerSingleton<Logger>(logger);
}

// Future<void> services() async {
//   //* Firebase
//   // auth
//   final firebaseAuth = FirebaseAuth.instance;
//   sl.registerSingleton<FirebaseAuth>(firebaseAuth);
//   // cloud firestore
//   final firestore = FirebaseFirestore.instance;
//   sl.registerSingleton<FirebaseFirestore>(firestore);
//   // storage
//   final storage = FirebaseStorage.instance;
//   sl.registerSingleton<FirebaseStorage>(storage);

//   //* Supabase
//   final supabase = Supabase.instance.client;
//   sl.registerSingleton<SupabaseClient>(supabase);

//   //* Google auth
//   final googleAuthProvider = GoogleAuthProvider();
//   sl.registerFactory<GoogleAuthProvider>(() => googleAuthProvider);
// }

Future<void> core() async {
  //* Register AppUserCubit
  sl.registerSingleton<AppUserCubit>(
    AppUserCubit(
      logger: sl<Logger>(),
      secureStorage: sl<FlutterSecureStorage>(),
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );
}

Future<void> dataSources() async {
  //* Auth DataSource
  sl.registerFactory<AuthDatasource>(
    () => AuthDatasource(
      logger: sl<Logger>(),
    ),
  );
  //* Home DataSource
  sl.registerFactory<HomeRemoteSource>(
    () => HomeRemoteSource(
      logger: sl<Logger>(),
    ),
  );
  //* JoinGroup DataSource
  sl.registerFactory<JoinGroupsSources>(
    () => JoinGroupsSources(
      logger: sl<Logger>(),
    ),
  );
}

Future<void> repositories() async {
  //* Auth Repository
  sl.registerFactory<AuthRepository>(
    () => AuthRepositoryImp(
      logger: sl<Logger>(),
      authDataSource: sl<AuthDatasource>(),
    ),
  );
  //* Home Repository
  sl.registerFactory<HomeRepository>(
    () => HomeRepositoryImpl(
      logger: sl<Logger>(),
      homeDataSource: sl<HomeRemoteSource>(),
    ),
  );
  //* JoinGroup Repository
  sl.registerFactory<JoinGroupRepository>(
    () => JoinGroupRepositoryImpl(
      logger: sl<Logger>(),
      joinGroupsSources: sl<JoinGroupsSources>(),
    ),
  );
}

Future<void> useCases() async {
  //* Auth UseCase
  // Sign up with email and password
  sl.registerFactory<SignUpUsecase>(
    () => SignUpUsecase(authRepository: sl<AuthRepository>()),
  );
  // Sign in with email and password
  sl.registerFactory<SignInUsecase>(
    () => SignInUsecase(authRepository: sl<AuthRepository>()),
  );

  //* Home UseCase
  // Get joined groups details by id
  sl.registerFactory<GetJoinedGroupsDetailsByIdUsecase>(
    () => GetJoinedGroupsDetailsByIdUsecase(repository: sl<HomeRepository>()),
  );
  // Get user details by id
  sl.registerFactory<GetUserDetailsUsecase>(
    () => GetUserDetailsUsecase(repository: sl<HomeRepository>()),
  );

  //* JoinGroup UseCase
  // Get public groups
  sl.registerFactory<GetPublicGroupsUsecase>(
    () =>
        GetPublicGroupsUsecase(joinGroupRepository: sl<JoinGroupRepository>()),
  );
}

Future<void> blocs() async {
  //* Auth Bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      appUserCubit: sl<AppUserCubit>(),
      logger: sl<Logger>(),
      signUpUsecase: sl<SignUpUsecase>(),
      signInUsecase: sl<SignInUsecase>(),
    ),
  );

  //* Home Bloc
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      logger: sl<Logger>(),
      appUserCubit: sl<AppUserCubit>(),
      getUserDetailsEvent: sl<GetUserDetailsUsecase>(),
      getJoinedGroupsEvent: sl<GetJoinedGroupsDetailsByIdUsecase>(),
    ),
  );

  //* JoinGroup Bloc
  sl.registerFactory<JoinGroupBloc>(
    () => JoinGroupBloc(
      logger: sl<Logger>(),
      appUserCubit: sl<AppUserCubit>(),
      getPublicGroupsUsecase: sl<GetPublicGroupsUsecase>(),
    ),
  );
}
