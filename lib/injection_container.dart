import 'package:dio/dio.dart';
import 'package:flutter_klontong/data/api_provider.dart';
import 'package:flutter_klontong/data/repository.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDepedencies() async {
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Depedencies
  sl.registerSingleton<ApiProvider>(ApiProvider());

  sl.registerSingleton<ProductRepository>(ProductRepository(sl()));
}
