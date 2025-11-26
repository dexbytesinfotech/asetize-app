import 'package:asetize/imports.dart';

class LoadingWidget {
  endLoadingPopUp(BuildContext context) {
    Navigator.pop(context);
  }

  startLoadingPopUp(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.loaderColor),
              ),
            ),
          );
        });
  }

  //It is simple transparent bg loader user for any view not like popup loader
  loadViewWidget({double loaderSize = 50}) => Center(
        child: SizedBox.fromSize(
          size: Size.square(loaderSize),
          child: (Platform.isIOS || Platform.isMacOS)
              ? Center(
                  child: SizedBox(
                    height: loaderSize,
                    width: loaderSize,
                    child: const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.loaderColor),
                    ),
                  ),
                )
              : Center(
                  child: SizedBox(
                    height: loaderSize,
                    width: loaderSize,
                    child: const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.loaderColor),
                    ),
                  ),
                ),
        ),
      );
}

LoadingWidget loadingWidget = LoadingWidget();
