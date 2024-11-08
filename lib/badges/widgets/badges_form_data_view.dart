import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqs_content_portal/constants/constants.dart';
import 'package:mqs_content_portal/features/badges/badges.dart';
import 'package:mqs_content_portal/service/service.dart';
import 'package:mqs_content_portal/widgets/widgets.dart';

class BadgesFormDataView extends StatelessWidget {
  const BadgesFormDataView({
    super.key,
    required this.badgeActivity,
  });
  final MqsBadge badgeActivity;

  @override
  Widget build(BuildContext context) {
    return MQSFormViewMainWidget(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () {
                context
                    .read<BadgesBloc>()
                    .add(const UpdateBtnChangedBadgesEvent(updateChanged: ""));
              },
              icon: const Icon(Icons.cancel_outlined,
                  color: ColorConstants.kHintTextColor)),
        ),
        for (var entry in badgeActivity.toJson().entries)
          if (entry.value is Map)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var innerEntry in (entry.value as Map).entries)
                  FormViewTextTileWidget(
                    keyValue: innerEntry.key ?? "",
                    value: innerEntry.value.toString(),
                    matchedKeyValue: StringConstants.mqsBadgeDescription,
                  ),
              ],
            )
          else if (entry.value is Set)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var setValue in (entry.value as Set))
                  FormViewTextTileWidget(
                    keyValue: setValue.key ?? "",
                    value: setValue.value.toString(),
                    matchedKeyValue: StringConstants.mqsBadgeDescription,
                  ),
              ],
            )
          else
            FormViewTextTileWidget(
              keyValue: entry.key == StringConstants.underscoreid
                  ? StringConstants.badgeId
                  : entry.key == StringConstants.mqsBadgeName
                      ? StringConstants.badgeName
                      : entry.key,
              value: entry.value.toString(),
              matchedKeyValue: StringConstants.mqsBadgeDescription,
            ),
      ],
    ));
  }
}
