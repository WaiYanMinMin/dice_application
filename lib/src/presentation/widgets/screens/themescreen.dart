import 'package:audioplayers/audioplayers.dart';
import 'package:dice_application/src/presentation/provider/points_provider.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/sound_provider.dart';
import '../../provider/theme_provider.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);
  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  bool muted = false;
  AudioPlayer buttonSound = AudioPlayer();
  AudioPlayer purchaseSound = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<SoundProvider>(context, listen: true);
    muted = soundProvider.getMuted();
    void playAudio() async {
      buttonSound = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
      final player = AudioCache(prefix: 'assets/audio/');
      final url = await player.load('buttonSound.mp3');
      final result = await buttonSound.play(url.path, isLocal: true, volume: 1);
    }

    void purchaseAudio() async {
      purchaseSound = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
      final player = AudioCache(prefix: 'assets/audio/');
      final url = await player.load('purchaseSound.mp3');
      final result =
          await purchaseSound.play(url.path, isLocal: true, volume: 1);
    }

    final pointsProvider = Provider.of<PointsProvider>(context, listen: true);
    final themeColorProvider =
        Provider.of<ThemeProvider>(context, listen: true);
    String? bgImagePath;
    int onTapIndex = themeColorProvider.getOntapIndex();
    List<int> ownedThemes = themeColorProvider.getOwnedThemeList();
    bool _isSelected = themeColorProvider.getCheck();

    Color? themecolor = themeColorProvider.getThemecolor();
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    List<String> themeLists = [
      "assets/images/BGyellow.png",
      "assets/images/BGred.png",
      "assets/images/BGblue.png"
    ];
    List<String> colorList = ["Yellow", "Red", "Blue"];
    List<int> themecolorList = [0xffDFE310, 0xff922D52, 0xff8380ED];

    int? points = pointsProvider.getPoints();

    ///bottom banner error for not enough points to report
    void showErrorMessageforNotEnoughPoints(
        BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey) {
      showDialog(
        context: _scaffoldKey.currentContext ?? context,
        builder: (context) => AlertDialog(
          ///show confirm dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: const Center(
              child: Text(
                'Not enough Points. ',
                style: TextStyle(color: Colors.red),
              ),
            ),
            height: 100,
          ),
        ),
      );
    }

    ///bottom banner error for not enough points to report
    void showBuyThemeDialog(
        BuildContext context,
        GlobalKey<ScaffoldState> _scaffoldKey,
        Color themecolor,
        int points,
        int index) {
      showDialog(
        context: _scaffoldKey.currentContext ?? context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              ///cancel button
              onPressed: () {
                playAudio();
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
              ///cancel button
              onPressed: () {
                playAudio();
                ;
                Navigator.of(context, rootNavigator: true).pop();
                if (points < 100) {
                  showErrorMessageforNotEnoughPoints(context, _scaffoldKey);
                } else {
                  pointsProvider.setPoints(points - 100);
                  if (!muted) {
                    purchaseAudio();
                  }

                  themeColorProvider.addOwnedTheme(index);
                }
              },
              child: Text(
                'Buy(100 points)',
                style: TextStyle(
                  color: themecolor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],

          ///show confirm dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                'Are You Sure?',
                style: TextStyle(color: themecolor),
              ),
            ),
            height: 100,
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Theme",
            style: GoogleFonts.armata(
              fontSize: 24,
              color: themecolor,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.attach_money_rounded,
                    color: themecolor,
                  ),
                  Text(points.toString(),
                      style: GoogleFonts.armata(
                        fontSize: 18,
                        color: themecolor,
                      )),
                ],
              ),
            ),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        margin: const EdgeInsets.all(10),
        child: Center(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: (() => {
                          if (!muted) {playAudio()},
                          if (ownedThemes.contains(index))
                            {
                              themeColorProvider.setOntapIndex(index),
                              themeColorProvider.setBG(themeLists[index]),
                              themeColorProvider.selectedCheck(),
                              themeColorProvider.setThemecolor(
                                  Color(themecolorList[index]),
                                  colorList[index])
                            }
                          else
                            {
                              showBuyThemeDialog(context, _scaffoldKey,
                                  themecolor, points, index)
                            }
                        }),
                    child: SizedBox(
                      width: 160,
                      height: 300,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage(
                                      bgImagePath ?? themeLists[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          (ownedThemes.contains(index))
                              ? Positioned(
                                  top: 20,
                                  left: 0,
                                  right: 90,
                                  child: Transform.rotate(
                                      angle: -math.pi / 4,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xffD1D1D1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: 180,
                                        height: 20,
                                        child: Center(
                                          child: Text("Owned",
                                              style: GoogleFonts.armata(
                                                  fontSize: 16,
                                                  color: Colors.white60)),
                                        ),
                                      )))
                              : Positioned(
                                  top: 20,
                                  right: 5,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.attach_money_rounded,
                                        color: Color(themecolorList[index]),
                                      ),
                                      Text("100",
                                          style: GoogleFonts.armata(
                                            fontSize: 18,
                                            color: Color(themecolorList[index]),
                                          )),
                                    ],
                                  ),
                                ),
                          (_isSelected == true && index == onTapIndex)
                              ? const Positioned(
                                  top: 20,
                                  right: 5,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
