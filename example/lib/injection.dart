import 'package:kappa/kappa.dart';
import 'package:kappa/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/custom_auth_data_source.dart';
import 'features/product/data/product_remote_data_source.dart';
import 'features/product/data/product_repository_impl.dart';
import 'features/product/presentation/product_cubit.dart';

void initExampleInjection() {
  // 1. Initialize Default Auth from Kappa
  SL.initAuthFeature();

  // 2. Override specific implementations for our custom API
  SL.initFeatureServices((i) {
    // Custom Auth Remote Data Source (Overriding the default one)
    i.unregister<AuthRemoteDataSource>();
    i.registerLazySingleton<AuthRemoteDataSource>(() => CustomAuthRemoteDataSourceImpl(i()));

    // Product Feature
    i.registerLazySingleton<ProductRemoteDataSource>(() => MockProductRemoteDataSource());
    i.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(i()));
    i.registerFactory<ProductCubit>(() => ProductCubit(i()));
  });
}
