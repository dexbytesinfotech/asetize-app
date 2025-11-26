import 'package:asetize/features/approval_pending_screen/bloc/approval_pending_bloc.dart';
import 'package:asetize/imports.dart';
import '../../../core/util/app_theme/text_style.dart';

class ApprovalPendingScreen extends StatelessWidget {
  final String? userName;
  const ApprovalPendingScreen({super.key ,this.userName});
  @override
  Widget build(BuildContext context) {
    ApprovalPendingBloc approvalPendingBloc = BlocProvider.of<ApprovalPendingBloc>(context);

    return BlocBuilder<ApprovalPendingBloc, ApprovalPendingState>(
        builder: (context, state) {
      if (approvalPendingBloc.isApprovalPending == false) {
        return const SizedBox();
      }
      return Container(
        color: Color(0xFFF5F5F5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if((userName ?? '').isNotEmpty) Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              child: Text(
                "${AppString.hello} $userName",
                style: appTextStyle.appTitleStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            topStatusCard(),
          ],
        ),
      );
    });
  }

  Widget topStatusCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.approvalPending,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppString.approvalPendingDescription,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Application Status
          buildStatusItem(
            Icons.check_circle,
            AppString.applicationSubmitted,
            AppString.applicationSubmittedDescription,
            Colors.black,
          ),
          buildStatusItem(
            Icons.notifications_active,
            AppString.reminding,
            AppString.remindingDescription,
            Colors.black,
          ),
          buildStatusItem(
            Icons.timelapse,
            AppString.verificationByAdmin,
            AppString.verificationByAdminDescription,
            Colors.orange,
          ),
         // const Divider(),

        ],
      ),
    );
  }

  Widget buildStatusItem(
      IconData icon, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
