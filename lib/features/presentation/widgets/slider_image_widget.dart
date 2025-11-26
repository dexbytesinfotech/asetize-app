import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:asetize/imports.dart';

import '../../feed/widgets/video_player_widget.dart';

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
    this.urlImages = const [
      "https://www.marketing91.com/wp-content/uploads/2019/05/Features-of-advertising-1.jpg",
      "https://landerapp.com/blog/wp-content/uploads/2018/06/advertising-agency.jpg",
    ],
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
  late CarouselSliderController _carouselController;
  @override
  void didUpdateWidget(covariant SliderScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      urlImages = widget.urlImages;
      viewType = widget.viewType;
    });
  }

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carouselController.animateToPage(0);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    Widget imageVideoView(String urlImage, String type) {
      if (type.toLowerCase() == "video") {
        return VideoPlayerWidget(
          key: ValueKey(urlImage),
          videoUrl: urlImage,
        );
      } else {
        return PinchZoomReleaseUnzoomWidget(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: CachedNetworkImage(
                placeholder: (context, url) => const ImageLoader(),
                imageUrl: urlImage,
                fit: BoxFit.cover,
                width: widget.imageWidth ?? MediaQuery.of(context).size.width,
                errorWidget: (
                  BuildContext context,
                  String url,
                  Object error,
                ) {
                  return Container(
                    color: Colors.grey.shade50,
                    child: const Center(
                        child: Text(
                      'Could not load',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    )),
                  );
                }),
          ),
        );
      }
    }

    Widget buildImage(String urlImage, String type, int index) => InkWell(
        onTap: () {
          widget.imageClickCallBack?.call(index);
          try {
            Navigator.of(context).push(FadeRoute(
                widget:  FullPhotoView(
                    title: widget.postBy, profileImgUrl: urlImage)));
          } catch (e) {
            print(e);
          }
          //print('$index');
        },
        child: imageVideoView(urlImage, type));

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
                  child: CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemBuilder: (BuildContext context, index, realIndex) {
                      final urlImage = urlImages[index];
                      final type = viewType?[index];
                      return buildImage(urlImage, type ?? "", index);
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
                  ),
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
                      style:
                          const TextStyle(color: AppColors.white, fontSize: 12),
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
}
