import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:h_book/app/constants/app_type.dart';
import 'package:h_book/main.dart';
import 'package:h_book/services/services.dart';
import 'package:h_book/utils/logger.dart';

class NotificationService {
  static ReceivedAction? initialCallAction;

  static final _logger = Logger("NotificationService");

  // ***************************************************************
  //    INITIALIZATIONS
  // ***************************************************************
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        'resource://drawable/res_app_icon',
        [
          NotificationChannel(
              channelGroupKey: 'basic_tests',
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white,
              importance: NotificationImportance.High),
          NotificationChannel(
            channelGroupKey: 'media_player_tests',
            icon: 'resource://drawable/res_media_icon',
            channelKey: 'media_player',
            channelName: 'Media player controller',
            channelDescription: 'Media player controller',
            defaultPrivacy: NotificationPrivacy.Public,
            enableVibration: false,
            enableLights: false,
            playSound: false,
          ),
          NotificationChannel(
              channelGroupKey: 'layout_tests',
              icon: 'resource://drawable/res_download_icon',
              channelKey: 'progress_bar',
              channelName: 'Progress bar notifications',
              channelDescription: 'Notifications with a progress bar layout',
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple,
              vibrationPattern: lowVibrationPattern,
              onlyAlertOnce: true),
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_tests', channelGroupName: 'Basic tests'),
          NotificationChannelGroup(
              channelGroupKey: 'media_player_tests',
              channelGroupName: 'Media Player tests')
        ],
        debug: true);
  }

  static Future<void> initializeNotificationsEventListeners() async {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationService.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationService.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationService.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationService.onDismissActionReceivedMethod);
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Always ensure that all plugins was initialized
    WidgetsFlutterBinding.ensureInitialized();

    bool isSilentAction =
        receivedAction.actionType == ActionType.SilentAction ||
            receivedAction.actionType == ActionType.SilentBackgroundAction;

    // SilentBackgroundAction runs on background thread and cannot show
    // UI/visual elements
    if (receivedAction.actionType != ActionType.SilentBackgroundAction) {}
    switch (receivedAction.channelKey) {
      case 'media_player':
        await receiveMediaNotificationAction(receivedAction);
        break;
      default:
        break;
    }
  }

  static Future<void> receiveMediaNotificationAction(
      ReceivedAction receivedAction) async {
    _logger.log("MEDIA::${receivedAction.buttonKeyPressed}");
    // final mediaService = getIt<TTSMediaPlayerService>();
    // switch (receivedAction.buttonKeyPressed) {
    //   case 'MEDIA_CLOSE':
    //     mediaService.onStopMedia();
    //     break;
    //   case 'MEDIA_PLAY':
    //     final result = await mediaService.onPlay();
    //     // createNotificationMedia(id: 10, mediaStatus: MediaStatus.play);
    //     break;
    //   case 'MEDIA_PAUSE':
    //     final result = mediaService.onPauseMedia();
    //     // createNotificationMedia(id: 10, mediaStatus: MediaStatus.pause);

    //     break;
    //   case 'MEDIA_PREV':
    //     mediaService.onSkipPrevious();
    //     break;
    //   case 'MEDIA_NEXT':
    //     mediaService.onSkipNext();
    //     break;
    //   default:
    //     break;
    // }
  }

  static Future<bool> createNotificationMedia(
      {required int id,
      required MediaStatus mediaStatus,
      bool update = false}) async {
    // if (update) {
    //   cancelNotification(id);
    // }
    final centerAction = mediaStatus == MediaStatus.start
        ? NotificationActionButton(
            key: 'MEDIA_PAUSE',
            icon: 'resource://drawable/res_ic_pause',
            label: 'Pause',
            autoDismissible: false,
            showInCompactView: true,
            actionType: ActionType.KeepOnTop)
        : NotificationActionButton(
            key: 'MEDIA_PLAY',
            icon: 'resource://drawable/res_ic_play',
            label: 'Play',
            autoDismissible: false,
            showInCompactView: true,
            actionType: ActionType.KeepOnTop);
    return AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'media_player',
            category: NotificationCategory.Transport,
            title: "Lam phuc hai",
            body: "mediaNow.trackName",
            summary: 'Now playing',
            notificationLayout: NotificationLayout.MediaPlayer,
            largeIcon:
                "https://images.unsplash.com/photo-1693336431373-70bf946433a7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2787&q=80",
            color: Colors.purple.shade700,
            autoDismissible: false,
            // progress: 29,
            locked: true,
            showWhen: false),
        actionButtons: [
          NotificationActionButton(
              key: 'MEDIA_PREV',
              icon: 'resource://drawable/res_ic_prev',
              label: 'Previous',
              autoDismissible: false,
              showInCompactView: false,
              enabled: true,
              actionType: ActionType.KeepOnTop),
          centerAction,
          NotificationActionButton(
              key: 'MEDIA_NEXT',
              icon: 'resource://drawable/res_ic_next',
              label: 'Previous',
              showInCompactView: true,
              enabled: true,
              actionType: ActionType.KeepOnTop),
          NotificationActionButton(
              key: 'MEDIA_CLOSE',
              icon: 'resource://drawable/res_ic_close',
              label: 'Close',
              autoDismissible: true,
              showInCompactView: true,
              actionType: ActionType.KeepOnTop)
        ]);
  }

  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}
