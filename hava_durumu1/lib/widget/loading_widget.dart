import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.height / 10,
                child: const LoadingIndicator(
                    indicatorType: Indicator.ballRotateChase,
                    colors: [Color(0xff0077b6)],
                    strokeWidth: 2,
                    backgroundColor: Colors.transparent,
                    pathBackgroundColor: Colors.black),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Please Wait',
              style: TextStyle(fontSize: 20),
            )
          ],
        ));
  }
}
