import 'package:flutter/material.dart';

class SilverAppBarWidget extends StatelessWidget {
  final double collapsedHeight;
  final Widget title;
  final bool isShowTrailingIcon;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? margin;
  final onPressTrailingButton;
  final onPressBackButton;
  final Widget? leading;

  const SilverAppBarWidget({
    Key? key,
    this.collapsedHeight = 55,
    this.textStyle,
    this.margin,
    required this.title,
    this.isShowTrailingIcon = false,
    this.onPressTrailingButton,
    this.onPressBackButton,
    this.leading,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0.1,
      leading: leading,
      // actions: [ isShowTrailingIcon? GestureDetector(
      //   onTap: (){
      //     this.onPressTrailingButton?.call();
      //   },
      //   child: Container(
      //     padding: EdgeInsets.all(0).copyWith(left: 6,right: 6),
      //     margin: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
      //     child: Icon(Icons.add,color: Colors.white,size: 24,),
      //     decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(8.0),
      //         color: Color(0xFF000000) //appColors.buttonColor2
      //     ),
      //   ),
      // ):Container()
      // ],
      leadingWidth: 60,
      toolbarHeight: 50,
      titleSpacing: 0,
      centerTitle: true,
      title: title,
      backgroundColor: Colors.white,
      pinned: true,
      floating: false,
      expandedHeight: 55, // MediaQuery.of(context).size.height /2.1,  //2.47,
      collapsedHeight: collapsedHeight, //MediaQuery.of(context).size.height/8,
    );
  }
}
