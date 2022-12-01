import 'package:flutter/material.dart';
import 'package:fwp/styles/styles.dart';

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isAppInDarkMode(context);

    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 5,
              width: 42,
              color: isDarkMode ? Colors.grey : Colors.black38,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
