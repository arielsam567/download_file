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
              body: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width - 150,
                                child: TextField(
                                  enabled: !controller.loading,
                                  maxLines: null,
                                  controller: controller.textController,
                                  decoration: InputDecoration(
                                    labelText: 'URL',
                                    border: const OutlineInputBorder(),
                                    labelStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                                child: Column(
                                  children: [
                                    if (controller.hasText()) ...[
                                      IconButton(
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => controller.clearText(),
                                      ),
                                    ] else ...[
                                      IconButton(
                                        icon: const Icon(Icons.paste),
                                        onPressed: () => controller.pasteText(),
                                      ),
                                    ]
                                  ],
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
                      if (controller.loading) ...[
                        const SizedBox(height: 20),
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
                      if (controller.files.isNotEmpty) ...[
                        const Text('Files:'),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.files.length,
                          itemBuilder: (context, index) {
                            final file = controller.files[index];
                            return ListTile(
                                title: RichText(
                              text: TextSpan(
                                children: [
                                  //FILENAME
                                  const TextSpan(
                                    text: 'Filename: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: file.filename,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  //PATH
                                  const TextSpan(
                                    text: '\nPath: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: file.path,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  //URL
                                  const TextSpan(
                                    text: '\nURL: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: file.url,
                                    style: const TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                  //DURATION
                                  const TextSpan(
                                    text: '\nDuration: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${file.duration.inSeconds} seconds',
                                    style: const TextStyle(
                                      color: Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          },
                        )
                      ]
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
