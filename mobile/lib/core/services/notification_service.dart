import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Configurar notificaciones locales
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Configurar canal de notificaciones Android
    const androidChannel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: 'Notificaciones de Paciente 360',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Configurar Firebase Messaging
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Configurar manejadores de mensajes
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    
    // Manejar mensaje cuando la app está cerrada
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Manejar tap en notificación local
    final payload = response.payload;
    if (payload != null) {
      _handleNotificationPayload(payload);
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    // Mostrar notificación local cuando la app está en primer plano
    _showLocalNotification(
      title: message.notification?.title ?? 'Paciente 360',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  static void _handleBackgroundMessage(RemoteMessage message) {
    // Manejar mensaje cuando la app está en segundo plano
    final data = message.data;
    if (data.isNotEmpty) {
      _handleNotificationPayload(data.toString());
    }
  }

  static void _handleNotificationPayload(String payload) {
    // Implementar navegación basada en el tipo de notificación
    // Esto se puede expandir según las necesidades específicas
    print('Notification payload: $payload');
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription: 'Notificaciones de Paciente 360',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  static Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
    } catch (e) {
      print('Error subscribing to topic $topic: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } catch (e) {
      print('Error unsubscribing from topic $topic: $e');
    }
  }

  static Future<void> showAppointmentReminder({
    required String doctorName,
    required String appointmentTime,
    required String appointmentDate,
  }) async {
    await _showLocalNotification(
      title: 'Recordatorio de Cita',
      body: 'Tienes una cita con $doctorName el $appointmentDate a las $appointmentTime',
      payload: 'appointment_reminder',
    );
  }

  static Future<void> showLabResultNotification({
    required String testName,
    required String status,
  }) async {
    await _showLocalNotification(
      title: 'Resultado de Laboratorio',
      body: 'Tu resultado de $testName está listo. Estado: $status',
      payload: 'lab_result',
    );
  }

  static Future<void> showQueueUpdateNotification({
    required int queueNumber,
    required String status,
  }) async {
    await _showLocalNotification(
      title: 'Actualización de Fila',
      body: 'Tu turno #$queueNumber: $status',
      payload: 'queue_update',
    );
  }
}
