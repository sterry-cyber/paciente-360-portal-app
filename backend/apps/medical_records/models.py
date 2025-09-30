from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from apps.authentication.models import User
from apps.patients.models import Patient
from apps.doctors.models import Doctor
from apps.appointments.models import Appointment


class MedicalRecord(models.Model):
    """
    Modelo para expedientes clínicos electrónicos
    """
    RECORD_TYPE_CHOICES = [
        ('consultation', 'Consulta'),
        ('diagnosis', 'Diagnóstico'),
        ('treatment', 'Tratamiento'),
        ('lab_result', 'Resultado de Laboratorio'),
        ('imaging', 'Imagenología'),
        ('prescription', 'Receta'),
        ('vaccination', 'Vacunación'),
        ('surgery', 'Cirugía'),
        ('emergency', 'Emergencia'),
    ]
    
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name='medical_records')
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name='medical_records')
    appointment = models.ForeignKey(Appointment, on_delete=models.SET_NULL, null=True, blank=True, related_name='medical_records')
    record_type = models.CharField(max_length=20, choices=RECORD_TYPE_CHOICES)
    title = models.CharField(max_length=200)
    description = models.TextField()
    diagnosis = models.TextField(blank=True, null=True)
    treatment = models.TextField(blank=True, null=True)
    medications = models.TextField(blank=True, null=True)
    vital_signs = models.JSONField(blank=True, null=True, help_text="Signos vitales en formato JSON")
    notes = models.TextField(blank=True, null=True)
    is_confidential = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'medical_records'
        verbose_name = 'Expediente Clínico'
        verbose_name_plural = 'Expedientes Clínicos'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.patient.user.full_name} - {self.title} - {self.created_at.date()}"


class LabResult(models.Model):
    """
    Modelo para resultados de laboratorio
    """
    STATUS_CHOICES = [
        ('pending', 'Pendiente'),
        ('completed', 'Completado'),
        ('abnormal', 'Anormal'),
        ('critical', 'Crítico'),
    ]
    
    medical_record = models.ForeignKey(MedicalRecord, on_delete=models.CASCADE, related_name='lab_results')
    test_name = models.CharField(max_length=200)
    test_code = models.CharField(max_length=50, blank=True, null=True)
    result_value = models.CharField(max_length=100)
    normal_range = models.CharField(max_length=100, blank=True, null=True)
    unit = models.CharField(max_length=20, blank=True, null=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    lab_name = models.CharField(max_length=200, blank=True, null=True)
    test_date = models.DateTimeField()
    result_date = models.DateTimeField(blank=True, null=True)
    notes = models.TextField(blank=True, null=True)
    file_attachment = models.FileField(upload_to='lab_results/', blank=True, null=True)
    
    class Meta:
        db_table = 'lab_results'
        verbose_name = 'Resultado de Laboratorio'
        verbose_name_plural = 'Resultados de Laboratorio'
        ordering = ['-test_date']
    
    def __str__(self):
        return f"{self.test_name} - {self.result_value} - {self.test_date.date()}"


class ImagingResult(models.Model):
    """
    Modelo para resultados de imagenología
    """
    IMAGING_TYPE_CHOICES = [
        ('xray', 'Radiografía'),
        ('ct', 'Tomografía Computada'),
        ('mri', 'Resonancia Magnética'),
        ('ultrasound', 'Ultrasonido'),
        ('mammography', 'Mamografía'),
        ('pet', 'PET Scan'),
        ('bone_scan', 'Gammagrafía Ósea'),
    ]
    
    medical_record = models.ForeignKey(MedicalRecord, on_delete=models.CASCADE, related_name='imaging_results')
    imaging_type = models.CharField(max_length=20, choices=IMAGING_TYPE_CHOICES)
    body_part = models.CharField(max_length=100)
    findings = models.TextField()
    impression = models.TextField()
    radiologist = models.CharField(max_length=200, blank=True, null=True)
    imaging_date = models.DateTimeField()
    report_date = models.DateTimeField(blank=True, null=True)
    images = models.JSONField(blank=True, null=True, help_text="URLs de imágenes en formato JSON")
    file_attachment = models.FileField(upload_to='imaging_results/', blank=True, null=True)
    
    class Meta:
        db_table = 'imaging_results'
        verbose_name = 'Resultado de Imagenología'
        verbose_name_plural = 'Resultados de Imagenología'
        ordering = ['-imaging_date']
    
    def __str__(self):
        return f"{self.get_imaging_type_display()} - {self.body_part} - {self.imaging_date.date()}"


class Prescription(models.Model):
    """
    Modelo para recetas médicas
    """
    medical_record = models.ForeignKey(MedicalRecord, on_delete=models.CASCADE, related_name='prescriptions')
    medication_name = models.CharField(max_length=200)
    dosage = models.CharField(max_length=100)
    frequency = models.CharField(max_length=100)
    duration = models.CharField(max_length=100)
    instructions = models.TextField(blank=True, null=True)
    quantity = models.PositiveIntegerField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    prescribed_date = models.DateTimeField(auto_now_add=True)
    start_date = models.DateField(blank=True, null=True)
    end_date = models.DateField(blank=True, null=True)
    
    class Meta:
        db_table = 'prescriptions'
        verbose_name = 'Receta'
        verbose_name_plural = 'Recetas'
        ordering = ['-prescribed_date']
    
    def __str__(self):
        return f"{self.medication_name} - {self.dosage} - {self.prescribed_date.date()}"
