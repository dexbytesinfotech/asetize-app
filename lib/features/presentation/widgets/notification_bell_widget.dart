import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_dimens.dart';
import '../../../core/util/workplace_icon.dart';
import '../../../imports.dart';
import '../../notificaion/bloc/notification_bloc/app_notification_bloc.dart';
import '../../notificaion/bloc/notification_bloc/app_notification_event.dart';
import '../../notificaion/bloc/notification_bloc/app_notification_state.dart';

class NotificationBal2 extends StatefulWidget {
  final String? iconData;
  final VoidCallback? onTap;
  final int? notificationCount;
  final double? rightIconSize;
  final double? rightIconBoxSize;
  final double? countTextSize;
  final Color? boxShapeCircleColor;
  final Color? iconDataColor;
  const NotificationBal2({super.key,this.onTap,
    this.iconData,
    this.rightIconSize,
    this.rightIconBoxSize,
    this.iconDataColor,
    this.notificationCount,
    this.countTextSize,
    this.boxShapeCircleColor});

  @override
  State<NotificationBal2> createState() => _NotificationBal2State();
}

class _NotificationBal2State extends State<NotificationBal2> {

  int? notificationCount;
  late AppNotificationBloc appNotificationBloc;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.notificationCount!= null ) {
      notificationCount = widget.notificationCount;
    }
  }

  @override
  void didUpdateWidget(covariant NotificationBal2 oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(widget.notificationCount!=null) {
    setState(() {
      notificationCount = widget.notificationCount;
    });
    }
  }

  @override
  Widget build(BuildContext context) {

    double? rightIconSizeTemp = widget.rightIconBoxSize ?? (widget.rightIconSize ?? 30.0);
    appNotificationBloc = BlocProvider.of<AppNotificationBloc>(context);

    Widget menuIcon = widget.iconData != null
        ? (widget.iconData!.contains(".svg")
        ? SvgPicture.asset(widget.iconData!,
        width: widget.rightIconSize ?? AppDimens().iconSquareCustom(value: 18),
        height: widget.rightIconSize ?? AppDimens().iconSquareCustom(value: 18),
        color: widget.iconDataColor,
        fit: BoxFit.scaleDown)
        : Image(
      image: AssetImage(widget.iconData!),
      width: widget.rightIconSize ?? AppDimens().iconSquareCustom(value: 18),
      height:
      widget.rightIconSize ?? AppDimens().iconSquareCustom(value: 18),
      color: widget.iconDataColor,
    ))
        : Container(
      child: WorkplaceIcons.iconImage(
        imageUrl: WorkplaceIcons.notificationIcon,
        imageColor: AppColors.black,
        iconSize: const Size(25, 25), //imageColor:Colors.white
      ),
    );

    return BlocBuilder<AppNotificationBloc, AppNotificationState>(
      bloc: appNotificationBloc,
      builder: (context, state) {
        if(state is NotificationCountDoneState){
          notificationCount = appNotificationBloc.notificationCount;
        }
        else {
          notificationCount = appNotificationBloc.notificationCount;
        }
        return InkWell(
          onTap: (){
            if(notificationCount!>0){
              appNotificationBloc.add(const MarkNotificationDisplayedEvent());
            }
            widget.onTap?.call();
          },
          child: Container(
            width: rightIconSizeTemp,
            padding: EdgeInsets.zero,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[menuIcon],
                ),
                notificationCount! > 0
                    ? Positioned(
                  top: 0,
                  right: notificationCount! > 9 ? 0 : 5,
                  child: Container(
                    margin: const EdgeInsets.only(top: 2, right: 4),
                    child: Container(
                      //padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.boxShapeCircleColor ?? AppColors.appRed),
                      alignment: Alignment.center,
                      child: Container(
                          margin: const EdgeInsets.all(4),
                          child: Center(
                            child: Text(
                                '${notificationCount! <= 99 ? notificationCount : "99+"}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize:
                                    notificationCount! <= 99 ? 12 : 8,
                                    color: Colors
                                        .white /*,backgroundColor: Colors.red*/
                                )),
                          )),
                    ),
                  ),
                )
                    : Container()
              ],
            ),
          ),
        );
      },
    );;
  }
}


// class NotificationBal2 extends StatelessWidget {
//   final String? iconData;
//   final VoidCallback? onTap;
//   late final int? notificationCount;
//   final double? rightIconSize;
//   final double? rightIconBoxSize;
//   final double? countTextSize;
//   final Color? boxShapeCircleColor;
//   final Color? iconDataColor;
//   const NotificationBal2(
//       {Key? key,
//       this.onTap,
//       this.iconData,
//       this.rightIconSize,
//       this.rightIconBoxSize,
//       this.iconDataColor,
//       this.notificationCount = 0,
//       this.countTextSize,
//       this.boxShapeCircleColor})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     double? rightIconSizeTemp = rightIconBoxSize ?? (rightIconSize ?? 30.0);
//     AppNotificationBloc appNotificationBloc = BlocProvider.of<AppNotificationBloc>(context);
//
//     Widget menuIcon = iconData != null
//         ? (iconData!.contains(".svg")
//             ? SvgPicture.asset(iconData!,
//                 width: rightIconSize ?? AppDimens().iconSquareCustom(value: 18),
//                 height:
//                     rightIconSize ?? AppDimens().iconSquareCustom(value: 18),
//                 color: iconDataColor,
//                 fit: BoxFit.scaleDown)
//             : Image(
//                 image: AssetImage(iconData!),
//                 width: rightIconSize ?? AppDimens().iconSquareCustom(value: 18),
//                 height:
//                     rightIconSize ?? AppDimens().iconSquareCustom(value: 18),
//                 color: iconDataColor,
//               ))
//         : Container(
//             child: WorkplaceIcons.iconImage(
//               imageUrl: WorkplaceIcons.notificationIcon,
//               imageColor: AppColors.black,
//               iconSize: const Size(25, 25), //imageColor:Colors.white
//             ),
//           );
//
//     return BlocBuilder<AppNotificationBloc, AppNotificationState>(
//       bloc: appNotificationBloc,
//       builder: (context, state) {
//         if(state is NotificationCountDoneState){
//           notificationCount = state.notificationCount;
//         }
//         return InkWell(
//           onTap: onTap,
//           child: Container(
//             width: rightIconSizeTemp,
//             padding: EdgeInsets.zero,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[menuIcon],
//                 ),
//                 notificationCount! > 0
//                     ? Positioned(
//                   top: 0,
//                   right: notificationCount! > 9 ? 0 : 5,
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 2, right: 4),
//                     child: Container(
//                       //padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: boxShapeCircleColor ?? AppColors.appRed),
//                       alignment: Alignment.center,
//                       child: Container(
//                           margin: const EdgeInsets.all(4),
//                           child: Center(
//                             child: Text(
//                                 '${notificationCount! <= 99 ? notificationCount : "99+"}',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize:
//                                     notificationCount! <= 99 ? 12 : 8,
//                                     color: Colors
//                                         .white /*,backgroundColor: Colors.red*/
//                                 )),
//                           )),
//                     ),
//                   ),
//                 )
//                     : Container()
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
