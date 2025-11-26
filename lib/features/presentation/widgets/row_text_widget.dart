import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RowTextWidget extends StatelessWidget {
  final String? leftText;
  final String? rightText;
  final bool isShowIcon;
  final BuildContext? context;
  final VoidCallback? onPhoneTap;
  final VoidCallback? onWhatsAppTap;
  final VoidCallback? onCopyTap;
  final void Function(BuildContext context)? onAddContactTap; // Change type to accept context

  const RowTextWidget({
    Key? key,
    this.leftText,
    this.rightText,
    this.isShowIcon = false,
    this.onPhoneTap,
    this.onWhatsAppTap,
    this.onCopyTap,
    this.onAddContactTap, this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: Colors.grey.shade300,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (isShowIcon)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onPhoneTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.blue),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.phone,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: onWhatsAppTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.green),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                      ),

                      // const SizedBox(width: 15),
                      // GestureDetector(
                      //   onTap: () => onAddContactTap?.call(context), // Pass context here
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      //     decoration: BoxDecoration(
                      //       border: Border.all(width: 1, color: Colors.orange),
                      //       borderRadius: BorderRadius.circular(6),
                      //     ),
                      //     child: const Icon(
                      //       Icons.person_add,
                      //       color: Colors.orange,
                      //       size: 20,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: onCopyTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.blue),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.share,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}