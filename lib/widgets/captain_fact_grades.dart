import 'package:flutter/material.dart';
import 'package:fwp/models/models.dart';

class CaptainFactGrades extends StatelessWidget {
  final List<Comments>? comments;
  const CaptainFactGrades({Key? key, required this.comments}) : super(key: key);

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
              "Confirme: $sumOfApprovals",
              style: TextStyle(
                color: sumOfApprovals > 0 ? Colors.white : Colors.black,
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
              "Réfute: $sumOfDisapprovals",
              style: TextStyle(
                color: sumOfDisapprovals > 0 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
