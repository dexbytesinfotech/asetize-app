import 'dart:math';
import 'package:asetize/features/my_unit/bloc/my_unit_bloc.dart';
import 'package:asetize/features/my_unit/models/monthly_summery.dart';
import '../imports.dart';
import 'custom_bottom_sheet.dart';

class YearMonthCalendar extends StatefulWidget {
  final double? calendarWidth;
  final double? calendarHeight ;
  final TextStyle? yearTitleStyle;
  final int? houseId;

  const YearMonthCalendar({super.key,this.calendarWidth = 100,this.calendarHeight = 100,this.houseId,this.yearTitleStyle = const TextStyle(fontWeight: FontWeight.w700,color: Colors.blue,fontSize: 18)});

  @override
  State createState() => _YearMonthCalendarState();
}

class _YearMonthCalendarState extends State<YearMonthCalendar> {
  int selectedYear = DateTime.now().year;

  bool isYearChanged = false;

  int? selectedMonth;
  late double calendarWidth;
  EdgeInsetsGeometry? calendarViewPadding;
  late double nextPreIconSize = 45;
  late double crossAxisSpacing = 5;
  late double mainAxisSpacing = 5;
  late double calendarHeight;
  late Size monthSize; // Ensures the size is based on parent height
  late double appBarHeight = kToolbarHeight;

  Color topBarBgColor = AppColors.appBlueColor;
  Color bgColor = Colors.transparent;
  int numberOfColumn = 3;
  int nextYearLimit = 3;
  int prevYearLimit = 3;
  bool isMonthly = true;
  bool isLoading = false;
  bool enabledStatus = false;
  int currentYear = DateTime.now().year;  /// It must int please don't change it's data type

  Color disabledBorderColor = Colors.grey;
  Color selectedBorderColor = Colors.green;
  Color disabledColor = Colors.grey.shade400;
  Color unPayedColor  = Color(0xffed3d5d);
  Color payedColor    = Color(0xFF53b982);
  Color parsPaymentColor = Color(0xfff49e3f);

  late MyUnitBloc myUnitBloc;

  void _changeYear(int value) {
    /// It reached to limit
    if((value==-1 && isReachedMinLimit()) || (value==1  && isReachedMaxLimit())){
      return ;
    }
    setState(() {
      isYearChanged = true;
      selectedYear += value;
    });
    apiCalling();
  }

  bool isReachedMaxLimit() => selectedYear >= (currentYear+prevYearLimit);
  bool isReachedMinLimit() => selectedYear <= (currentYear-prevYearLimit);

