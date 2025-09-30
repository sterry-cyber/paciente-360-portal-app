import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/custom_button.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            const AppLogoSmall(size: 32),
            const SizedBox(width: 12),
            const Text('Notificaciones'),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtros
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Todas',
                    onPressed: () {},
                    backgroundColor: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: 'No leídas',
                    onPressed: () {},
                    backgroundColor: AppTheme.backgroundColor,
                    textColor: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: 'Importantes',
                    onPressed: () {},
                    backgroundColor: AppTheme.backgroundColor,
                    textColor: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Lista de notificaciones
            _NotificationCard(
              title: 'Cita Confirmada',
              message: 'Su cita con Dr. Ana Martínez ha sido confirmada para mañana a las 10:00 AM',
              time: 'Hace 2 horas',
              isRead: false,
              type: 'appointment',
            ),
            const SizedBox(height: 8),
            _NotificationCard(
              title: 'Recordatorio de Medicamento',
              message: 'Es hora de tomar su medicamento prescrito',
              time: 'Hace 4 horas',
              isRead: true,
              type: 'medication',
            ),
            const SizedBox(height: 8),
            _NotificationCard(
              title: 'Resultados de Laboratorio',
              message: 'Sus resultados de laboratorio están disponibles',
              time: 'Ayer',
              isRead: true,
              type: 'lab_results',
            ),
            const SizedBox(height: 8),
            _NotificationCard(
              title: 'Mantenimiento Programado',
              message: 'El sistema estará en mantenimiento el domingo de 2:00 AM a 4:00 AM',
              time: 'Hace 2 días',
              isRead: true,
              type: 'system',
            ),
            const SizedBox(height: 8),
            _NotificationCard(
              title: 'Nueva Funcionalidad',
              message: 'Ya puede agendar citas de emergencia desde la aplicación',
              time: 'Hace 3 días',
              isRead: true,
              type: 'feature',
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final String type;

  const _NotificationCard({
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    switch (type) {
      case 'appointment':
        icon = Icons.calendar_today;
        iconColor = AppTheme.primaryColor;
        break;
      case 'medication':
        icon = Icons.medication;
        iconColor = AppTheme.secondaryColor;
        break;
      case 'lab_results':
        icon = Icons.science;
        iconColor = AppTheme.successColor;
        break;
      case 'system':
        icon = Icons.settings;
        iconColor = AppTheme.warningColor;
        break;
      case 'feature':
        icon = Icons.new_releases;
        iconColor = AppTheme.successColor;
        break;
      default:
        icon = Icons.notifications;
        iconColor = AppTheme.mediumGray;
    }

    return Card(
      elevation: isRead ? 1 : 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isRead ? null : Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
