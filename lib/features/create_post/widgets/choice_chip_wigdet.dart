import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../presentation/widgets/image_loader.dart';

class ChoiceChipWidget extends StatefulWidget {
  final List<String> dataList;
  final Color? backgroundColor;
  final Color? selectedColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? labelPadding;
  final Function(dynamic)? tagClickCallBack;
  final Function(dynamic)? onClickDelete;
  final TextStyle? labelTextStyle;
  final bool isShowCrossButton;

  const ChoiceChipWidget({
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
  State<ChoiceChipWidget> createState() => _BookAppointmentTimeListState();
}

class _BookAppointmentTimeListState extends State<ChoiceChipWidget> {
  String selectedChoice = "";
  double elevation = 0;
  double pressElevation = 0;

  _buildChoiceList() {
    double width = MediaQuery.of(context).size.width - 60;
    double size = width / 3;

    List<Widget> choices = [];
    int count = -1;
    for (var item in widget.dataList) {
      final itemIndex = count + 1;
      choices.add(Container(
          padding: EdgeInsets.zero,
          height: size,
          width: size,
          margin: const EdgeInsets.only(right: 2),
          child: Stack(
            children: [
              ChoiceChip(
                showCheckmark: false,
                labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                elevation: 0,
                pressElevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                side: const BorderSide(width: 1, color: Colors.grey),
                backgroundColor: widget.backgroundColor ?? Colors.transparent,
                selectedColor: widget.selectedColor ?? Colors.transparent,
                disabledColor: Colors.transparent,
                selected: selectedChoice == item,
                onSelected: (selected) {
                  setState(() {
                    selectedChoice = item;
                    Map<int, dynamic> value = {itemIndex: item};
                    widget.tagClickCallBack?.call(selectedChoice);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => FullPhotoView(
                    //       title: '',
                    //       profileImgUrl: selectedChoice,
                    //     )));
                  });
                },
                label: item.contains("http") || item.contains('https')
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => const ImageLoader(),
                          imageUrl: item,
                          fit: BoxFit.cover,
                        ))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image(
                            image: FileImage(File(item)),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://st2.depositphotos.com/4202565/7675/v/450/depositphotos_76756387-stock-illustration-video-player-with-black.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),

                // ClipRRect(
                //         borderRadius: BorderRadius.circular(10),
                //         child: Container(
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(10),
                //               image: DecorationImage(
                //                 image: FileImage(File(item)),
                //                 fit: BoxFit.cover,
                //               )),
                //         ),
                //       )
              ),
              widget.isShowCrossButton
                  ? Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          widget.onClickDelete?.call(item);
                        },
                        child: const Icon(Icons.cancel,
                            color: Colors.red, size: 20),
                      ),
                    )
                  : const SizedBox()
            ],
          )));
    }
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
