import 'package:esab/bluetooth/data/repositories/bluetooth_repository_impl.dart';
import 'package:esab/bluetooth/domain/use_cases/connect_device_use_case.dart';
import 'package:esab/bluetooth/domain/use_cases/disconnect_device_use_case.dart';
import 'package:esab/features/adf_settings/data/datasource/adf_settings_local_datasource.dart';
import 'package:esab/features/adf_settings/data/datasource/adf_settings_local_datasource_impl.dart';
import 'package:esab/features/adf_settings/data/repositories/adf_settings_repository_impl.dart';
import 'package:esab/features/adf_settings/domain/repositories/adf_settings_repository.dart';
import 'package:esab/features/adf_settings/domain/use_cases/delete_adf_memory_use_case.dart';
import 'package:esab/features/adf_settings/domain/use_cases/get_adf_settings_use_case.dart';
import 'package:esab/features/adf_settings/domain/use_cases/save_adf_settings_use_case.dart';
import 'package:esab/features/adf_settings/domain/use_cases/update_adf_memory_use_case.dart';
import 'package:esab/features/auth/data/datasource/remote/auth_remote_datasource_impl.dart';
import 'package:esab/features/auth/domain/use_cases/create_account_use_case.dart';
import 'package:esab/features/auth/domain/use_cases/google_signin_use_case.dart';
import 'package:esab/features/auth/domain/use_cases/resend_email_use_case.dart';
import 'package:esab/bluetooth/domain/repositories/bluetooth_repository.dart';
import 'package:esab/bluetooth/domain/use_cases/read_characteristic_use_case.dart';
import 'package:esab/bluetooth/domain/use_cases/write_characteristic_use_case.dart';
import 'package:esab/features/home/data/datasource/home_local_datasource.dart';
import 'package:esab/features/home/data/datasource/home_local_datasource_impl.dart';
import 'package:esab/features/home/data/datasource/home_remote_datasource.dart';
import 'package:esab/features/home/data/datasource/home_remote_datasource_impl.dart';
import 'package:esab/features/home/data/repositories/home_repository_impl.dart';
import 'package:esab/features/home/domain/repositories/home_repository.dart';
import 'package:esab/features/home/domain/use_cases/add_device_use_case.dart';
import 'package:esab/features/home/domain/use_cases/get_device_use_case.dart';
import 'package:esab/features/home/domain/use_cases/logout_use_case.dart';
import 'package:esab/features/home/domain/use_cases/remove_device_use_case.dart';
import 'package:esab/features/home/domain/use_cases/update_name_use_case.dart';
import 'package:esab/features/onboard/data/datasource/onboard_local_datasource.dart';
import 'package:esab/features/onboard/data/datasource/onboard_local_datasource_impl.dart';
import 'package:esab/features/onboard/data/repositories/onboard_repository_impl.dart';
import 'package:esab/features/onboard/domain/repositories/onboard_repository.dart';
import 'package:esab/features/onboard/domain/use_cases/onboard_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:esab/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:esab/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:esab/features/auth/domain/repositories/auth_repository.dart';
import 'package:esab/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

final injector = GetIt.instance;

Future<void> initSingletons() async {
  provideDataSources();
  provideRepositories();
  provideUseCases();
}

void provideDataSources() {
  // Register FirebaseAuth instance
  injector
      .registerLazySingleton<fb.FirebaseAuth>(() => fb.FirebaseAuth.instance);

  // Register GoogleSignIn instance
  injector.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // Register Auth Remote Data Source
  injector.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: injector.get<fb.FirebaseAuth>(),
      googleSignInInstance: injector.get<GoogleSignIn>(), // Add this argument
    ),
  );

  // Register Home Remote Data Source
  injector.registerFactory<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(
        firebaseAuth: injector.get<fb.FirebaseAuth>(),
      ));

  injector
      .registerFactory<HomeLocalDataSource>(() => HomeLocalDataSourceImpl());

  // Register Onboard Remote Data Source
  injector.registerFactory<OnboardLocalDataSource>(
      () => OnboardLocalDataSourceImpl());

  injector.registerFactory<AdfSettingsLocalDataSource>(
      () => AdfSettingsLocalDataSourceImpl());
}

