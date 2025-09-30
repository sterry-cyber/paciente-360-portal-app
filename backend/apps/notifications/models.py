from django.db import models
from apps.authentication.models import User
from apps.patients.models import Patient
from apps.doctors.models import Doctor
from apps.appointments.models import Appointment


class Notification(models.Model):
    """
    Modelo para notificaciones del sistema
    """
    NOTIFICATION_TYPE_CHOICES = [
        ('appointment_reminder', 'Recordatorio de Cita'),
        ('appointment_confirmation', 'Confirmación de Cita'),
        ('appointment_cancellation', 'Cancelación de Cita'),
        ('lab_result', 'Resultado de Laboratorio'),
        ('imaging_result', 'Resultado de Imagenología'),
        ('prescription_ready', 'Receta Lista'),
        ('queue_update', 'Actualización de Fila'),
        ('general', 'General'),
        ('emergency', 'Emergencia'),
    ]
    
    PRIORITY_CHOICES = [
        ('low', 'Baja'),
        ('medium', 'Media'),
        ('high', 'Alta'),
        ('urgent', 'Urgente'),
    ]
    
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notifications')
    notification_type = models.CharField(max_length=30, choices=NOTIFICATION_TYPE_CHOICES)
    title = models.CharField(max_length=200)
    message = models.TextField()
    priority = models.CharField(max_length=10, choices=PRIORITY_CHOICES, default='medium')
    is_read = models.BooleanField(default=False)
    is_sent = models.BooleanField(default=False)
    sent_at = models.DateTimeField(blank=True, null=True)
    read_at = models.DateTimeField(blank=True, null=True)
    
    # Referencias opcionales a otros modelos
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, null=True, blank=True, related_name='notifications')
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, null=True, blank=True, related_name='notifications')
    appointment = models.ForeignKey(Appointment, on_delete=models.CASCADE, null=True, blank=True, related_name='notifications')
    
    # Datos adicionales en formato JSON
    metadata = models.JSONField(blank=True, null=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'notifications'
        verbose_name = 'Notificación'
        verbose_name_plural = 'Notificaciones'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.title} - {self.recipient.full_name}"


class NotificationTemplate(models.Model):
    """
    Modelo para plantillas de notificaciones
    """
    name = models.CharField(max_length=100, unique=True)
    notification_type = models.CharField(max_length=30, choices=Notification.NOTIFICATION_TYPE_CHOICES)
    title_template = models.CharField(max_length=200)
    message_template = models.TextField()
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'notification_templates'
        verbose_name = 'Plantilla de Notificación'
        verbose_name_plural = 'Plantillas de Notificaciones'
    
    def __str__(self):
        return f"{self.name} - {self.get_notification_type_display()}"


class NotificationSettings(models.Model):
    """
    Modelo para configuraciones de notificaciones por usuario
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='notification_settings')
    
    # Configuraciones de email
    email_enabled = models.BooleanField(default=True)
    email_appointment_reminders = models.BooleanField(default=True)
    email_lab_results = models.BooleanField(default=True)
    email_imaging_results = models.BooleanField(default=True)
    email_prescriptions = models.BooleanField(default=True)
    
    # Configuraciones de SMS
    sms_enabled = models.BooleanField(default=False)
    sms_appointment_reminders = models.BooleanField(default=False)
    sms_urgent_notifications = models.BooleanField(default=True)
    
    # Configuraciones de push notifications
    push_enabled = models.BooleanField(default=True)
    push_appointment_reminders = models.BooleanField(default=True)
    push_queue_updates = models.BooleanField(default=True)
    push_general_notifications = models.BooleanField(default=True)
    
    # Configuraciones de timing
    reminder_hours_before = models.PositiveIntegerField(default=24, help_text="Horas antes de la cita para enviar recordatorio")
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'notification_settings'
        verbose_name = 'Configuración de Notificaciones'
        verbose_name_plural = 'Configuraciones de Notificaciones'
    
    def __str__(self):
        return f"Configuración de notificaciones - {self.user.full_name}"
