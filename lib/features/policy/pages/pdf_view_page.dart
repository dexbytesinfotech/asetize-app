import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as path;

import '../../../core/util/app_theme/text_style.dart';
import '../../presentation/widgets/workplace_widgets.dart';

class PdfViewPage extends StatefulWidget {
  final String pdfUrl;
  final String? title;
  final String? subTitle;
  final String? type;

  const PdfViewPage({super.key, required this.pdfUrl, this.title, this.subTitle, this.type});

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  /// Function to Download and Save PDF
  Future<void> downloadPDF(BuildContext context, String pdfUrl) async {
    try {
      var response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        Directory? directory;

        if (Platform.isAndroid) {
          if (await Permission.storage.request().isGranted) {
            directory = Directory('/storage/emulated/0/Download'); // Android Download Folder
            if (!await directory.exists()) {
              await directory.create(recursive: true);
            }
          } else {
            WorkplaceWidgets.successToast("Storage permission denied");
            return;
          }
        } else if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
        }

        String filePath = "${directory!.path}/downloaded_file.pdf";
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        WorkplaceWidgets.successToast( "PDF Downloaded Successfully!\nPath: $filePath");
      } else {
        WorkplaceWidgets.successToast("Failed to download PDF");
      }
    } catch (e) {
      WorkplaceWidgets.successToast("Error: $e");
    }
  }

  /// Function to Download and Share Image
  Future<void> downloadAndShareImage(BuildContext mContext, List<String> list) async {
    try {
      if (list.isNotEmpty) {
        final List<XFile> xFiles = [];
        final tempDir = await getTemporaryDirectory();
        for (String imageUrl in list) {
          final String fileName = path.basename(imageUrl);
          final String filePath = path.join(tempDir.path, fileName);
          final File file = File(filePath);

          if (await file.exists()) {
            xFiles.add(XFile(filePath));
          } else {
            final response = await http.get(Uri.parse(imageUrl));
            if (response.statusCode == 200) {
              await file.writeAsBytes(response.bodyBytes);
              xFiles.add(XFile(filePath));
            } else {
              throw Exception('Failed to download image: ${response.statusCode}');
            }
          }
        }
        await Share.shareXFiles(xFiles);
      }
    } catch (e) {
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? '',
              style:  appTextStyle.appBarTitleStyle(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.black, size: 24),
            onPressed: () => downloadPDF(context, widget.pdfUrl),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black, size: 24),
            onPressed: () => downloadAndShareImage(context, [widget.pdfUrl]),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: widget.pdfUrl.isNotEmpty
          ? SfPdfViewer.network(
        widget.pdfUrl,
        controller: _pdfViewerController,
      )
          : Center(
        child: Text(
          'Unable to open PDF file',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ),
    );
  }
}