void provideRepositories() {
  // Register Auth Repository
  injector.registerFactory<AuthRepository>(() => AuthRepositoryImpl(
      authRemoteDataSource: injector.get<AuthRemoteDataSource>()));

  // Register Home Repository
  injector.registerFactory<HomeRepository>(() => HomeRepositoryImpl(
      homeRemoteDataSource: injector.get<HomeRemoteDataSource>(),
      homeLocalDataSource: injector.get<HomeLocalDataSource>()));

  // Register Onboard Repository
  injector.registerFactory<OnboardRepository>(() => OnboardRepositoryImpl(
      onboardLocalDataSource: injector.get<OnboardLocalDataSource>()));

  injector
      .registerFactory<AdfSettingsRepository>(() => AdfSettingsRepositoryImpl(
            localDataSource: injector.get<AdfSettingsLocalDataSource>(),
          ));
  injector
      .registerFactory<BluetoothRepository>(() => BluetoothRepositoryImpl());
}

void provideUseCases() {
  //Auth
  injector.registerFactory<SignInUseCase>(
      () => SignInUseCase(authRepository: injector.get<AuthRepository>()));
  injector.registerFactory<CreateAccountUseCase>(() =>
      CreateAccountUseCase(authRepository: injector.get<AuthRepository>()));
  injector.registerFactory<GoogleSignInUseCase>(() =>
      GoogleSignInUseCase(authRepository: injector.get<AuthRepository>()));
  injector.registerFactory<ResendEmailUseCase>(
      () => ResendEmailUseCase(authRepository: injector.get<AuthRepository>()));

  //Home
  injector.registerFactory<LogoutUseCase>(
      () => LogoutUseCase(homeRepository: injector.get<HomeRepository>()));

  injector.registerFactory<AddDeviceUseCase>(
      () => AddDeviceUseCase(homeRepository: injector.get<HomeRepository>()));

  injector.registerFactory<GetDeviceUseCase>(
      () => GetDeviceUseCase(homeRepository: injector.get<HomeRepository>()));

  injector.registerFactory<UpdateNameUseCase>(
      () => UpdateNameUseCase(homeRepository: injector.get<HomeRepository>()));

  injector.registerFactory<RemoveDeviceUseCase>(() =>
      RemoveDeviceUseCase(homeRepository: injector.get<HomeRepository>()));

  //Adf Settings
  injector.registerFactory<SaveAdfSettingUseCase>(() => SaveAdfSettingUseCase(
      homeRepository: injector.get<AdfSettingsRepository>()));

  injector.registerFactory<GetAdfSettingUseCase>(() => GetAdfSettingUseCase(
      homeRepository: injector.get<AdfSettingsRepository>()));

  injector.registerFactory<DeleteAdfMemoryUseCase>(() => DeleteAdfMemoryUseCase(
      homeRepository: injector.get<AdfSettingsRepository>()));

  injector.registerFactory<UpdateAdfMemoryUseCase>(() => UpdateAdfMemoryUseCase(
      homeRepository: injector.get<AdfSettingsRepository>()));

  injector.registerFactory<ReadCharacteristicUseCase>(() =>
      ReadCharacteristicUseCase(
          bluetoothRepository: injector.get<BluetoothRepository>()));

  injector.registerFactory<WriteCharacteristicUseCase>(() =>
      WriteCharacteristicUseCase(
          bluetoothRepository: injector.get<BluetoothRepository>()));

  injector.registerFactory<ConnectDeviceUseCase>(() => ConnectDeviceUseCase(
      bluetoothRepository: injector.get<BluetoothRepository>()));

  injector.registerFactory<DisconnectDeviceUseCase>(() =>
      DisconnectDeviceUseCase(
          bluetoothRepository: injector.get<BluetoothRepository>()));
  //Onboard
  injector.registerFactory<OnboardUseCase>(
      () => OnboardUseCase(onboardLocalDataSource: injector.get()));
}
