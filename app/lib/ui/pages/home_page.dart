import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/ui/widgets/player/player_widget.dart';
import 'package:rap_edit/ui/widgets/writer_widget.dart';
import 'package:rap_edit/utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Writing Page"),
        // automaticallyImplyLeading: false,
      ),
      endDrawer: pagesDrawer,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const LateralMenu(),
            // const VerticalDivider(
            //   width: 25,
            // ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PlayerWidget(
                    height: context.height * 0.2,
                    width: context.width * 0.9,
                  ),
                  WriterWidget(
                    width: context.width * 0.9,
                    height: context.height * 0.5,
                  )
                ]),
          ],
        ),
      ),
    );
  }
}
