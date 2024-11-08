import 'package:flutter/material.dart';
import 'package:mqs_content_portal/constants/constants.dart';
import 'package:mqs_content_portal/features/badges/badges.dart';
import 'package:mqs_content_portal/service/service.dart';
import 'package:mqs_content_portal/widgets/widgets.dart';
import 'package:super_extensions/super_extensions.dart';

class BadgesThirdSubMenuRowWidget extends StatelessWidget {
  const BadgesThirdSubMenuRowWidget(
      {super.key, required this.changedText, required this.badgeActivity});
  final String changedText;
  final MqsBadge badgeActivity;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.01),
        children: [
          if (changedText == StringConstants.add) ...[
            AddBadgesFormWidget()
          ] else if (changedText == StringConstants.update) ...[
            AddBadgesFormWidget()
          ] else if (changedText == StringConstants.display) ...[
            BadgesFormDataView(badgeActivity: badgeActivity)
          ] else
            const MqsThirdTextIconWidget(title: StringConstants.badges)
        ],
      ),
    );
  }
}
