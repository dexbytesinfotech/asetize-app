import '../core/util/app_theme/text_style.dart';
import '../imports.dart';

class NoMemberInUnitsErrorScreen extends StatelessWidget {
  final Function()? onAddMemberClicked;
  const NoMemberInUnitsErrorScreen({super.key,required this.onAddMemberClicked});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.3,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.person_add_alt_1, size: 60, color: Colors.grey),
              const SizedBox(height: 10),
              Text(
                AppString.noMembersFound,
                textAlign: TextAlign.center,
                style: appTextStyle.appNormalSmallTextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  onAddMemberClicked?.call();
                },
                icon: const Icon(Icons.add, size: 25, color: Colors.white),
                label: Text(
                  AppString.addMember,
                  style: appTextStyle.appNormalSmallTextStyle(
                    color: AppColors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.textBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
