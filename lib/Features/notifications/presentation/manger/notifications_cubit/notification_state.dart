part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class GetNotificationLoading extends NotificationState {}

class GetNotificationSuccess extends NotificationState {
final List<NotificationModel> notifications;

GetNotificationSuccess(this.notifications);
}

class GetNotificationFailure extends NotificationState {
final Failure failure;

GetNotificationFailure(this.failure);
}
