import 'package:asetize/imports.dart';
import '../../../core/util/app_theme/text_style.dart';
import 'dart:io';

class FullPhotoView extends StatelessWidget {
  final String? profileImgUrl;        // For network image
  final String? localProfileImgUrl;   // For local image
  final String? title;
  final bool? comeFromTransactionPage;

  const FullPhotoView({
    Key? key,
    this.profileImgUrl,
    this.localProfileImgUrl,
    this.title,
    this.comeFromTransactionPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: -5,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF5F5F5),
        title: Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Colors.black,
                  )),
              const SizedBox(width: 18),
              Flexible(
                child: Text(
                  title ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: appTextStyle.appBarTitleStyle(),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: (localProfileImgUrl != null && File(localProfileImgUrl!).existsSync())
            ? PhotoView(
          imageProvider: FileImage(File(localProfileImgUrl!)),
          backgroundDecoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
          ),
          maxScale: PhotoViewComputedScale.covered * 1.8,
          minScale: PhotoViewComputedScale.contained * 1,
        )
            : PhotoView(
          errorBuilder: (context, error, stackTrace) {
            return comeFromTransactionPage == true
                ? Container(
              color: const Color(0xFFF5F5F5),
              child: const Center(
                child: Text(
                  AppString.couldNotLoad,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            )
                : Image.asset(
              "assets/images/profile_avatar.png",
              fit: BoxFit.contain,
            );
          },
          imageProvider: NetworkImage(
            profileImgUrl ??
                "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F37%2F2020%2F11%2F25%2FHow-much-to-tip-at-salon.jpg",
          ),
          backgroundDecoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
          ),
          maxScale: PhotoViewComputedScale.covered * 1.8,
          minScale: PhotoViewComputedScale.contained * 1,
        ),
      ),
    );
  }
}
