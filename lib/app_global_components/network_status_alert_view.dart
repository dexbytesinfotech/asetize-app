import '../imports.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatusAlertView extends StatefulWidget {
  final VoidCallback? onReconnect;
  const NetworkStatusAlertView({super.key, this.onReconnect});

  @override
  State createState() => _NetworkStatusAlertViewState();
}

class _NetworkStatusAlertViewState extends State<NetworkStatusAlertView> {
  bool _isLoading = false; // State variable to manage loading
  late UserProfileBloc userProfileBloc;

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<WorkplaceNetworkBloc, WorkplaceNetworkState>(
        listener: (context, state) {
          if (state is NetworkConnected) {
            getUserProfile();
            if (widget.onReconnect != null) {
              widget.onReconnect!();
            }
          }
        },

        builder: (context, state) {
          if (state is NetworkConnected) {
            return getUserProfile();
          } else {
            if (state is NetworkDisconnected) {
              return noInternetView();
            }else{
              return getUserProfile();
            }
          }
        });
  }

  getUserProfile(){
    return const SizedBox();
// return BlocBuilder<UserProfileBloc, UserProfileState>(
//     bloc: userProfileBloc,
//     builder: (context, state) {
//       if (state is UserProfileFetched) {
//         companies = userProfileBloc.user.companies;
//         initPermission();
//       }
//       return Padding(
//         padding:
//         const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "${AppString.hello} ${userProfileBloc.user.name ?? ''}",
//               style: appTextStyle.appTitleStyle(
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
// );
  }

 Widget noInternetView(){
    return Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/wifi_logo.svg',
                  height: 200,
                  width: 200,
                  color: Colors.black87,
                ),
                const Text('No Connection',
                  style: TextStyle(
                      color: Color(0xFF191D21),
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const Text('Please check your internet connectivity and try again',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF656F77),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                  child: _isLoading ? const Center(
                      child: CircularProgressIndicator(color: AppColors.textBlueColor,)
                  ):
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          foregroundColor: AppColors.white),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true; // Set loading state
                        });
                        await Future.delayed(const Duration(seconds: 2));

                        final connectivityResult =
                        await Connectivity().checkConnectivity();
                        setState(() {
                          _isLoading = false;
                        });
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {

                        } else {
                          WorkplaceWidgets.errorSnackBar(context, 'No internet connection. Please try again.');
                        }
                      }, child: const Text(
                    'Retry',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
              ],
            ),
          ),
        ) );
  }

}