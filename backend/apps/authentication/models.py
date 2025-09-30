from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import RegexValidator


class User(AbstractUser):
    """
    Modelo de usuario personalizado que extiende AbstractUser
    """
    ROLE_CHOICES = [
        ('patient', 'Paciente'),
        ('doctor', 'Doctor'),
        ('admin', 'Administrador'),
        ('nurse', 'Enfermero'),
        ('receptionist', 'Recepcionista'),
    ]
    
    email = models.EmailField(unique=True)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='patient')
    phone = models.CharField(
        max_length=15,
        validators=[RegexValidator(
            regex=r'^\+?1?\d{9,15}$',
            message="El número de teléfono debe tener entre 9 y 15 dígitos."
        )],
        blank=True,
        null=True
    )
    is_verified = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username', 'first_name', 'last_name']
    
    class Meta:
        db_table = 'users'
        verbose_name = 'Usuario'
        verbose_name_plural = 'Usuarios'
    
    def __str__(self):
        return f"{self.first_name} {self.last_name} ({self.email})"
    
    @property
    def full_name(self):
        return f"{self.first_name} {self.last_name}".strip()
    
    def is_patient(self):
        return self.role == 'patient'
    
    def is_doctor(self):
        return self.role == 'doctor'
    
    def is_admin(self):
        return self.role == 'admin'
