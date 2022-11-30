import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';

class ErrorLoadingScreen extends StatelessWidget {
  final VoidCallback refresh;
  const ErrorLoadingScreen({
    super.key,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(LocaleKeys.ui_error.tr()),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
              size: 20,
            ),
            onPressed: refresh,
            label: Text(LocaleKeys.ui_try_again.tr()),
          )
        ],
      ),
    );
  }
}
