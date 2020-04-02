import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/pages/WritingPage/WritingPage.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';

class WelcomePage extends StatelessWidget {

  static String routeName = "/welcomePage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CstmBackGround(
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30,),
                Center(
                  child: Text(
                      "Welcome to RapEdit!",
                      style: Theme.of(context).textTheme.title
                  ),
                ),
                //SizedBox(height: 20,),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Text(
                        "This is a simple App for writing and editing songs' texts.\n" +
                            "It is currently in aplha, so you could find some bugs.\n\n" +
                            "The main features are:\n" +
                            "\t- Write text;\n" +
                            "\t- Upload beats;\n" +
                            "\t- Save text in a file with a title;\n" +
                            "\t- Record a registration of your song.\n" +
                            "\nTo load a beat, click on the button \"Beats\". "
                                "To start a registration, click on the red button. "
                                "To see other options, click on the button at the bottom-right.\n" +
                            "Enjoy!\n\n"
                                "Important: DO NOT USE back navigation of your phone. Use ONLY buttons in the app.\n",
                        style: CstmTextTheme.welcomePage,
                      ),
                      //SizedBox(height: 10,),
                      Text(
                        "For suggestions, bug reports or clarifications, write me an email at \n\n"
                            "danilocatone@gmail.com\n\n or on WhatsApp at the number\n +39 331 623 9724."
                            "\n\nThanks for being a tester!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: MyColors.textColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                CstmButton(
                  text: "Let's start!",
                  pressed: () => { Navigator.pushNamed(context, WritingPage.routeName) },
                )
              ],
            )
          )
        ),
      ),
    );
  }

}