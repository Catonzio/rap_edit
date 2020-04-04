import 'package:rap_edit/pages/MixingAudioPage.dart';

import 'ChoosingBeatsPage.dart';
import 'RegistrationsPage.dart';
import 'TextsPage.dart';
import 'WritingPage.dart';

abstract class MyPageInterface {
  
  /// loads a page with the given route name
  void loadPage(String routeName);
  
  ///loads the writing page
  void loadWritingPage() => loadPage(WritingPage.routeName);

  ///loads the choosing beats page
  void loadChoosingBeatsPage() => loadPage(ChoosingBeatsPage.routeName);

  ///loads the texts page
  void loadTextsPage() => loadPage(TextsPage.routeName);

  ///loads the registrations page
  void loadRegistrationsPage() => loadPage(RegistrationsPage.routeName);

  void loadMixingAudioPage() => loadPage(MixingAudioPage.routeName);
}