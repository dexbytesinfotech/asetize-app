import 'package:asetize/imports.dart';

class CustomCardView extends StatelessWidget {
  final String? text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  const CustomCardView(
      {Key? key,
      this.text,
      this.fontSize = 18,
      this.color = Colors.black,
      this.fontWeight = FontWeight.w800})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: AppDimens().widthFullScreen(),
        margin: const EdgeInsets.only(bottom: 18, left: 15, right: 15),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey.shade800,
          ),
          color: AppColors.appTransColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 85,
              margin: const EdgeInsets.only(top: 10, left: 7, right: 7),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: AppColors.appBgColor2,
                        height: 45,
                        width: 95,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        color: AppColors.appBgColor2,
                        height: 30,
                        width: 50,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding:
                          const EdgeInsets.all(10).copyWith(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: const Text(
                        "Show Balance",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              height: 85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 9,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text("5888  8888  8888  8888",
                        style: TextStyle(color: AppColors.white, fontSize: 15)),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("5/29",
                                style: TextStyle(color: AppColors.white)),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 30),
                              height: 28,
                              width: 35,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
