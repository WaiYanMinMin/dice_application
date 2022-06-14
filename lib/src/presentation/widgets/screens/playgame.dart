import 'dart:developer' as dev;
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:dice_application/src/presentation/provider/points_provider.dart';
import 'package:dice_application/src/presentation/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/sound_provider.dart';
import '../../provider/theme_provider.dart';

class PlayGame extends StatefulWidget {
  const PlayGame({Key? key}) : super(key: key);

  @override
  State<PlayGame> createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  int points = 0;
  AudioPlayer rollDiceSound = AudioPlayer();
  TextEditingController answerController = TextEditingController();
  bool muted = false;
  void playAudio() async {
    rollDiceSound = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    final player = AudioCache(prefix: 'assets/audio/');
    final url = await player.load('diceRollSound.mp3');
    final result = await rollDiceSound.play(url.path, isLocal: true, volume: 1);
  }

  @override
  void dispose() {
    rollDiceSound.dispose();
    super.dispose();
  }

  String? diceLoadingImgpath;
  Color? themecolor;
  String checkcolor = "yellow";

  List<String?> reddiceImages = [
    "assets/images/DiceOneRed.png",
    "assets/images/DiceTwoRed.png",
    "assets/images/DiceThreeRed.png",
    "assets/images/DiceFourRed.png",
    "assets/images/DiceFiveRed.png",
    "assets/images/DiceSixRed.png"
  ];
  List<String?> bluediceImages = [
    "assets/images/DiceOneBlue.png",
    "assets/images/DiceTwoBlue.png",
    "assets/images/DiceThreeBlue.png",
    "assets/images/DiceFourBlue.png",
    "assets/images/DiceFiveBlue.png",
    "assets/images/DiceSixBlue.png"
  ];
  List<String?> yellowdiceImages = [
    "assets/images/DiceOneYellow.png",
    "assets/images/DiceTwoYellow.png",
    "assets/images/DiceThreeYellow.png",
    "assets/images/DiceFourYellow.png",
    "assets/images/DiceFiveYellow.png",
    "assets/images/DiceSixYellow.png"
  ];
  int diceImageOneIndex = 0;
  int diceImageTwoIndex = 0;
  List<String?> getDiceImgs() {
    if (checkcolor == "Yellow") {
      return yellowdiceImages;
    } else if (checkcolor == "Red") {
      return reddiceImages;
    } else if (checkcolor == "Blue") {
      return bluediceImages;
    } else {
      return yellowdiceImages;
    }
  }

  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<SoundProvider>(context, listen: true);
    muted = soundProvider.getMuted();
    final themeColorProvider =
        Provider.of<ThemeProvider>(context, listen: true);
    final pointsProvider = Provider.of<PointsProvider>(context, listen: true);
    themecolor = themeColorProvider.getThemecolor();
    checkcolor = themeColorProvider.getColor();
    points = pointsProvider.getPoints();
    calculateResult() {
      if (!muted) {
        playAudio();
      }
      if (answerController.text.isEmpty) {
        showMessage(context, "Answer is empty.", Colors.red);
      } else if (!isNumeric(answerController.text)) {
        showMessage(context, "Answer must be a number.", Colors.red);
      } else if (int.parse(answerController.text) < 2 ||
          int.parse(answerController.text) > 12) {
        showMessage(context, "Answer must be from 2 to 12.", Colors.red);
      } else {
        setState(() {
          diceImageOneIndex = Random().nextInt(6);
          diceImageTwoIndex = Random().nextInt(6);
        });
        if (int.parse(answerController.text) ==
            (diceImageOneIndex + diceImageTwoIndex + 2)) {
          dev.log("win");
          showMessage(
            context,
            "Congratulation!You win.",
            themecolor ?? const Color(0xffDFE310),
          );
          pointsProvider.setPoints(points + 10);
        } else {
          showMessage(context, "Try Again next time.", Colors.black45);
          dev.log("lost");
        }
      }
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ("assets/images/titleDice$checkcolor.png"),
            fit: BoxFit.contain,
            width: 200,
            height: 100,
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            "Guess the number!",
            style: GoogleFonts.armata(
              color: themecolor ?? const Color(0xffDFE310),
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(
                  getDiceImgs()[diceImageOneIndex] ??
                      "assets/images/DiceOneYellow.png",
                ),
                fit: BoxFit.contain,
                height: 80,
                width: 80,
              ),
              Image(
                image: AssetImage(
                  getDiceImgs()[diceImageTwoIndex] ??
                      "assets/images/DiceOneYellow.png",
                ),
                fit: BoxFit.contain,
                height: 80,
                width: 80,
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            width: 300,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: themecolor ?? const Color(0xffDFE310),
                )),
            child: TextFormField(
                onFieldSubmitted: (_) {
                  calculateResult();
                },
                keyboardType: TextInputType.number,
                controller: answerController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter number between 0-12",
                  hintStyle: GoogleFonts.armata(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 15,
                  ),
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          MainButtonWidget(
            onPressedFunction: () {
              calculateResult();
            },
            buttonText: "Roll",
            width: 100,
            height: 30,
            buttonTextFontSize: 15,
            color: themecolor ?? const Color(0xffDFE310),
          )
        ],
      ),
    ));
  }
}

///bottom banner error for not enough points to report
void showMessage(BuildContext context, String message, Color txtcolor) {
  showDialog(
    context: context,
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
        child: Center(
          child: Text(
            message,
            style: TextStyle(color: txtcolor),
          ),
        ),
        height: 100,
      ),
    ),
  );
}
