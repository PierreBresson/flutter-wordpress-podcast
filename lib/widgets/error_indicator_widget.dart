import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  final String error;
  final VoidCallback onTryAgain;

  const ErrorIndicator(
      {required this.error,
      required this.onTryAgain,
      // linter false positive -- see https://dart-lang.github.io/linter/lints/require_trailing_commas.html
      // ignore: require_trailing_commas
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTryAgain,
            child: const Text("Essayer à nouveau"),
          )
        ],
      ),
    );
  }
}
