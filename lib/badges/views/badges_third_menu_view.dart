import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqs_content_portal/features/badges/badges.dart';
import 'package:mqs_content_portal/widgets/widgets.dart';

class SelectedBadgesThirdView extends StatelessWidget {
  const SelectedBadgesThirdView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BadgesBloc, BadgesState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, snapshot) {
        if (snapshot.status == BadgesStatus.success) {
          return BadgesThirdSubMenuRowWidget(
              changedText: snapshot.updateOnTaped,
              badgeActivity: snapshot.badgesActivity);
        } else if (snapshot.status == BadgesStatus.loading) {
          return const MqsLoadingWidget();
        } else if (snapshot.status == BadgesStatus.failure) {
          return MqsErrorWidget(msg: snapshot.errorMsg);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
