import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  const CustomErrorWidget({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,color: Colors.white,size: 64,),
            SizedBox(height: 16,),
            Text(
              kDebugMode
                  ? errorDetails.summary.toString()
                  :"Oops! Something went wrong!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18,color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}