import 'package:breathpacer/bloc/dna/dna_cubit.dart';
import 'package:breathpacer/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer/config/router/routes.dart';
import 'package:breathpacer/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PyramidCubit()),
        BlocProvider(create: (context) => FirebreathingCubit()),
        BlocProvider(create: (context) => DnaCubit()),
        BlocProvider(create: (context) => PinealCubit()),
      ],
      child: MaterialApp.router(
        title: 'Breath Pacer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.define(),
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
