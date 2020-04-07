import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/MyColors.dart';

import '../custom_widgets/CstmAlertDialog.dart';

class FloatingDeleteButton extends StatelessWidget {

  final WritingPageState writingPage;

  FloatingDeleteButton({
    Key key,
    @required this.writingPage
  });

//  Container(
//  decoration: BoxDecoration(
//  gradient: LinearGradient(
//  begin: Alignment.topRight,
//  end: Alignment.bottomLeft,
//  colors: [MyColors.endElementColor, MyColors.primaryColor]
//  ),
//  borderRadius: BorderRadius.circular(50.0)
//  ),

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [MyColors.endElementColor, MyColors.primaryColor]
        ),
        borderRadius: BorderRadius.circular(100.0)
      ),
      child: FloatingActionButton(
        child: Icon(Icons.delete_forever),
        backgroundColor: Colors.transparent,
        onPressed: () => { alertDeleteText(context) },
      ),
    );
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