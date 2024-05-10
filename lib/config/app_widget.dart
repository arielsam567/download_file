import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:weg_app/pages/home/home_page.dart';
import 'package:weg_app/services/storage.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            Storage.init();
          },
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'WEG APP',
        debugShowCheckedModeBanner: false,
        initialRoute: '/test',
        routes: {
          '/test': (context) => const HomePage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
