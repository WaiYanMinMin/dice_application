import 'package:dice_application/src/database/persistence.dart';
import 'package:dice_application/src/presentation/provider/points_provider.dart';
import 'package:dice_application/src/presentation/provider/sound_provider.dart';
import 'package:dice_application/src/presentation/provider/theme_provider.dart';
import 'package:dice_application/src/presentation/widgets/screens/homescreen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('persistence_box');
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Persistence persistenceBox = Persistence();
    if (persistenceBox.checkFirstRun()) {
      persistenceBox.setFirstRun(false);
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PointsProvider>(
          create: (context) => PointsProvider(),
        ),
        ChangeNotifierProvider<SoundProvider>(
          create: (context) => SoundProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        )
      ],
      child: const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
