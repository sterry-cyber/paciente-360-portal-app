from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from apps.authentication.models import User
from apps.patients.models import Patient
from apps.doctors.models import Doctor


class Appointment(models.Model):
    """
    Modelo para citas médicas
    """
    STATUS_CHOICES = [
        ('scheduled', 'Programada'),
        ('confirmed', 'Confirmada'),
        ('in_progress', 'En Progreso'),
        ('completed', 'Completada'),
        ('cancelled', 'Cancelada'),
        ('no_show', 'No se presentó'),
        ('rescheduled', 'Reprogramada'),
    ]
    
    APPOINTMENT_TYPE_CHOICES = [
        ('consultation', 'Consulta'),
        ('follow_up', 'Seguimiento'),
        ('emergency', 'Emergencia'),
        ('routine', 'Rutina'),
        ('specialist', 'Especialista'),
    ]
    
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name='appointments')
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name='appointments')
    appointment_date = models.DateTimeField()
    duration = models.PositiveIntegerField(default=30, help_text="Duración en minutos")
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='scheduled')
    appointment_type = models.CharField(max_length=20, choices=APPOINTMENT_TYPE_CHOICES, default='consultation')
    reason = models.TextField(help_text="Motivo de la cita")
    notes = models.TextField(blank=True, null=True)
    created_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='created_appointments')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'appointments'
        verbose_name = 'Cita'
        verbose_name_plural = 'Citas'
        ordering = ['-appointment_date']
    
    def __str__(self):
        return f"{self.patient.user.full_name} - Dr. {self.doctor.user.full_name} - {self.appointment_date}"


class AppointmentReminder(models.Model):
    """
    Modelo para recordatorios de citas
    """
    REMINDER_TYPE_CHOICES = [
        ('email', 'Email'),
        ('sms', 'SMS'),
        ('push', 'Push Notification'),
    ]
    
    appointment = models.ForeignKey(Appointment, on_delete=models.CASCADE, related_name='reminders')
    reminder_type = models.CharField(max_length=10, choices=REMINDER_TYPE_CHOICES)
    reminder_time = models.DateTimeField()
    is_sent = models.BooleanField(default=False)
    sent_at = models.DateTimeField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'appointment_reminders'
        verbose_name = 'Recordatorio de Cita'
        verbose_name_plural = 'Recordatorios de Citas'
    
    def __str__(self):
        return f"Recordatorio {self.get_reminder_type_display()} - {self.appointment}"


class VirtualQueue(models.Model):
    """
    Modelo para filas virtuales/turnos
    """
    STATUS_CHOICES = [
        ('waiting', 'En Espera'),
        ('called', 'Llamado'),
        ('in_progress', 'En Atención'),
        ('completed', 'Atendido'),
        ('cancelled', 'Cancelado'),
    ]
    
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name='queue_entries')
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name='queue_entries')
    queue_number = models.PositiveIntegerField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='waiting')
    estimated_wait_time = models.PositiveIntegerField(blank=True, null=True, help_text="Tiempo estimado en minutos")
    check_in_time = models.DateTimeField(auto_now_add=True)
    called_at = models.DateTimeField(blank=True, null=True)
    completed_at = models.DateTimeField(blank=True, null=True)
    notes = models.TextField(blank=True, null=True)
    
    class Meta:
        db_table = 'virtual_queue'
        verbose_name = 'Fila Virtual'
        verbose_name_plural = 'Filas Virtuales'
        ordering = ['queue_number']
    
    def __str__(self):
        return f"Turno #{self.queue_number} - {self.patient.user.full_name} - {self.get_status_display()}"
