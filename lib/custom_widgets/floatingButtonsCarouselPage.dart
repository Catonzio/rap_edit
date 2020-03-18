import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:rap_edit/pages/WritingPage.dart';
import '../pages/WritingPage.dart';

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
          new FloatingActionButton(
            heroTag: null,
            backgroundColor: Theme.of(context).primaryColor,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(_controller.isDismissed ? Icons.apps : Icons.close),
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

        child: new FloatingActionButton(
          heroTag: null,
          backgroundColor: Theme.of(context).primaryColor,
          mini: true,
          child: new Icon(icons[0]),
          onPressed: () { writingPage.loadFiles(); },
        ),
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

        child: new FloatingActionButton(
          heroTag: null,
          backgroundColor: Theme.of(context).primaryColor,
          mini: true,
          child: new Icon(icons[1]),
          onPressed: () { writingPage.saveFile(context); },
        ),
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

        child: new FloatingActionButton(
          heroTag: null,
          backgroundColor: Theme.of(context).primaryColor,
          mini: true,
          child: new Icon(icons[2]),
          onPressed: () { alertDeleteText(context); },
        ),
      ),
    );

    list.add(loadButton);
    list.add(saveButton);
    list.add(deleteButton);

    return list;
  }

  alertDeleteText(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
            Navigator.pop(context);
        },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        if(this.writingPage != null) {
          this.writingPage.deleteText();
          Navigator.pop(context);
        }
        else
          debugPrint("fuck");
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Deleting"),
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: Text("Are you sure you want to delete the text?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}