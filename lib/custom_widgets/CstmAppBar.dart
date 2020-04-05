import 'package:flutter/cupertino.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmAppBar extends StatelessWidget {
  final String title;

  CstmAppBar({
    Key key,
    this.title
  });

  @override
  Widget build(BuildContext context) {
    return GradientAppBar(
      title: Text(title, style: CstmTextTheme.pageTitle,),
      centerTitle: true,
      backgroundColorStart: MyColors.deepPurple,
      backgroundColorEnd: MyColors.endAppBar,
      //serve per non permettere di tornare indietro dall'appbar
      //automaticallyImplyLeading: false,
    );
  }

}