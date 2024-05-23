// MIT License
//
// Copyright (c) 2024 Krittapong Kijchaiyaporn, Piyathat Chimpon, Piradee Suwanpakdee, Wilawan W.Wilodjananunt, Dittaya Wanvarie
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:epilepsy_care_pmk/screens/main_page.dart';
import 'package:epilepsy_care_pmk/screens/register.dart';
import 'package:epilepsy_care_pmk/services/notification_service.dart';
import 'package:epilepsy_care_pmk/services/user_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A SharedPreference instance for the whole app.
/// Will be init in main before the app opens so that every page
/// that want to access it doesn't have to use async/await.
/// Right now, this method causes cyclic dependency, but it doesn't
/// seem to be a problem for now.
///
/// Inspiration from: https://stackoverflow.com/a/51228189
///
/// If cyclic dep were to became too much of a problem, then it might
/// be worth it to look into dependency injection tools such as GetIt.
late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Prevent errors from awaiting later
  prefs = await SharedPreferences.getInstance();
  NotificationService.initNotification();
  initializeDateFormatting('th');  // Prior to calling DateFormat.yMMMEd('th').add_Hm(), we need to init date formatting here first

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfileService(),
      builder: (context, _) => MaterialApp(
        // To change the app's name, you need to go into each platform's manifest file (https://stackoverflow.com/questions/49353199/how-can-i-change-the-app-display-name-build-with-flutter)
        title: 'Epilepsy Care (ไทย)',
        // https://docs.flutter.dev/cookbook/design/themes
        theme: ThemeData(
          useMaterial3: true,
          // https://docs.flutter.dev/release/breaking-changes/material-3-default
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          // Was going to use textTheme to handle the whole app's font,
          // but it seemed like it will impact other widgets too much, so we'll defined extra ones instead
          // textTheme: TextTheme(
          //   labelSmall: TextStyle(fontWeight: FontWeight.bold,)
          // )
        ),
        home: Consumer<UserProfileService>(
          builder: (context, model, child) => !model.isRegistered ? const Register() : const MainPage(),
        )
      ),
    );
  }
}


