import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:weg_app/pages/home/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
        create: (context) => HomeController(),
        child: Consumer<HomeController>(
          builder: (context, controller, _) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Home Page'),
              ),
              body: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width - 100,
                              child: TextField(
                                enabled: !controller.loading,
                                controller: controller.textController,
                                decoration: InputDecoration(
                                  labelText: 'URL',
                                  labelStyle: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                  suffixIcon: SizedBox(
                                    width: 30,
                                    child: Column(
                                      children: [
                                        if (controller.hasText()) ...[
                                          IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.red,
                                            ),
                                            onPressed: () =>
                                                controller.clearText(),
                                          ),
                                        ] else ...[
                                          IconButton(
                                            icon: const Icon(Icons.paste),
                                            onPressed: () =>
                                                controller.pasteText(),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => controller.submitText(),
                              icon: Icon(
                                Icons.download,
                                color: controller.hasText()
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                          ]),
                    ),
                    CircularPercentIndicator(
                      radius: 130.0,
                      animation: true,
                      animationDuration: 100,
                      lineWidth: 15.0,
                      percent: controller.progress,
                      animateFromLastPercent: true,
                      center: Text(
                        "${(controller.progress * 100).toStringAsFixed(2)}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.grey.shade300,
                      progressColor: Colors.green,
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
