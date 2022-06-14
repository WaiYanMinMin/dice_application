import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:dice_application/src/presentation/provider/sound_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  AudioPlayer rollDiceSound = AudioPlayer();
  IconData? soundIcon;
  IconData getSoundIcon() {
    if (muted == true) {
      return Icons.volume_off_rounded;
    } else if (muted == false) {
      return Icons.volume_up_rounded;
    } else {
      return Icons.volume_off_rounded;
    }
  }

  void playAudio() async {
    rollDiceSound = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    final player = AudioCache(prefix: 'assets/audio/');
    final url = await player.load('buttonSound.mp3');
    final result = await rollDiceSound.play(url.path, isLocal: true, volume: 1);
    log(result.toString());
  }

  bool muted = false;
  @override
  Widget build(BuildContext context) {
    final themeColorProvider =
        Provider.of<ThemeProvider>(context, listen: true);
    Color? themecolor = themeColorProvider.getThemecolor();
    String? bgImagePath = themeColorProvider.getImgpath();
    final soundProvider = Provider.of<SoundProvider>(context, listen: true);
    muted = soundProvider.getMuted();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Setting",
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
              GestureDetector(
                onTap: () => {
                  if (muted == false)
                    {
                      setState(() {
                        soundIcon = Icons.volume_off_rounded;
                      }),
                      soundProvider.setMuted(true)
                    }
                  else if (muted == true)
                    {
                      playAudio(),
                      setState(() {
                        soundIcon = Icons.volume_up_rounded;
                      }),
                      soundProvider.setMuted(false)
                    }
                },
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: themecolor,
                        width: 2,
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sound",
                          style: GoogleFonts.armata(
                            fontSize: 24,
                            color: themecolor,
                          )),
                      Icon(
                        getSoundIcon(),
                        color: themecolor,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () => {
                  if (muted == false) {playAudio()}
                },
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: themecolor,
                        width: 2,
                      )),
                  child: Center(
                    child: Text("Buy Points",
                        style: GoogleFonts.armata(
                          fontSize: 20,
                          color: themecolor,
                        )),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