  void _selectMonth(int index) {

    setState(() {
      selectedMonth = index;
    });
    paymentDetailsBottomSheet(context,index);
  }
  void paymentDetailsBottomSheet(BuildContext context,int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return
              CustomBottomSheet(
                onOkClick: (mContext){
                  Navigator.pop(context);
              },
                okTitle: "Close",
                child: Container(color: Colors.green,),);
          },
        );
      },
    );
  }

 @override
  void initState() {
    myUnitBloc = BlocProvider.of<MyUnitBloc>(context);
    apiCalling();
    // TODO: implement initState
   if(widget.calendarWidth! == double.infinity || widget.calendarWidth! == double.negativeInfinity){
     calendarWidth = MediaQuery.of(context).size.width;
   }
   else{

     calendarWidth = widget.calendarWidth!;
   }

   if(widget.calendarHeight! == double.infinity || widget.calendarHeight! == double.negativeInfinity) {
     calendarHeight = MediaQuery.of(context).size.height;
   }
   else{
     calendarHeight = widget.calendarHeight!;
   }

   monthSize = Size(calendarWidth / 4.5,70); // Ensures the size is based on parent height
    super.initState();
  }

  @override
  void didUpdateWidget(covariant YearMonthCalendar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      calendarWidth = widget.calendarWidth!;
      calendarHeight = widget.calendarHeight!;
      monthSize = Size(calendarWidth / 4.5,70); // Ensures the size is based on parent height
    });
  }
  @override
  Widget build(BuildContext context) {

    appBarHeight = kToolbarHeight ;
    topBarBgColor = Colors.grey.shade300;

    return
      BlocListener<MyUnitBloc, MyUnitState>(
        bloc: myUnitBloc,
        listener: (BuildContext context, MyUnitState state) {
          if (state is MyUnitErrorState2) {

            WorkplaceWidgets.errorSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<MyUnitBloc, MyUnitState>(
          bloc: myUnitBloc,
          builder: (BuildContext context, state) {
            if (state is MyMonthlySummeryLoadingState) {
              isLoading = true;
            } else {
              isLoading = false;
              isYearChanged = false;
            }
            return Column(
              children: [
                PreferredSize(preferredSize: Size(double.infinity, appBarHeight), child: Container(color: topBarBgColor,
                    height: appBarHeight,
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      SizedBox(
                        width: nextPreIconSize,
                        child: isReachedMinLimit()?const SizedBox():IconButton(style: ButtonStyle(iconSize: WidgetStateProperty.all(nextPreIconSize)),
                          icon: const Icon(Icons.arrow_left,color: Colors.blue,),
                          onPressed: () =>  isLoading?null:_changeYear(-1),
                        ),
                      ),
                      Expanded(child: Center(child: Text("$selectedYear",style: widget.yearTitleStyle))),
                      SizedBox(
                         width: nextPreIconSize,
                        child: isReachedMaxLimit()?const SizedBox():IconButton(style: ButtonStyle(iconSize: WidgetStateProperty.all(nextPreIconSize)),
                          icon: const Icon(Icons.arrow_right,color: Colors.blue),
                          onPressed: () => isLoading?null:_changeYear(1),
                        ),)
                    ],))),
                Container(
                  width: calendarWidth,
                  color: bgColor,
                  padding: const EdgeInsets.only(top: 12,right: 12,left: 12),
                  child:
                  calenderView(state),
                ),
              ],
            );
          },
        ),
      );
  }

  void updateValues() {
    numberOfColumn = myUnitBloc.monthlySummeryData!.column??3;
    // numberOfColumn = 3;
    if(numberOfColumn==2){
      monthSize =  Size(calendarWidth / 5.8,70);
      mainAxisSpacing = calendarWidth / 50;
      crossAxisSpacing = calendarWidth / 15;
    }
    else if(numberOfColumn==3){
      monthSize =  Size(calendarWidth / 6.8,70); ;
      mainAxisSpacing = calendarWidth / 50;
      crossAxisSpacing = calendarWidth / 15;
    }
    else if(numberOfColumn==4){
      monthSize =  Size(calendarWidth / 5.8,70);
      mainAxisSpacing = calendarWidth / 50;
      crossAxisSpacing = calendarWidth / 15;
    }
    else {
      monthSize =  Size(calendarWidth / 5.8,70);
      mainAxisSpacing = calendarWidth / 50;
      crossAxisSpacing = calendarWidth / 15;
    }
  }

  void apiCalling(){
    if(widget.houseId!=null) {
      myUnitBloc.add(FetchMonthlySummaryEvent(
          houseId: widget.houseId!, mContext: context, year: selectedYear));
    }
    else{
      Houses? house = BlocProvider
          .of<UserProfileBloc>(context)
          .selectedUnit;
      if (house != null) {
        myUnitBloc.add(FetchMonthlySummaryEvent(
            houseId: house.id!, mContext: context, year: selectedYear));
      }
    }
  }

 Widget calenderView(MyUnitState state) {
    /// Return empty data screen
    if((myUnitBloc.monthlySummeryData==null || myUnitBloc.monthlySummeryData!.months==null || myUnitBloc.monthlySummeryData!.months!.isEmpty) && state is MyMonthlySummeryDoneState){
      return SizedBox(height: MediaQuery.of(context).size.height/2, child: const Center(child: Text("Not data found")));
    }
    /// Return empty data screen
    // if(myUnitBloc.monthlySummeryData==null && state is MyMonthlySummeryLoadingState){
    //   return const SizedBox();
    // }
    if(myUnitBloc.monthlySummeryData!=null){
      updateValues();
    }
    return
      Stack(
        children: [
          if(myUnitBloc.monthlySummeryData!=null && myUnitBloc.monthlySummeryData!.months!=null && myUnitBloc.monthlySummeryData!.months!.isNotEmpty)
         Container(padding: calendarViewPadding??const EdgeInsets.symmetric(horizontal: 35),
           child:  GridView.builder(
           shrinkWrap: true,
           padding: const EdgeInsets.all(0),
           physics: const NeverScrollableScrollPhysics(), // Disable scrolling
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: numberOfColumn, // 4 columns
             crossAxisSpacing: crossAxisSpacing,
             mainAxisSpacing: mainAxisSpacing,
           ),
           itemCount: myUnitBloc.monthlySummeryData!.months!.length,
           itemBuilder: (context, index) {
             Months months =  myUnitBloc.monthlySummeryData!.months![index];
             bool activeStatus = months.status??false;
             double percentage = 0.0;
             bool canSelect = false;
             bool isSelected = false;
             Color? fillColor;
             if(activeStatus==true){
               percentage = months.unpaidPercentage!=null?double.parse(months.unpaidPercentage.toString()):0.0;
               if(percentage>0){
                 if(percentage<100)
                {
                  fillColor = parsPaymentColor;
                }
                 else{
                   fillColor = unPayedColor;
                 }
                 percentage = percentage/100;
               }
               else{
                 fillColor = payedColor;
               }
               canSelect = months.transactions!.isNotEmpty;
               if(canSelect){
                 isSelected = selectedMonth == index;
               }
             }


             return Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Expanded(
                   child: GestureDetector(
                     onTap: () => canSelect==true?_selectMonth(index):null,
                     child:
                     AnimatedContainer(
                       duration: const Duration(milliseconds: 300),
                       // width: double.infinity,
                       // height: double.infinity,
                       width: monthSize.width,
                       height: monthSize.height,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         // color: monthColors[index],
                         border: isSelected
                             ? Border.all(color: Colors.black, width: 3)
                             : null,
                         boxShadow: [
                           if (isSelected)
                             BoxShadow(
                               color: Colors.black.withOpacity(0.3),
                               blurRadius: 8,
                               spreadRadius: 2,
                             ),
                         ],
                       ),
                       alignment: Alignment.center,
                       child: Stack(
                         children: [
                           // PercentageGraph(
                           //   percentage: percentage, // 70% red, 30% blue
                           //   color1: unPayedColor,
                           //   color2: activeStatus?payedColor:disabledColor,
                           //   size: double.infinity, // Size of the graph
                           // ),
                           // Center(
                           //   child: Text(
                           //     months.title??"",
                           //     style: TextStyle(
                           //       fontSize: isSelected ? 28 : 20,
                           //       fontWeight: FontWeight.bold,
                           //       color: isSelected ? Colors.black : Colors.white,
                           //     ),
                           //   ),
                           // ),

                           // payedColor
                           // unPayedColor
                           // parsPaymentColor
                           CalendarMonthCard(month: months.title??"",isSelected:isSelected,fillColor: fillColor)
                         ],
                       ),
                     ),
                   ),
                 ),
               ],
             );
           },
         ),),
          if(isYearChanged && state is MyMonthlySummeryLoadingState) SizedBox(
              height: MediaQuery.of(context).size.height/2, child: WorkplaceWidgets.progressLoader(context))
        ],
      );
 }
}

