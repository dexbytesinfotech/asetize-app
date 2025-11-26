import 'package:cached_network_image/cached_network_image.dart';
import 'package:asetize/widgets/common_card_view.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../my_unit/bloc/my_unit_bloc.dart';

class TransactionReceiptList extends StatefulWidget {
  final String unitNumber;
  final String paymentMethod;
  final String amount;
  final String? accountComments;
  final String imagePath;
  final String createdAt;
  final String description;
  final double imageHeight;
  final String status;
  final String duplicateEntryMessage;
  final bool isDuplicateEntry;
  final void Function()? onLongPress;
  final void Function()? onTab
  ;
  final Color cardColor;

  const TransactionReceiptList({
    Key? key,
    required this.unitNumber,
    required this.paymentMethod,
    required this.amount,
    required this.imagePath,
    required this.createdAt,
    required this.description,
    this.accountComments = '',
    required this.imageHeight,
    this.onLongPress,this.onTab,
    this.cardColor = Colors.white,
    required this.duplicateEntryMessage,required this.isDuplicateEntry,

    required this.status

  }) : super(key: key);

  @override
  State<TransactionReceiptList> createState() => _TransactionReceiptListState();
}

class _TransactionReceiptListState extends State<TransactionReceiptList> {
  late MyUnitBloc myUnitBloc;
  late UserProfileBloc userProfileBloc;

  @override
  void initState() {
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Color statusColor({required String status}) {
      switch (status.toLowerCase()) {
        case "rejected":
          return Colors.red.shade300;
        case "awaiting approval":
          return Colors.orange.shade100;
        case "approved":
          return Colors.green.shade300;
        default:
          return Colors.grey.shade50;
      }
    }

    Color statusTextColor({required String status}) {
      switch (status.toLowerCase()) {
        case "rejected":
          return Colors.white.withOpacity(0.9);
          ; // Contrast with red
        case "awaiting approval":
          return Colors.black; // Contrast with yellow
        case "approved":
          return Colors.white.withOpacity(0.9); // Contrast with green
        default:
          return Colors.black; // Default text color
      }
    }
    return Stack(
      children: [
        const SizedBox(height: 15),
        // Details Container
        InkWell(
          onLongPress: widget.onLongPress,
          onTap: widget.onTab ?? () {
            Navigator.of(context).push(FadeRoute(
              widget:  FullPhotoView(
                comeFromTransactionPage : true,
                title: widget.unitNumber,
                profileImgUrl: widget.imagePath,
              ),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: CommonCardView(
              cardColor: widget.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description (conditionally rendered)
                    // Image Container
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Set your desired border color here
                          width: 0.5, // Set the width of the border
                        ),
                        borderRadius: BorderRadius.circular(8), // Set the border radius to match ClipRRect
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => const ImageLoader(),
                          imageUrl: widget.imagePath,
                          fit: BoxFit.cover,
                          height: widget.imageHeight,
                          width: double.infinity,
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade50,
                            child: const Center(
                              child: Text(
                                'Could not load',
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    // Details Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.description.isNotEmpty)
                          Text(
                            widget.description,
                            style:  appTextStyle.appSubTitleValueStyle(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (userProfileBloc.user.houses!.length > 1)
                                _buildDetailRow(Icons.apartment, 'Unit Number:', widget.unitNumber)
                              else if (AppPermission.instance.canPermission(AppString.accountPaymentAdd, context: context))
                                _buildDetailRow(Icons.apartment, 'Unit Number:', widget.unitNumber),
                            ],
                          ),
                          // _buildDetailRow(Icons.payment, 'Payment Method:', paymentMethod),
                          userProfileBloc.user.houses!.length > 1
                              ? const SizedBox(height: 0) // Widget when condition is true
                              : const SizedBox(height: 2), // Widget when condition is false

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Text(widget.amount,style:  appTextStyle.appTitleStyle(),),
                              ),

                              Container(
                                margin: const EdgeInsets.only(left: 5, right: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: statusColor(
                                      status: widget.status ?? ''),
                                ),
                                child: Row(
                                  children: [
                                    if (widget.status.toLowerCase() == 'awaiting approval')
                                      const Icon(
                                        Icons.access_time, // Clock icon
                                        color: Colors.black, // Adjust color as needed
                                        size: 16, // Adjust size as needed
                                      ),
                                    const SizedBox(width: 4), // Space between icon and text
                                    Text(
                                      '${widget.status}',
                                      style: appTextStyle.appSubTitleStyle(
                                        color: statusTextColor(status: widget.status ?? ''),
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ],
                          ),



                          if (widget.accountComments!.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "${AppString.reasonWithSemiColone ?? ''} ", // Ensure space after semicolon
                                              style: appTextStyle.appSubTitleStyle(fontSize: 15),
                                            ),
                                            TextSpan(
                                              text: widget.accountComments ?? '',
                                              style: appTextStyle.appSubTitleValueStyle(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )


                          // _buildDetailRow(Icons.money, 'Amount:', amount),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        widget.isDuplicateEntry?
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.11, // 10% from the bottom
          left: MediaQuery.of(context).size.width * 0.1,  // 10% from the left
          right: MediaQuery.of(context).size.width * 0.1, // 10% from the right
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.7), // Semi-transparent red
              borderRadius: BorderRadius.circular(5),
            ),
            child:  Text(
              widget.duplicateEntryMessage,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ): SizedBox()
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textBlueColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: appTextStyle.appSubTitleStyle(),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: appTextStyle.appSubTitleValueStyle(),
        ),
      ],
    );
  }
}
