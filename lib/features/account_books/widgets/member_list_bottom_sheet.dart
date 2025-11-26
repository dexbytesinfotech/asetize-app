import '../../../imports.dart';
import '../../member/pages/teams_screen.dart';

class SelectMemberBottomSheet extends StatefulWidget {
  const SelectMemberBottomSheet({super.key});

  @override
  State<SelectMemberBottomSheet> createState() => _SelectMemberBottomSheetState();
}

class _SelectMemberBottomSheetState extends State<SelectMemberBottomSheet> {
  Widget status({required String text})
  {
    return    Padding(
      padding: const EdgeInsets.only(left: 20,top: 5,bottom: 5),

      child: Text(text,style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: AppColors.black,
      ),),
    );
  }
  @override
  Widget build(BuildContext context) {

    return  const BottomSheetOnlyCardView(
      physics: AlwaysScrollableScrollPhysics(),
      cardBackgroundColor: Colors.white,
      topLineShow: true,
      child : Column(
        children: [
      /*    Container(
            padding: const EdgeInsets.only(bottom: 65),
            child: AlphabetListView(
              items: itemGroups,
              options: options,
              // scrollController: scrollController, // Attach the scroll controller
            ),
          )*/
        ],
      ),
    );
  }
}

