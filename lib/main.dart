import 'dart:async';
import 'dart:isolate';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tp_flutter/data_source/api_poste_data_source.dart';
import 'package:tp_flutter/data_source/poste_data_source.dart';
import 'package:tp_flutter/models/poste.dart';
import 'package:tp_flutter/pages/add_page.dart';
import 'package:tp_flutter/pages/details_page.dart';
import 'package:tp_flutter/pages/home_page.dart';
import 'package:tp_flutter/poste_bloc/bloc/poste_bloc.dart';
import 'package:tp_flutter/repository/poste_repository.dart';
import 'package:tp_flutter/widget/list_tile.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runZonedGuarded<Future<void>>(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;

      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);

    runApp(MyApp());
  }, FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PosteRepository>(
      create: (context) =>
          PosteRepository(remoteDataSource: ApiPosteDataSource()),
      child: BlocProvider<PosteBloc>(
        create: (context) => PosteBloc(
          repository: RepositoryProvider.of<PosteRepository>(context),
        )..add(GetAllPoste(10)),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(brightness: Brightness.dark),
          routes: {
            '/': (context) => const AccueilPage(),
            AjoutPage.routeName: (context) => const AjoutPage(),
          },
          onGenerateRoute: (settings) {
            Widget content = const SizedBox.shrink();

            switch (settings.name) {
              case DetailsPage.routeName:
                final arguments = settings.arguments;
                if (arguments is Poste) {
                  content = DetailsPage(poste: arguments);
                }
                break;
            }

            return MaterialPageRoute(
              builder: (context) {
                return content;
              },
            );
          },
        ),
      ),
    );
  }
}
