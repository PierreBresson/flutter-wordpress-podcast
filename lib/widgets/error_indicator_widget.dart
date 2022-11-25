import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';

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
          Text(
            LocaleKeys.ui_error_during_loading.tr(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTryAgain,
            child: Text(LocaleKeys.ui_try_again.tr()),
          )
        ],
      ),
    );
  }
}
