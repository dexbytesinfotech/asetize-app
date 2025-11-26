import '../../../imports.dart';

class TransactionReceiptScreen extends StatefulWidget {
  const TransactionReceiptScreen({super.key});

  @override
  State<TransactionReceiptScreen> createState() => _TransactionReceiptScreenState();
}

class _TransactionReceiptScreenState extends State<TransactionReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    return  ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: true,
        isFixedDeviceHeight: true,
        isListScrollingNeed: false,
        isOverLayStatusBar: false,
        appBarHeight: 56,
        appBar: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 5.0,bottom: 0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        width: 0.3,
                        color: Colors.grey.shade300,
                      ))),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     IconButton(
              //       splashRadius: 23,
              //       onPressed: () {
              //         Navigator.pop(context, true);
              //       },
              //       icon: const Icon(
              //         Icons.arrow_back_ios_new,
              //         color: Colors.black,
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 12,
              //     ),
              //     Expanded(
              //       child: Container(
              //         color: Colors.transparent,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               widget.description,
              //               textAlign: TextAlign.start,
              //               overflow: TextOverflow.ellipsis,
              //               maxLines: 1,
              //               style: const TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 16,
              //                 fontFamily: "Roboto",
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //             Text(
              //               widget.date,
              //               textAlign: TextAlign.start,
              //               overflow: TextOverflow.ellipsis,
              //               style: const TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 14,
              //                 fontFamily: "Roboto",
              //                 fontWeight: FontWeight.w400,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 15,),
              //
              //   ],
              // ),
            ),
          ),
        ),
        containChild: Column(
    children: [],
    ));
  }
}
