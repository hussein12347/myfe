import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/local_storage_helper.dart';

import '../../../../../core/errors/failures.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repos/notification_repo.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
final NotificationRepo notificationRepo;

NotificationCubit(this.notificationRepo) : super(NotificationInitial());

List<NotificationModel> notifications = [];
List<String> readNotificationIds = [];

int get unReadNotifications => notifications.where((n) => !n.isRead).length;

Future<void> getNotifications() async {
emit(GetNotificationLoading());

// Load read notification IDs from SharedPreferences
readNotificationIds = await LocalStorageHelper.getReadNotifications();

final result = await notificationRepo.getNotifications();
result.fold(
(failure) => emit(GetNotificationFailure(failure)),
(fetchedNotifications) {
notifications = fetchedNotifications.map((notification) {
return notification.copyWith(
isRead: readNotificationIds.contains(notification.id),
);
}).toList();
emit(GetNotificationSuccess(notifications));
},
);
}

Future<void> markNotificationAsRead(NotificationModel notification) async {
if (!readNotificationIds.contains(notification.id)) {
readNotificationIds.add(notification.id);
await LocalStorageHelper.markNotificationAsRead(notification.id);
notifications = notifications.map((n) {
return n.id == notification.id ? n.copyWith(isRead: true) : n;
}).toList();
emit(GetNotificationSuccess(notifications));
}
}

Future<void> markAllNotificationsAsRead() async {
readNotificationIds = notifications.map((n) => n.id).toList();
await LocalStorageHelper.saveNotifications(readNotificationIds);
notifications = notifications.map((n) => n.copyWith(isRead: true)).toList();
emit(GetNotificationSuccess(notifications));
}

bool isNotificationRead(String notificationId) {
return readNotificationIds.contains(notificationId);
}
}
