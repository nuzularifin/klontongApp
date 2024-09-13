import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_klontong/bloc/product_bloc.dart';
import 'package:flutter_klontong/injection_container.dart';
import 'package:flutter_klontong/screen/product_list_screen.dart';
import 'package:flutter_klontong/utils/logger.dart';
import 'package:flutter_klontong/utils/screen_size_config.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  initializeDepedencies();
  LoggerService.logDebug(
      'isDebug: ${dotenv.env['DEBUG'] != null ? true : false}');
  runApp(const KlontongApp());
}

class KlontongApp extends StatelessWidget {
  const KlontongApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return MaterialApp(
      title: 'Flutter Demo Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<ProductBloc>(
        create: (context) => ProductBloc(sl()),
        child: const ProductListScreen(),
      ),
    );
  }
}