class PercentageGraph extends StatelessWidget {
  final double percentage; // Value between 0.0 and 1.0
  final Color color1;
  final Color color2;
  final double size;

  const PercentageGraph({
    Key? key,
    required this.percentage,
    required this.color1,
    required this.color2,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: GraphPainter(percentage, color1, color2),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final double percentage;
  final Color color1;
  final Color color2;

  GraphPainter(this.percentage, this.color1, this.color2);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1 = Paint()
      ..color = color1
      ..style = PaintingStyle.fill;

    final Paint paint2 = Paint()
      ..color = color2
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2);
    const double startAngle = -pi / 2; // Start from the top
    final double sweepAngle1 = percentage * 2 * pi; // First segment
    final double sweepAngle2 = (1 - percentage) * 2 * pi; // Second segment

    // Draw the first part (percentage)
    canvas.drawArc(rect, startAngle, sweepAngle1, true, paint1);

    // Draw the second part (remaining)
    canvas.drawArc(rect, startAngle + sweepAngle1, sweepAngle2, true, paint2);
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.color1 != color1 ||
        oldDelegate.color2 != color2;
  }
}

// class CalendarMonthCard extends StatelessWidget {
//   final String month;
//   const CalendarMonthCard({super.key, required this.month});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: 80,
//           height: 80,
//           margin: const EdgeInsets.only(top: 5),
//           decoration: BoxDecoration(
//             color: Colors.lightBlue.shade100, // Light blue background
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.indigo, width: 2.5), // Dark blue border
//           ),
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: 20,
//                   decoration: const BoxDecoration(
//                     color: Colors.blue, // Darker blue header
//                     borderRadius:  BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10),
//                     ),
//                     border: Border(
//                       bottom: BorderSide(color: Colors.indigo, width: 2.5), // Only bottom border
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: 40,
//                   decoration: const BoxDecoration(
//                     color: Colors.white, // Darker blue header
//                     borderRadius:  BorderRadius.only(
//                       bottomRight: Radius.circular(10),
//                       bottomLeft: Radius.circular(10),
//                     ),
//                     border: Border(
//                       bottom: BorderSide(color: Colors.indigo, width: 2.5), // Only bottom border
//                     ),
//                   ),
//                 ),
//               ),
//               Center(
//                 child: Container(
//                   decoration: BoxDecoration(
//                   color: Colors.white, // Light blue background
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.white, width: 0), // Dark blue border
//                 ),
//                   child: Text(
//                     month,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: SizedBox(
//                   height: 47,
//                   child: Center(
//                     child: Text(
//                       month,
//                       style: const TextStyle(
//                         color: Colors.indigo,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//
//             ],
//           ),
//         ),
//         const Positioned(
//           top: 0,
//           left: 14,
//           right: 14,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Left Oval
//               DecoratedBox(
//                 decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     color: Colors.blue, // Inner color
//                     border: Border.fromBorderSide(BorderSide(color: Colors.indigo, width: 2.5)),
//                     borderRadius: BorderRadius.all(Radius.circular(50))
//                   // Outer border
//                 ),
//                 child: SizedBox(
//                   width: 9,
//                   height: 18, // Oval Shape
//                 ),
//               ),
//
//               // Right Oval
//               DecoratedBox(
//                 decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     color: Colors.blue, // Inner color
//                     border: Border.fromBorderSide(BorderSide(color: Colors.indigo, width: 2.5)),
//                     borderRadius: BorderRadius.all(Radius.circular(50))
//                   // Outer border
//                 ),
//                 child: SizedBox(
//                   width: 9,
//                   height: 18, // Oval Shape
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


