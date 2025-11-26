import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_string.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../account_books/bloc/account_book_bloc.dart';
import '../../presentation/widgets/workplace_widgets.dart';

class ImageViewPage extends StatefulWidget {
  final String imageUrl;
  final String? title;
  final String? subTitle;
  final bool isSet;
  final bool fromFilePicker;
  final void Function(String imageUrl)? onUploadCallback;


  const ImageViewPage({
    super.key,
    required this.imageUrl,
    this.title,
    this.isSet=false,
    this.subTitle,
    this.onUploadCallback,
    this.fromFilePicker = false,
  });

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  late AccountBookBloc accountBloc;

  bool get isNetworkUrl => widget.imageUrl.startsWith('http://') || widget.imageUrl.startsWith('https://');

  /// Function to Save File (handles both local and network)
  Future<String?> saveFile(BuildContext context, String filePath, String fileName) async {
    try {
      File? sourceFile;
      Directory? directory;

      if (isNetworkUrl) {
        final response = await http.get(Uri.parse(filePath));
        if (response.statusCode != 200) {

          WorkplaceWidgets.successToast( "Failed to download image");
          return null;
        }
        final tempDir = await getTemporaryDirectory();
        sourceFile = File('${tempDir.path}/$fileName');
        await sourceFile.writeAsBytes(response.bodyBytes);
      } else {
        sourceFile = File(filePath);
        if (!await sourceFile.exists()) {
          WorkplaceWidgets.successToast( "Source file does not exist");
          return null;
        }
      }

      if (Platform.isAndroid) {
        if (await Permission.storage.request().isGranted) {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
        } else {
          WorkplaceWidgets.successToast( "Storage permission denied");
          return null;
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      String newPath = "${directory!.path}/$fileName";
      File newFile = await sourceFile.copy(newPath);

      WorkplaceWidgets.successToast( "Image Saved Successfully!\nPath: $newPath");
      return newPath;
    } catch (e) {
      WorkplaceWidgets.successToast( "Error: $e");
      return null;
    }
  }

  /// Function to Share File
  Future<void> shareFile(BuildContext context, String filePath) async {
    try {
      File file;
      if (isNetworkUrl) {
        final response = await http.get(Uri.parse(filePath));
        if (response.statusCode != 200) {
          throw Exception('Failed to download image: ${response.statusCode}');
        }
        final tempDir = await getTemporaryDirectory();
        final String tempPath = path.join(tempDir.path, path.basename(filePath));
        file = File(tempPath);
        await file.writeAsBytes(response.bodyBytes);
      } else {
        file = File(filePath);
        if (!await file.exists()) {
          throw Exception('File does not exist');
        }
      }

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {

      WorkplaceWidgets.errorSnackBar(context, 'Error: $e');

    }
  }

  /// Function to handle Upload action
  // void onUpload() {
  //   Navigator.pop(context, widget.imageUrl);
  // }
  void onUpload() {
    if (widget.onUploadCallback != null) {
      widget.onUploadCallback!(widget.imageUrl); // ✅ Trigger callback
    }
    Navigator.pop(context, widget.imageUrl); // Keep if you still want to pop
  }
  /// Function to handle Cancel action
  void onCancel() {
    Navigator.pop(context);
  }

  @override
  void initState() {

    accountBloc = BlocProvider.of<AccountBookBloc>(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print('ImageViewPage: Loading image from ${widget.imageUrl}');
    return Scaffold(
      backgroundColor: Color(0xFFf9fafb),
        appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        titleSpacing: 0,
        title: widget.fromFilePicker ?   SizedBox():Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              widget.subTitle ?? '',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        leading: widget.fromFilePicker ? Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black, size: 28),
            onPressed: onCancel,
          ),
        ):IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: widget.fromFilePicker
            ? [
          InkWell(
                  onTap: (){
                    onUpload();
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    decoration: BoxDecoration(
                        color:  AppColors.appBlueColor,

                        border: Border.all(
                            color :AppColors.appBlueColor,

                            width: 0.1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(widget.isSet?AppString.set:AppString.upload,
                        style:  appTextStyle.appNormalTextStyle(
                            color: AppColors.white

                        )),
                  ),
                ),
          const SizedBox(width: 20,)

        ]
            : [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.black, size: 24),
            onPressed: () => saveFile(context, widget.imageUrl, path.basename(widget.imageUrl)),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black, size: 24),
            onPressed: () => shareFile(context, widget.imageUrl),
          ),
          const SizedBox(width: 8),
        ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0), // Height of the divider
            child: Divider(
              height: 0,
              thickness: 0.4,
              color: Colors.grey[300], // Customize the divider color as needed
            ),
          ),
        ),
      body: widget.imageUrl.isNotEmpty
          ? Center(
        child: isNetworkUrl
            ? Image.network(
          widget.imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            print('Image.network error: $error');
            return const Text(
              'Unable to load image',
              style: TextStyle(fontSize: 16, color: Colors.red),
            );
          },
        )
            : Image.file(
          File(widget.imageUrl),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('Image.file error: $error');
            return const Text(
              'Unable to load image',
              style: TextStyle(fontSize: 16, color: Colors.red),
            );
          },
        ),
      )
          : const Center(
        child: Text(
          'Unable to open image file',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ),
    );
  }
}