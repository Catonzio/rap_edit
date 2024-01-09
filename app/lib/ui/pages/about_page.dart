import 'package:flutter/material.dart';
import 'package:rap_edit/utils/constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("About Page"),
        ),
        endDrawer: pagesDrawer,
        body: SafeArea(
          child: Center(
              child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                ...aboutAppInfo.entries.map((e) => ListTile(
                      title: Text(e.key),
                      subtitle: Text(e.value),
                    )),
                const Spacer(),
                const Divider(),
                ...aboutAuthorInfo.entries.map((e) => ListTile(
                      title: Text(e.key),
                      subtitle: SelectableText(e.value),
                    )),
              ]),
            ),
          )),
        ));
  }
}
