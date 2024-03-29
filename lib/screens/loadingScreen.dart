import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: LoadingAnimation(),
          )
        ],
      ),
    );
  }
}

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({Key key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LottieBuilder.asset(
        'assets/animations/booksLoading.json',
        height: 250,
      ),
    );
  }
}
