import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:asetize/core/util/api_constant.dart';
import 'package:asetize/imports.dart';

class CircularImage extends StatefulWidget {
  final double height;
  final double width;
  final String? image;
  final String? name;
  final Color? bgColor;
  final bool isClickToFullView;
  final VoidCallback? imageClickCallBack;
  const CircularImage(
      {Key? key,
      this.height = 40,
      this.width = 40,
      this.image,
      this.name,
      this.isClickToFullView = true,
      this.imageClickCallBack,
      this.bgColor})
      : super(key: key);

  @override
  _CircularImageState createState() => _CircularImageState();
}

class _CircularImageState extends State<CircularImage> {
  List<String> inputValueList = [];
  String inputValue = "";
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    return super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    circularImageOrNameViewLocal(
        {String? name, double height = 50, double width = 50}) {
      var firstAndLastLetter = projectUtil.getFirstLetterFromName(name!);

      return firstAndLastLetter != null
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.bgColor ?? AppColors.buttonBgColor),
                height: height,
                width: width,
                child: Center(
                  child: Text(
                      //count == 1 ? '1' : "+$count",
                      firstAndLastLetter ?? "",
                      style: TextStyle(
                          fontFamily: appFonts.defaultFont,
                          fontSize: AppDimens().fontSize(value: 14),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2.0,
                          color: AppColors.white)),
                ),
              ),
            )
          : Container();
    }

    circularImageOrNameView(
        double height, double width, String image, String name) {
      try {
        projectUtil.printP(image);
        name = projectUtil.getDecodedValue(name);
      } catch (e) {
        debugPrint("$e");
      }
      if (image.trim() != "") {
        return Center(
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.iconColor),
                height: height,
                width: width,
                child: Stack(
                  children: <Widget>[
                    (image.trim().isNotEmpty)
                        ? ((image.contains('http') || image.contains('https'))
                            ? Align(
                                alignment: Alignment.center,
                                child: (image.contains(
                                        '.gif') /*|| image.contains('assets-yammer')*/)
                                    ? circularImageOrNameViewLocal(
                                        name: name,
                                        height: height,
                                        width: width)
                                    : CachedNetworkImage(
                                        height: height,
                                        width: width,
                                        imageUrl: image,
                                        imageBuilder: (context,
                                                imageProvider) =>
                                            InkWell(
                                              onTap: () {
                                                if (widget.isClickToFullView &&
                                                    image.trim().isNotEmpty) {
                                                  showPhoto(image);
                                                } else {
                                                  widget.imageClickCallBack
                                                      ?.call();
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.transparent,
                                                  //borderRadius: BorderRadius.all(Radius.circular(height / 2)),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                SizedBox(
                                                  child: Center(
                                                    child: SizedBox(
                                                      height: height / 2,
                                                      width: width / 2,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 1.5,
                                                        value: downloadProgress
                                                            .progress,
                                                        valueColor:
                                                            const AlwaysStoppedAnimation<
                                                                    Color>(
                                                                AppColors
                                                                    .loaderColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        errorWidget: (context, url, error) =>
                                            circularImageOrNameViewLocal(
                                                name: name,
                                                height: height,
                                                width: width)
                                ),
                              )
                            : image.contains('assets')
                                ? CircleAvatar(
                                    radius: height / 2,
                                    backgroundImage: /*image.contains('http')?Image.network(image)*/
                                        AssetImage(image),
                                  )
                                : CircleAvatar(
                                    radius: height / 2,
                                    backgroundImage: /*image.contains('http')?Image.network(image)*/
                                        FileImage(File(image)),
                                  ))
                        : CircleAvatar(
                            radius: height / 2,
                            backgroundImage:
                                const NetworkImage(ConstantC.imageNotFoundC),
                          )
                  ],
                )));
      } else {
        return circularImageOrNameViewLocal(
            name: name, height: height, width: width);
      }
    }

    //Main view
    return Container(
        child: circularImageOrNameView(widget.height, widget.width,
            widget.image ?? "", widget.name ?? ""));
  }

  void showPhoto(String image) {
    Navigator.push(
      MainAppBloc.getDashboardContext,
      FadeRoute(
          widget: FullPhotoView(
        title: widget.name,
        profileImgUrl: image,
      )),
    );
  }
}
