import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:dice_application/src/presentation/provider/theme_provider.dart';
import 'package:dice_application/src/presentation/widgets/screens/settings.dart';
import 'package:dice_application/src/presentation/widgets/screens/themescreen.dart';
import 'package:dice_application/src/presentation/widgets/screens/playgame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/points_provider.dart';
import '../../provider/sound_provider.dart';
import '../reusablewidgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AudioPlayer buttonSound = AudioPlayer();
  bool muted = false;
  void playAudio() async {
    buttonSound = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    final player = AudioCache(prefix: 'assets/audio/');
    final url = await player.load('buttonSound.mp3');
    final result = await buttonSound.play(url.path, isLocal: true, volume: 1);
    log(result.toString());
  }

  @override
  void dispose() {
    buttonSound.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pointsProvider = Provider.of<PointsProvider>(context, listen: true);
    final points = pointsProvider.getPoints();
    final soundProvider = Provider.of<SoundProvider>(context, listen: true);
    muted = soundProvider.getMuted();
    final themeColorProvider =
        Provider.of<ThemeProvider>(context, listen: true);
    Color? themecolor = themeColorProvider.getThemecolor();
    String? bgImagePath = themeColorProvider.getImgpath();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          enableFeedback: false,
          backgroundColor: Colors.white,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.red,
                    Colors.yellow,
                    Colors.green,
                    Colors.pink,
                    Colors.blue,
                  ]),
            ),
          ),
          onPressed: () => {
            if (!muted)
              {
                playAudio(),
              },
            Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => const ThemeScreen())))
          },
        ),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text("Dice Application",
              style: GoogleFonts.armata(
                fontSize: 24,
                color: themecolor,
              )),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bgImagePath),
              fit: BoxFit.cover,
            ),
            color: Colors.white,
          ),
          child: Center(
            child: SizedBox(
              height: 200,
              child: Column(children: [
                MainButtonWidget(
                  onPressedFunction: () {
                    if (!muted) {
                      playAudio();
                    }
                    Get.to(const PlayGame());
                  },
                  color: themecolor,
                  buttonText: "Play",
                  height: 60,
                  width: 200,
                  buttonTextFontSize: 18,
                ),
                const SizedBox(
                  height: 30,
                ),
                MainButtonWidget(
                  buttonTextFontSize: 18,
                  onPressedFunction: () {
                    if (!muted) {
                      playAudio();
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const Settings())));
                  },
                  color: themecolor,
                  buttonText: "Settings",
                  height: 60,
                  width: 180,
                ),
              ]),
            ),
          ),
        ));
  }
}
