import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../imports.dart';

class FullPdfViewerPage extends StatelessWidget {
  final File file;

  const FullPdfViewerPage({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Opening PDF: ${file.path}");
    if (!file.existsSync()) {
      return Scaffold(
        appBar: AppBar(title: const Text("PDF Viewer")),
        body: const Center(child: Text("Error: PDF file not found")),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.pdfViewer)),
      body: SfPdfViewer.file(
        file,
        onDocumentLoadFailed: (details) {
          WorkplaceWidgets.errorSnackBar(context,"Failed to load PDF: ${details.description}");
        },
      ),
    );
  }
}