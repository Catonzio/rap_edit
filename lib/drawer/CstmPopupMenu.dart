import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/drawer/CstmPopupLine.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/MixingAudioPage.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/pages/RegistrationsPage.dart';
import 'package:rap_edit/pages/TextsPage.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';


class CstmPopupMenu extends StatelessWidget {
  final MyPageInterface page;

  CstmPopupMenu({
    Key key,
    this.page
  });

  List<PopupMenuEntry> getButtons() {
    var buttonsMap = createButtons();
    List<PopupMenuEntry> buttons = List();

    buttons
      ..add(
      PopupMenuItem(
        child: Text("Navigation", style: TextStyle(fontSize: 20, color: MyColors.textColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
      )
    )
    ..add(
      PopupMenuDivider(
        height: 1,
      )
    );

    if(page is WritingPageState) {
      WritingPageState state = page as WritingPageState;
      buttonsMap.forEach((key, value) {
        if(key != ButtonsNames.buttonWrite && key != ButtonsNames.buttonCancel)
          buttons.add(value);
      });
    }

    else if(page is ChoosingBeatsPageState) {
      ChoosingBeatsPageState state = page as ChoosingBeatsPageState;
      buttons.add(
          CstmPopupLine(
            text: "Load YouTube",
            icon: Icons.play_circle_filled,
          ).getButton()
      );
      buttons.add(
          CstmPopupLine(
            text: "Load File System",
            icon: Icons.library_music,
          ).getButton()
      );
      buttonsMap.forEach((key, value) {
        if(key != ButtonsNames.buttonLoadBeats && key != ButtonsNames.buttonCancel)
          buttons.add(value);
      });
    }

    else if(page is RegistrationsPageState) {
      RegistrationsPageState state = page as RegistrationsPageState;
      buttonsMap.forEach((key, value) {
        if(key != ButtonsNames.buttonLoadRecs && key != ButtonsNames.buttonCancel)
          buttons.add(value);
      });
    }

    else if(page is TextsPageState) {
      TextsPageState state = page as TextsPageState;
      buttonsMap.forEach((key, value) {
        if(key != ButtonsNames.buttonLoadTexts && key != ButtonsNames.buttonCancel)
          buttons.add(value);
      });
    }

    else if(page is MixingAudioPageState) {
      MixingAudioPageState state = page as MixingAudioPageState;
      buttonsMap.forEach((key, value) {
        if(key != ButtonsNames.buttonMixing && key != ButtonsNames.buttonCancel)
          buttons.add(value);
      });
    }

    else {
      buttonsMap.forEach((key, value) => { buttons.add(value) });
    }

    return buttons;
  }

  Map createButtons() {
    var buttonsMap = Map();

    buttonsMap[ButtonsNames.buttonLoadBeats] = CstmPopupLine(
      text: "Load beats",
      icon: Icons.queue_music,
      routeName: ChoosingBeatsPage.routeName,
    ).getButton();

    buttonsMap[ButtonsNames.buttonLoadTexts] = CstmPopupLine(
      text: "Load texts",
      icon: Icons.file_upload,
      routeName: TextsPage.routeName,
    ).getButton();

    buttonsMap[ButtonsNames.buttonLoadRecs] = CstmPopupLine(
      text: "Load recs",
      icon: Icons.record_voice_over,
      routeName: RegistrationsPage.routeName,
    ).getButton();

    buttonsMap[ButtonsNames.buttonWrite] = CstmPopupLine(
      text: "Write text",
      icon: Icons.edit,
      routeName: WritingPage.routeName,
    ).getButton();

    buttonsMap[ButtonsNames.buttonMixing] = CstmPopupLine(
      text: "Mix audio",
      icon: Icons.library_music,
      routeName: MixingAudioPage.routeName,
    ).getButton();

    return buttonsMap;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => getButtons(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: MyColors.deepPurple.withOpacity(0.95),
      icon: Icon(
        Icons.menu,
        color: MyColors.textColor,
      ),
      onSelected: (value) {
        page.loadPage(value);
      },

    );
  }

}

class ButtonsNames {
  static String sized30 = 'sized30';
  static String sized10 = 'sized10';
  static String buttonCancel = 'buttonCancel';
  static String buttonLoadBeats = 'buttonLoadBeats';
  static String buttonLoadTexts = 'buttonLoadTexts';
  static String buttonLoadRecs = 'buttonLoadRecs';
  static String buttonWrite = 'buttonWrite';
  static String buttonMixing = 'buttonMixing';
}