class CalendarMonthCard extends StatelessWidget {
  final String month;
  final double height ;
  final double width ;
  final bool? isSelected ;
  final Color? fillColor ;
  final Color? disabledColor ;
  final Color? unPayedColor;
  final Color? payedColor;
  const CalendarMonthCard({super.key, required this.month,this.height = 80,this.width = 70,this.isSelected = false,
  this.disabledColor = Colors.grey,this.fillColor,this.payedColor,this.unPayedColor});

  @override
  Widget build(BuildContext context) {
    double topViewHeight = height/5.5;
    double? borderWidth = 2;
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          margin: const EdgeInsets.only(top: 5),
        //  padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: fillColor??Colors.lightBlue.shade100, // Light blue background
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.indigo, width: borderWidth), // Dark blue border
          ),
          child:

          Column(
            children: [
              // Header with bottom border
              Container(
                height: topViewHeight,
                decoration: BoxDecoration(
                  color: AppColors.appBlueColor, // Darker blue header
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  border: Border(bottom: BorderSide(color: Colors.indigo, width: borderWidth)),
                ),
              ),
              // Bottom section
              Center(child:
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  month,
                  style: TextStyle(
                    fontSize: isSelected! ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected! ? Colors.yellow : Colors.indigo,
                  ),
                ),
              )),
            ],
          ),
        ),

        // Oval shapes at the top
         Positioned(
          top: 0,
          left: 14,
          right: 14,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OvalShape(bagColor: Colors.yellow,borderWidth:borderWidth),
              OvalShape(bagColor: Colors.yellow,borderWidth:borderWidth),
            ],
          ),
        ),
      ],
    );
  }
}

class OvalShape extends StatelessWidget {
  final Color? bagColor;
  final double? borderWidth;
  const OvalShape({super.key,this.bagColor = AppColors.appBlueColor,this.borderWidth = 2.5});
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: bagColor,
        border: Border.all(color: Colors.indigo, width: borderWidth!),
        borderRadius: const BorderRadius.all(Radius.circular(50)), // Oval shape
      ),
      child: const SizedBox(width: 9, height: 18),
    );
  }
}