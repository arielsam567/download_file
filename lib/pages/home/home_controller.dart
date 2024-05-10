// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weg_app/models/file_model.dart';

class HomeController extends ChangeNotifier {
  //https://api-qas.weg.net/dataviewer/drawing?materialNumber=16569333&serialNumber=1088699454&language=pt&country=BR

  //https://assets.website-files.com/603d0d2db8ec32ba7d44fffe/603d0e327eb2748c8ab1053f_loremipsum.pdf
  //
  String url =
      "https://api-qas.weg.net/dataviewer/drawing?materialNumber=16569333&serialNumber=1088699454&language=pt&country=BR";
  final textController = TextEditingController();
  bool loading = false;
  DateTime? startTime;
  double progress = 0;
  final List<FileModel> files = [];
  HomeController() {
    init();
  }

  init() async {
    textController.text = url;
    notifyListeners();
    //FlutterDownloader.initialize(debug: false, ignoreSsl: true);
  }

  bool isUrl(String text) {
    return text.startsWith('http://') || text.startsWith('https://');
  }

  void updateLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> submitText() async {
    if (loading || !hasText()) return;
    String text = textController.text;
    updateLoading(true);
    if (isUrl(text)) {
      await downloadFile(text);
    } else {
      print('Not a URL: $text');
    }
    updateLoading(false);

    clearText();
  }

  bool hasText() {
    return textController.text.isNotEmpty;
  }

  void clearText() {
    textController.clear();
    notifyListeners();
  }

  Future<void> pasteText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    textController.text = clipboardData?.text ?? '';
    notifyListeners();
  }

  Future<void> downloadFile(String url) async {
    startTime = DateTime.now();
    progress = 0;
    //I/flutter (11282): Invalid argument(s): Directory must be relative to the baseDirectory specified in the baseDirectory argument
    final directory = await getTemporaryDirectory();
    final String kindOfFile = url.split('.').last;
    final String filename = 'FILE${DateTime.now().millisecondsSinceEpoch}';
    print('filename: $filename');
    final path = 'teste222';
    notifyListeners();
    try {
      final task = DownloadTask(
        url: url,
        filename: filename,
        directory: path,
        updates: Updates.statusAndProgress,
        retries: 5,
        metaData: 'data for me',
      );

      final TaskStatusUpdate result = await FileDownloader().download(
        task,
        onProgress: (value) {
          if (!value.isNegative) {
            progress = value;
            notifyListeners();
          }
        },
      );
      print(
          'END ${result.status} ${task.directory} ${task.baseDirectory.name}');
      openFile(filename, path);
      //OPEN FILE
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> openFile(String filename, String path) async {
    try {
      // Obter o diretório de downloads
      final downloadsDirectory = await getApplicationDocumentsDirectory();

      String filePath =
          '${downloadsDirectory.absolute.path}/teste222/$filename';

      print('downloadsDirectory: $filePath');

      bool existe = await File(filePath).exists();
      final now = DateTime.now();
      final duration = now.difference(startTime!);
      if (existe) {
        files.add(
          FileModel(
            path: filePath,
            filename: filename,
            url: url,
            duration: duration,
          ),
        );
        notifyListeners();
        print('O arquivo foi encontrado.');
        await Permission.storage.request();
        await Permission.manageExternalStorage.request();
        final result = await OpenFile.open(filePath);
        print('O arquivo foi aberto: ${result.message}');
      } else {
        print('O arquivo não foi encontrado.');
      }
    } catch (e) {
      print('Erro ao abrir o arquivo: $e');
    }
  }
}
