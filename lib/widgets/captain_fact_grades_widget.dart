import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/styles/styles.dart';

class CaptainFactGrades extends StatelessWidget {
  final List<Comments>? comments;
  const CaptainFactGrades({Key? key, required this.comments}) : super(key: key);

  Color getTextColor(BuildContext context, int? grade) {
    if (isAppInDarkMode(context)) {
      if (grade! > 0) {
        return Colors.white;
      } else {
        return Colors.white;
      }
    } else {
      if (grade! > 0) {
        return Colors.white;
      } else {
        return Colors.black;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int? sumOfApprovals = 0;
    int? sumOfDisapprovals = 0;

    final validComments = comments
        ?.where(
          (comment) => comment.replyToId == null && comment.approve != null,
        )
        .toList();

    if (validComments!.isNotEmpty) {
      final validCommentsApproving =
          validComments.where((comment) => comment.approve == true);
      final approvals =
          validCommentsApproving.map((comment) => comment.score).toList();
      if (approvals.isNotEmpty) {
        sumOfApprovals = approvals.reduce((sum, element) => sum! + element!);
      }

      final validCommentsDisapproving =
          validComments.where((comment) => comment.approve == false);
      final disapprovals =
          validCommentsDisapproving.map((comment) => comment.score).toList();
      if (disapprovals.isNotEmpty) {
        sumOfDisapprovals =
            disapprovals.reduce((sum, element) => sum! + element!);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: sumOfApprovals! > 0
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.green,
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 2,
            ),
            child: Text(
              LocaleKeys.captain_fact_grades_widget_confirme
                  .tr(args: [sumOfApprovals.toString()]),
              style: TextStyle(
                color: getTextColor(context, sumOfApprovals),
              ),
            ),
          ),
        ),
        Container(
          decoration: sumOfDisapprovals! > 0
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.red,
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 2,
            ),
            child: Text(
              LocaleKeys.captain_fact_grades_widget_refute
                  .tr(args: [sumOfDisapprovals.toString()]),
              style: TextStyle(
                color: getTextColor(context, sumOfDisapprovals),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
