import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class PanduanTerapiPage extends StatefulWidget {
  const PanduanTerapiPage({super.key});

  @override
  State<PanduanTerapiPage> createState() => _PanduanTerapiPageState();
}

class _PanduanTerapiPageState extends State<PanduanTerapiPage> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _preparePdf();
  }

  Future<void> _preparePdf() async {
    final ByteData bytes = await rootBundle.load('assets/ebook/Website-Pedoman-Petunjuk-Praktis-Terapi-Insulin-Pada-Pasien-Diabetes-Melitus-Ebook.pdf');
    final Uint8List list = bytes.buffer.asUint8List();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Website-Pedoman-Petunjuk-Praktis-Terapi-Insulin-Pada-Pasien-Diabetes-Melitus-Ebook.pdf');

    await file.writeAsBytes(list);
    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panduan Terapi DM')),
      body: localPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menampilkan PDF: $error')),
                );
              },
            ),
    );
  }
}
