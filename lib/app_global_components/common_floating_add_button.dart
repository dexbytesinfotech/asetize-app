import '../core/util/app_theme/text_style.dart';
import '../imports.dart';

class CommonFloatingAddButton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final void Function() onPressed;
  const CommonFloatingAddButton({super.key,this.padding, this.backgroundColor, this.foregroundColor, required this.onPressed, });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
            padding: padding ??  const EdgeInsets.only(bottom: 25, right: 20),
            child: FloatingActionButton(
                backgroundColor: backgroundColor ?? AppColors.textBlueColor,
                foregroundColor: foregroundColor ?? AppColors.white,
                onPressed: onPressed,
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
            ))
      ],
    );
  }
}







class CommonCenterBarcodeScannerButton extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback onPressed;

  const CommonCenterBarcodeScannerButton({
    super.key,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    required this.onPressed,
  });

  @override
  State<CommonCenterBarcodeScannerButton> createState() =>
      _CommonCenterBarcodeScannerButtonState();
}

class _CommonCenterBarcodeScannerButtonState
    extends State<CommonCenterBarcodeScannerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = widget.backgroundColor ?? AppColors.textBlueColor; // Replace with AppColors.textBlueColor
    final Color fgColor = widget.foregroundColor ?? Colors.white;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.only(bottom: 24),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    widget.onPressed();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor,
                    foregroundColor: fgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    elevation: 0,

                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/barcode-scan-icon.svg',
                        width: 24,
                        height: 24,
                        color: fgColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Scan Tag",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


