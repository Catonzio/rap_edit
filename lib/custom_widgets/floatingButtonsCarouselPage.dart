import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:rap_edit/pages/SecondPage.dart';
import '../pages/SecondPage.dart';

class FloatingButtonsCarousel extends StatefulWidget {
  final SecondPageState secondPage;
  FloatingButtonsCarousel(this.secondPage);

  @override
  State createState() => new FloatingButtonsCarouselState(secondPage);
}

class FloatingButtonsCarouselState extends State<FloatingButtonsCarousel> with TickerProviderStateMixin {
  AnimationController _controller;
  SecondPageState secondPage;

  static const List<IconData> icons = const [ Icons.file_download, Icons.save, Icons.delete_forever ];

  FloatingButtonsCarouselState(this.secondPage);

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
          onPressed: () { secondPage.loadFiles(context); },
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
          onPressed: () { secondPage.saveFile(); },
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
        if(this.secondPage != null) {
          this.secondPage.deleteText();
          Navigator.pop(context);
        }
        else
          debugPrint("fuck");
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Deleting"),
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