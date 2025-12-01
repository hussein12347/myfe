import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/generated/assets.dart';
import '../../../../../core/utils/widgets/loading_widget.dart';
import '../../../../../generated/l10n.dart';
import '../../manger/notifications_cubit/notification_cubit.dart';

class NotificationViewBody extends StatelessWidget {
  const NotificationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state is GetNotificationSuccess) {
          if (state.notifications.isEmpty) {
            return Center(
              child: Text(
                S.of(context).no_available_notifications,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return GestureDetector(
                onTap: () => context
                    .read<NotificationCubit>()
                    .markNotificationAsRead(notification),
                child: _NotificationItem(
                  title: notification.title,
                  subtitle: notification.body, // Changed from object to body
                  date: notification.createdAt,
                  isRead: notification.isRead,
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: state.notifications.length,
          );
        } else if (state is GetNotificationFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).errorLoadingNotifications,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<NotificationCubit>().getNotifications(),
                  child: Text(S.of(context).retry),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child:loadingWidget(context),
          );
        }
      },
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime date; // Changed to DateTime
  final bool isRead;

  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String formattedDate = _formatDate(date, context);

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, opacity, child) {
        return Opacity(opacity: opacity, child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,

          border:isRead ?null: Border.all(color: Theme.of(context).colorScheme.secondary),
          gradient: LinearGradient(
            colors: [
              !isRead ?  theme.cardColor : theme.cardColor.withOpacity(0.8),
              !isRead ?  theme.cardColor : theme.cardColor.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isRead ? 0.05 : 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Notification Icon
            Stack(
              children: [Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(isRead ? 0.3 : 0.6),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  Assets.imagesBell,
                  width: 24,
                  height: 24,
                ),
              ),
                if (!isRead)
                  Positioned(
                    right: -.8,
                    top: -.8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
            ]
            ),const SizedBox(width: 12),

            /// Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title and Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Title
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: isRead
                                ? FontWeight.w600
                                : FontWeight.w700,
                            fontSize: 14,
                            color: theme.textTheme.titleMedium?.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      /// Date
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(
    isRead ? 0.08 : 0.15,
    ),


                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// Subtitle
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        isRead ? 0.6 : 0.9,
                      ),
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Format date based on language
  String _formatDate(DateTime date, BuildContext context) {
    final isArabic = LanguageHelper.isArabic();
    final format = isArabic
        ? DateFormat('d MMM yyyy', 'ar')
        : DateFormat('d MMM yyyy', 'en');
    return format.format(date);
  }
}
