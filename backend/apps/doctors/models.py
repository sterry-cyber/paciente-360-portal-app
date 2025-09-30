from django.db import models
from django.core.validators import RegexValidator
from apps.authentication.models import User


class Doctor(models.Model):
    """
    Modelo para información específica de doctores
    """
    SPECIALTY_CHOICES = [
        ('general', 'Medicina General'),
        ('cardiology', 'Cardiología'),
        ('dermatology', 'Dermatología'),
        ('neurology', 'Neurología'),
        ('orthopedics', 'Ortopedia'),
        ('pediatrics', 'Pediatría'),
        ('gynecology', 'Ginecología'),
        ('psychiatry', 'Psiquiatría'),
        ('ophthalmology', 'Oftalmología'),
        ('otolaryngology', 'Otorrinolaringología'),
        ('urology', 'Urología'),
        ('oncology', 'Oncología'),
        ('endocrinology', 'Endocrinología'),
        ('gastroenterology', 'Gastroenterología'),
        ('pulmonology', 'Neumología'),
        ('rheumatology', 'Reumatología'),
        ('anesthesiology', 'Anestesiología'),
        ('radiology', 'Radiología'),
        ('pathology', 'Patología'),
        ('emergency', 'Medicina de Emergencia'),
    ]
    
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='doctor_profile')
    license_number = models.CharField(max_length=20, unique=True)
    specialty = models.CharField(max_length=50, choices=SPECIALTY_CHOICES)
    years_experience = models.PositiveIntegerField(default=0)
    education = models.TextField(blank=True, null=True)
    certifications = models.TextField(blank=True, null=True)
    languages = models.CharField(max_length=200, blank=True, null=True, help_text="Idiomas separados por comas")
    consultation_fee = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    is_available = models.BooleanField(default=True)
    consultation_duration = models.PositiveIntegerField(default=30, help_text="Duración en minutos")
    bio = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'doctors'
        verbose_name = 'Doctor'
        verbose_name_plural = 'Doctores'
    
    def __str__(self):
        return f"Dr. {self.user.full_name} - {self.get_specialty_display()}"


class DoctorSchedule(models.Model):
    """
    Modelo para horarios de trabajo de los doctores
    """
    DAY_CHOICES = [
        (0, 'Lunes'),
        (1, 'Martes'),
        (2, 'Miércoles'),
        (3, 'Jueves'),
        (4, 'Viernes'),
        (5, 'Sábado'),
        (6, 'Domingo'),
    ]
    
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name='schedules')
    day_of_week = models.IntegerField(choices=DAY_CHOICES)
    start_time = models.TimeField()
    end_time = models.TimeField()
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'doctor_schedules'
        verbose_name = 'Horario de Doctor'
        verbose_name_plural = 'Horarios de Doctores'
        unique_together = ['doctor', 'day_of_week']
    
    def __str__(self):
        return f"{self.doctor.user.full_name} - {self.get_day_of_week_display()} {self.start_time}-{self.end_time}"
