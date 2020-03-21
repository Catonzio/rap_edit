import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/MyColors.dart';

class WelcomePage extends StatelessWidget {
  static String routeName = "/welcomePage";

  @override
  Widget build(BuildContext context) {
    return CstmBackGround(
      body: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30,),
              Text(
                  "Welcome to RapEdit!",
                  style: TextStyle(fontSize: 40, color: MyColors.textColor)
              ),
              SizedBox(height: 20,),
              Expanded(
                child: Text(
                    "This is a simple App to write and edit texts of songs.\n" +
                        "For the moment is in alpha version, so you can find some bugs or errors.\n\n" +
                        "The main features are:\n" +
                        "\t- Write text;\n" +
                        "\t- Upload beats;\n" +
                        "\t- Save text in a file with a title;\n" +
                        "\t- Record a registration of your song.\n" +
                        "\nTo load a beat, click on the button \"Load\". "
                            "To start a registration, click on the red button. "
                            "To see other options, click on the button at the bottom-right.\n" +
                        "Enjoy!\n\n\n",
                    style: TextStyle(fontSize: 20, color: MyColors.textColor),
                ),
              ),
              SizedBox(height: 10,),
              Text(
                  "For suggestions, bug reports or clarifications, write me an email at \n"
                      "danilocatone@gmail.com\n or on WhatsApp at the number\n +39 331 623 9724."
                      "\n\nThanks for being a tester!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: MyColors.textColor),
                ),
              SizedBox(height: 30,),
              CstmButton(
                text: "Let's start!",
                pressed: () => { Navigator.pushNamed(context, WritingPage.routeName) },
              )
              ],
          ),
        ),
      ),
    );
  }

}