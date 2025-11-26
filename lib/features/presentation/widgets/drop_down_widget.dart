//for Restaurant type dropdown

import '../../../imports.dart';

class DropDownDataPicker extends StatefulWidget {
  final List<DropdownMenuItem<String>> itemList;
  final String? hint;
  final Color? borderColor;
  final Function? selectedValue;
  final String? valueChoose;

  const DropDownDataPicker(
      {Key? key,
      required this.itemList,
      this.hint,
      this.selectedValue,
      this.borderColor,
      this.valueChoose})
      : super(key: key);

  @override
  State createState() => _DropDownDataPickerState(
      restaurantTypeList: itemList, valueChoose: valueChoose);
}

class _DropDownDataPickerState extends State<DropDownDataPicker> {
  String? valueChoose;

  List<DropdownMenuItem<String>>? restaurantTypeList;

  _DropDownDataPickerState(
      {this.restaurantTypeList, required this.valueChoose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.only(right: 6),
      margin: const EdgeInsets.only(
        left: 20,
        right: 22,
      ),
      decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
              width: 0.8, color: widget.borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 3,
                offset: const Offset(0, 1),
                blurRadius: 3)
          ]),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: DropdownButton<String>(
            style: const TextStyle(
              color: Colors.black,
            ),
            alignment: AlignmentDirectional.centerStart,
            iconEnabledColor: Colors.grey.shade500,
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 28,
            elevation: 1,
            isExpanded: true,
            underline: Container(
              height: 0.0,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFBDBDBD),
                    width: 0.01,
                  ),
                ),
              ),
            ),
            dropdownColor: AppColors.white,
            // dropdownColor: !isDarkMode? Colors.grey.shade300 : Color(0xff212327),
            // alignment: Alignment.bottomCenter,
            borderRadius: BorderRadius.circular(10),
            hint: Text(widget.hint ?? "",
                style: appStyles.userJobTitleTextStyle(
                    fontSize: 14, texColor: Colors.grey.shade600)),
            isDense: false,
            value: valueChoose,
            items: restaurantTypeList,
            onChanged: (value) => setState(() {
                  valueChoose = value;
                  widget.selectedValue?.call(value);
                }
                )),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
        value: item, child: Text(item, style: appStyles.hintTextStyle()));
  }
}

class DropDownDataPicker2 extends StatefulWidget {
  final List<DropdownMenuItem<String>> itemList;
  final String? hint;
  final Color? borderColor;
  final Function? selectedValue;

  const DropDownDataPicker2(
      {Key? key,
      required this.itemList,
      this.hint,
      this.selectedValue,
      this.borderColor})
      : super(key: key);

  @override
  _DropDownDataPicker2State createState() => _DropDownDataPicker2State(
        restaurantTypeList: itemList,
      );
}

class _DropDownDataPicker2State extends State<DropDownDataPicker2> {
  String? valueChoose;

  List<DropdownMenuItem<String>>? restaurantTypeList;

  _DropDownDataPicker2State({this.restaurantTypeList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.only(right: 6),
      margin: const EdgeInsets.only(
        left: 20,
        right: 22,
      ),
      decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
              width: 0.8, color: widget.borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 3,
                offset: const Offset(0, 1),
                blurRadius: 3)
          ]),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: DropdownButton<String>(
            style: const TextStyle(
              color: Colors.black,
            ),
            alignment: AlignmentDirectional.centerStart,
            iconEnabledColor: Colors.grey.shade500,
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 28,
            elevation: 1,
            isExpanded: true,
            underline: Container(
              height: 0.0,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFBDBDBD),
                    width: 0.01,
                  ),
                ),
              ),
            ),
            dropdownColor: AppColors.white,
            // dropdownColor: !isDarkMode? Colors.grey.shade300 : Color(0xff212327),
            // alignment: Alignment.bottomCenter,
            borderRadius: BorderRadius.circular(10),
            hint: Text(widget.hint ?? "",
                style: appStyles.userJobTitleTextStyle(
                    fontSize: 14, texColor: Colors.grey.shade600)),
            isDense: false,
            value: valueChoose,
            items: restaurantTypeList,
            onChanged: (value) => setState(() {
                  valueChoose = value;
                  widget.selectedValue?.call(value);
                })),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
        value: item, child: Text(item, style: appStyles.hintTextStyle()));
  }
}
