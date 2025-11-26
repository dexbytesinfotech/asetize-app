import 'package:cached_network_image/cached_network_image.dart';
import '../../../../imports.dart';

class PostProfile extends StatefulWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  const PostProfile(
      {Key? key,
      this.imageUrl,
      this.padding,
      this.height,
      this.width,
      this.borderColor})
      : super(key: key);

  @override
  State<PostProfile> createState() => _PostProfileState();
}

class _PostProfileState extends State<PostProfile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          border:
              Border.all(color: widget.borderColor ?? Colors.grey, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            placeholder: (context, url) => const ImageLoader(),
            errorWidget: (context, url, error) => SizedBox(
              height: widget.height ?? 37,
              width: widget.width ?? 37,
              child: Image.asset(
                "assets/images/profile_avatar.png",
                height: widget.height ?? 37,
                width: widget.width ?? 37,
                fit: BoxFit.cover,
              ),
            ),
            imageUrl: widget.imageUrl ??
                'https://www.dexbytes.com/images/dexbytesogimage.png',
            height: widget.height ?? 37,
            width: widget.width ?? 37,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
