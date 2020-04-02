import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rap_edit/custom_widgets/CstmAlertDialog.dart';
import 'package:rap_edit/pages/WritingPage/WritingPage.dart';
import 'package:rap_edit/support/MyColors.dart';

import '../models/SongSingleton.dart';
import '../pages/WritingPage/WritingPage.dart';
import '../support/MyColors.dart';
import 'CstmTextField.dart';

class FloatingButtonsCarousel extends StatefulWidget {
  final WritingPageState writingPage;
  FloatingButtonsCarousel(this.writingPage);

  @override
  State createState() => new FloatingButtonsCarouselState(writingPage);
}

class FloatingButtonsCarouselState extends State<FloatingButtonsCarousel> with TickerProviderStateMixin {
  AnimationController _controller;
  WritingPageState writingPage;

  static const List<IconData> icons = const [ Icons.file_download, Icons.save, Icons.delete_forever ];

  FloatingButtonsCarouselState(this.writingPage);

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        animationBehavior: AnimationBehavior.normal
    );
  }

  Widget build(BuildContext context) {
    return new Row(
        mainAxisSize: MainAxisSize.min,
        children: generateLittleFloatingButton().toList()..add(
          new Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [MyColors.endElementColor, MyColors.primaryColor]
                ),
                borderRadius: BorderRadius.circular(50.0)
            ),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.transparent,
              child: new AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return new Transform(
                    transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: new Icon(_controller.isDismissed ? Icons.apps : Icons.close, color: MyColors.textColor),
                  );
                },
              ),
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
            ),
          )
        ),
      );
  }

  List<Widget> generateLittleFloatingButton() {
    List<Widget> list = new List();
    Widget loadButton = new Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: new ScaleTransition(
        scale: new CurvedAnimation(
          parent: _controller,
          curve: new Interval(
              0.0,
              1.0 - 0 / icons.length / 2.0,
              curve: Curves.easeInOutCubic
          ),
        ),

        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [MyColors.endElementColor, MyColors.primaryColor]
              ),
              borderRadius: BorderRadius.circular(50.0)
          ),
          child: new FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.transparent,
            mini: true,
            child: new Icon(icons[0], color: MyColors.textColor),
            onPressed: () { writingPage.loadTexts(); },
          ),
        )
      ),
    );
    Widget saveButton = new Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: new ScaleTransition(
        scale: new CurvedAnimation(
          parent: _controller,
          curve: new Interval(
              0.0,
              1.0 - 0 / icons.length / 2.0,
              curve: Curves.easeInOutCubic
          ),
        ),

        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [MyColors.endElementColor, MyColors.primaryColor]
              ),
              borderRadius: BorderRadius.circular(50.0)
          ),
          child: new FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.transparent,
            mini: true,
            child: new Icon(icons[1], color: MyColors.textColor),
            onPressed: () => { alertSaveText(context) },
          ),
        )
      ),
    );
    Widget deleteButton = new Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: new ScaleTransition(
        scale: new CurvedAnimation(
          parent: _controller,
          curve: new Interval(
              0.0,
              1.0 - 1 / icons.length / 2.0,
              curve: Curves.easeInOutCubic
          ),
        ),

        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [MyColors.endElementColor, MyColors.primaryColor]
              ),
              borderRadius: BorderRadius.circular(50.0)
          ),
          child: new FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.transparent,
            mini: true,
            child: new Icon(icons[2], color: MyColors.textColor),
            onPressed: () { alertDeleteText(context); },
          ),
        )
      ),
    );

    list.add(loadButton);
    list.add(saveButton);
    list.add(deleteButton);

    return list;
  }

  alertSaveText(BuildContext context) {
    TextEditingController titleController = new TextEditingController();

    if(SongSingleton.instance.currentSong != null && SongSingleton.instance.currentSong.title.isNotEmpty)
      titleController.text = SongSingleton.instance.currentSong.title;

    Widget alert = CstmAlertDialog(
      dialogTitle: "Saving",
      continueText: "Save",
      height: 100,
      body: Column(
        children: <Widget>[
          Text("How to save?"),
          SizedBox(height: 20.0,),
          CstmTextField(
            maxLines: 1,
            controller: titleController,
            hintText: "insert title",
          )
        ],
      ),
      pressed: () {
        if(this.writingPage != null) {
          this.writingPage.saveFile(context, titleController.text.trim());
          Navigator.pop(context);
        }
      },
    );

    // show the dialog
    showMyDialog(context, alert);
  }

  alertDeleteText(BuildContext context) {
    Widget alert = CstmAlertDialog(
      body: Text("Are you sure you want to delete the text?"),
      continueText: "Delete",
      dialogTitle: "Deleting",
      pressed: () {
        if(this.writingPage != null) {
          this.writingPage.deleteText();
          Navigator.pop(context);
        }
        else
          debugPrint("fuck");
      },
    );
    // show the dialog
    showMyDialog(context, alert);
  }

  showMyDialog(BuildContext context, Widget alert) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}