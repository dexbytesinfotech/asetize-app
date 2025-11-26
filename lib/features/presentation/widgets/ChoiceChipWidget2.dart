import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'image_loader.dart';

class ChoiceChipWidget2 extends StatefulWidget {
  final List<String> dataList;
  final Color? backgroundColor;
  final Color? selectedColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? labelPadding;
  final Function(dynamic)? tagClickCallBack;
  final Function(dynamic)? onClickDelete;
  final TextStyle? labelTextStyle;
  final bool isShowCrossButton;

  const ChoiceChipWidget2({
    Key? key,
    this.dataList = const ["l", "m", "n"],
    this.tagClickCallBack,
    this.onClickDelete,
    this.backgroundColor,
    this.selectedColor,
    this.padding,
    this.labelPadding,
    this.labelTextStyle,
    this.isShowCrossButton = false,
  }) : super(key: key);

  @override
  State<ChoiceChipWidget2> createState() => _BookAppointmentTimeListState();
}

class _BookAppointmentTimeListState extends State<ChoiceChipWidget2> {
  String selectedChoice = "";
  double elevation = 0;
  double pressElevation = 0;

  _buildChoiceList() {
    List<Widget> choices = [];
    int count = -1;
    widget.dataList.forEach((item) {
      final itemIndex = count + 1;
      choices.add(Container(
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(right: 2),
        child: ChoiceChip(
          showCheckmark: false,
          labelPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          elevation: 0,
          pressElevation: 0,
          label: widget.isShowCrossButton
              ? Stack(
                  children: [
                    item.contains("http") || item.contains('https')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                                placeholder: (context, url) => ImageLoader(),
                                imageUrl: item,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorWidget: (
                                  BuildContext context,
                                  String url,
                                  Object error,
                                ) {
                                  return Container(color: Colors.grey);
                                }))
                        : (item.contains(".pdf"))
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => ImageLoader(),
                                  imageUrl:
                                      'https://i.pinimg.com/originals/c3/07/d1/c307d13aac792ea9cb9e1f8162a329b2.png',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ))
                            : (item.contains(".doc"))
                                ? Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                          image: NetworkImage(
                                              'https://storage.googleapis.com/public_394582/plugins/doc_maker/logo.png'),
                                          fit: BoxFit.cover,
                                        )),
                                  )
                                : Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: FileImage(File(item)),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                    widget.isShowCrossButton
                        ? Positioned(
                            right: 1,
                            top: 1,
                            child: Material(
                              color: Colors.cyan,
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    print('Cancllee,........');
                                    setState(() {
                                      widget.onClickDelete?.call(itemIndex);
                                    });
                                  },
                                  icon: const Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 22, left: 22),
                                    child: Icon(Icons.cancel,
                                        color: Colors.red, size: 20),
                                  )),
                            ),
                          )
                        : Container()
                  ],
                )
              : Stack(
                  children: [
                    item.contains("http") || item.contains('https')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => ImageLoader(),
                              imageUrl: item,
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ))
                        : Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(File(item)),
                                  fit: BoxFit.cover,
                                )),
                          ),
                  ],
                ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          selectedColor: widget.selectedColor ?? Colors.transparent,
          disabledColor: Colors.transparent,
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
              Map<int, dynamic> value = {itemIndex: item};
              this.widget.tagClickCallBack?.call(selectedChoice);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 15,
      children: _buildChoiceList(),
    );
  }
}
