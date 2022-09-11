import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  final VoidCallback onTryAgain;

  const ErrorIndicator({required this.onTryAgain, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Une erreur est survenue lors du chargement",
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
