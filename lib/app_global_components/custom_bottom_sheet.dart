import '../imports.dart';

class CustomBottomSheet extends StatelessWidget {
  final Function(BuildContext context)? onCancelClick;
  final Function(BuildContext context)? onOkClick;
  final String? okTitle;
  final String? cancelTitle;
  final Widget child;
  const CustomBottomSheet({super.key,required this.child,this.onOkClick,this.onCancelClick,this.cancelTitle = "Cancel",this.okTitle = "Set"});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const  EdgeInsets.only(left: 10,right: 10,bottom: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                onCancelClick==null?const SizedBox():GestureDetector(
                  onTap: () =>  onOkClick?.call(context),
                  child: Text(
                    "$cancelTitle",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appBlueColor,
                    ),
                  ),
                ),
                onOkClick==null?const SizedBox():GestureDetector(
                  onTap: () {
                    onOkClick?.call(context);
                  },
                  child:  Text(
    "$okTitle",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appBlueColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0,thickness: 0,),
          const SizedBox(height: 6,),
          ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 240/*genderOptions.length * 60.0 > 240
                    ? 240
                    : genderOptions.length * 60.0*/,
              ),
              child: child
          ),
        ],
      ),
    );
  }
}
