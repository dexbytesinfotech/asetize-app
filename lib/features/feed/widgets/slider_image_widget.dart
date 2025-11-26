import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:asetize/features/feed/widgets/video_player_widget.dart';

import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';

class SliderScreen extends StatefulWidget {
  final String? postBy;
  final double imageHeight;
  final double? imageWidth;
  final int activeIndex;
  final int initialPage;
  final bool enlargeCenterPage;
  final bool autoPlay;
  final bool enableInfiniteScroll;
  final double viewportFraction;
  final bool isDotVisible;
  final bool dotBackgroundVisible;
  final Color activeDotColor;
  final Color? inActiveDotColor;
  final Color? dotBackgroundColor;
  final double dotHeight;
  final double dotWidth;
  final bool isDotOverlay;

  final Function(dynamic)? imageClickCallBack;
  final double borderRadius;
  final double backgroundWidth;
  final double backgroundHeight;
  final int? itemCount;
  final List<String>? viewType;
  final List<String> urlImages;

  const SliderScreen({
    Key? key,
    this.postBy,
    this.imageHeight = 200,
    this.activeIndex = 0,
    this.initialPage = 0,
    this.enlargeCenterPage = false,
    this.enableInfiniteScroll = false,
    this.autoPlay = false,
    this.viewportFraction = 1,
    this.isDotVisible = false,
    this.dotBackgroundVisible = false,
    this.activeDotColor = const Color(0xFF022964),
    this.inActiveDotColor,
    this.viewType,
    this.dotHeight = 6,
    this.itemCount,
    this.dotWidth = 6,
    this.isDotOverlay = false,
    this.urlImages = const [],
    this.imageClickCallBack,
    this.dotBackgroundColor,
    this.borderRadius = 20,
    this.backgroundWidth = 90,
    this.backgroundHeight = 15,
    this.imageWidth,
  }) : super(key: key);

  @override
  State<SliderScreen> createState() => _SliderScreenState(urlImages, viewType);
}

class _SliderScreenState extends State<SliderScreen> {
  List<String>? viewType;
  List<String> urlImages;
  _SliderScreenState(this.urlImages, this.viewType);


  int activeIndex = 0;
  CarouselSliderController? _carouselController;

  List<Widget> imageSliders = [] ;

  @override
  void didUpdateWidget(covariant SliderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.urlImages != oldWidget.urlImages || widget.viewType != oldWidget.viewType) {
      setState(() {
        urlImages = widget.urlImages;
        viewType = widget.viewType;
        imageSliders = buildImageSliders();
      });
    }
  }

  List<Widget> buildImageSliders() {
    int index = 0;
    return urlImages.map((item) {
      final urlImage = urlImages[index];
      final type = viewType?[index];
      index++;
      return buildImage(urlImage, type!, index);
    }).toList();
  }


  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carouselController!.jumpToPage(0);

     setState(() {
       int index = 0;
       imageSliders = urlImages
           .map((item) {
         final urlImage = urlImages[index];
         final type = viewType?[index];
         index++;
         return buildImage(urlImage, type!, index);
       }).toList();
     });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      bottom: !widget.isDotVisible
                          ? 0
                          : (widget.isDotOverlay ? 0 : 20)),
                  child:
                  CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                          height: widget.imageHeight,
                          enlargeCenterPage: widget.enlargeCenterPage,
                          autoPlay: widget.autoPlay,
                          // aspectRatio: 16/9,
                          autoPlayAnimationDuration:
                          const Duration(milliseconds: 1000),
                          viewportFraction: widget.viewportFraction,
                          enableInfiniteScroll: widget.enableInfiniteScroll,
                          initialPage: widget.initialPage,
                          onPageChanged: (index, reason) =>
                              setState(() => activeIndex = index),
                    ),
                    items: imageSliders,
                  ),
                /*  CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemBuilder: (BuildContext context, index, realIndex) {
                      final urlImage = urlImages[index];
                      final type = viewType?[index];
                      return buildImage(urlImage, type!, index);
                    },
                    itemCount: widget.itemCount ?? urlImages.length,
                    options: CarouselOptions(
                      height: widget.imageHeight,
                      enlargeCenterPage: widget.enlargeCenterPage,
                      autoPlay: widget.autoPlay,
                      // aspectRatio: 16/9,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 1000),
                      viewportFraction: widget.viewportFraction,
                      enableInfiniteScroll: widget.enableInfiniteScroll,
                      initialPage: widget.initialPage,
                      onPageChanged: (index, reason) =>
                          setState(() => activeIndex = index),
                    ),
                  ),*/
                ),
                if (urlImages.length > 1)
                  Container(
                    margin: const EdgeInsets.only(top: 15, right: 15),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      '${activeIndex + 1}/${urlImages.length}',
                      style: appTextStyle.appNormalSmallTextStyle(color: AppColors.white, fontSize: 12),
                    ),
                  )
              ],
            ),
            Visibility(
              visible: urlImages.length > 1 ? widget.isDotVisible : false,
              child: Container(
                height: widget.backgroundHeight,
                width: widget.backgroundWidth,
                margin: EdgeInsets.symmetric(vertical: widget.isDotOverlay ? 8 : 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    color: widget.dotBackgroundVisible
                        ? widget.dotBackgroundColor ?? const Color(0xffB8BCBF).withOpacity(0.2)
                        : Colors.transparent),
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedSmoothIndicator(
                      activeIndex: activeIndex,
                      count: urlImages.length,
                      effect: ScrollingDotsEffect(
                        dotHeight: widget.dotHeight,
                        dotWidth: widget.dotWidth,
                        activeDotColor: widget.activeDotColor,
                        dotColor: widget.inActiveDotColor ?? Colors.grey.shade400,
                      )
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }


  Widget buildImage(String urlImage, String type, int index) => InkWell(
      onTap: () {
        // widget.imageClickCallBack?.call(index);
        try {
          Navigator.push(
            MainAppBloc.getDashboardContext ?? context,
            FadeRoute(widget: FullPhotoView(
              title: widget.postBy,
              profileImgUrl: urlImage,
            )),
          );
        } catch (e) {
          debugPrint('$e');
        }
        //print('$index');
      },
      child: imageVideoView(urlImage, type));



  Widget imageVideoView(String urlImage, String type) {
    if (type.toLowerCase() == "video") {
      return VideoPlayerWidget(
        key: ValueKey(urlImage), // Ensures a new widget is created on URL change
        videoUrl: urlImage,
      );
    } else {
      return PinchZoomReleaseUnzoomWidget(
        child: CachedNetworkImage(
          placeholder: (context, url) => const ImageLoader(),
          imageUrl: urlImage,
          fit: BoxFit.cover,
          cacheKey: urlImage,
          width: widget.imageWidth ?? MediaQuery.of(context).size.width,
          errorWidget: (BuildContext context, String url, Object error) {
            return Container(
              color: Colors.grey.shade50,
              child:  Center(
                child: Text(
                  AppString.couldNotLoad,
                  style: appTextStyle.appNormalSmallTextStyle(),
                ),
              ),
            );
          },
        ),
      );
    }
  }




}
