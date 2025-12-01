import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../generated/l10n.dart';
import '../../manger/notifications_cubit/notification_cubit.dart';
import '../widget/notification_view_body.dart';

class NotificationView extends StatelessWidget {
const NotificationView({super.key});

@override
Widget build(BuildContext context) {
return RefreshIndicator(
onRefresh: () async {
await context.read<NotificationCubit>().getNotifications();
},
child: Scaffold(
appBar: AppBar(
title: Text(S.of(context).notifications),
centerTitle: true,
  actions: [
    BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final unreadCount = context.watch<NotificationCubit>().unReadNotifications;

        if (unreadCount == 0) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextButton.icon(
            onPressed: () async {
              await context.read<NotificationCubit>().markAllNotificationsAsRead();
            },
            icon: const Icon(Icons.done_all, size: 16),
            label: Text(
              S.of(context).markAllAsRead,
              style: const TextStyle(fontSize: 9),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    ),
  ],
),
body: const NotificationViewBody(),
),
);
}
}
