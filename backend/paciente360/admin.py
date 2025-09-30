from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from apps.authentication.models import User
from apps.patients.models import Patient
from apps.doctors.models import Doctor, DoctorSchedule
from apps.appointments.models import Appointment, AppointmentReminder, VirtualQueue
from apps.medical_records.models import MedicalRecord, LabResult, ImagingResult, Prescription
from apps.notifications.models import Notification, NotificationTemplate, NotificationSettings


@admin.register(User)
class CustomUserAdmin(UserAdmin):
    list_display = ('email', 'first_name', 'last_name', 'role', 'is_verified', 'date_joined')
    list_filter = ('role', 'is_verified', 'is_staff', 'is_active', 'date_joined')
    search_fields = ('email', 'first_name', 'last_name', 'username')
    ordering = ('-date_joined',)
    
    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        ('Información Personal', {'fields': ('first_name', 'last_name', 'email', 'phone')}),
        ('Permisos', {'fields': ('role', 'is_active', 'is_staff', 'is_superuser', 'is_verified')}),
        ('Fechas Importantes', {'fields': ('last_login', 'date_joined')}),
    )
    
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'email', 'first_name', 'last_name', 'password1', 'password2', 'role'),
        }),
    )


@admin.register(Patient)
class PatientAdmin(admin.ModelAdmin):
    list_display = ('user', 'age', 'gender', 'blood_type', 'created_at')
    list_filter = ('gender', 'blood_type', 'created_at')
    search_fields = ('user__first_name', 'user__last_name', 'user__email')
    readonly_fields = ('age', 'created_at', 'updated_at')
    
    fieldsets = (
        ('Información Personal', {
            'fields': ('user', 'date_of_birth', 'gender', 'blood_type')
        }),
        ('Contacto de Emergencia', {
            'fields': ('emergency_contact_name', 'emergency_contact_phone')
        }),
        ('Información Médica', {
            'fields': ('allergies', 'medical_conditions', 'medications')
        }),
        ('Seguro Médico', {
            'fields': ('insurance_provider', 'insurance_number')
        }),
        ('Dirección', {
            'fields': ('address',)
        }),
        ('Fechas', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )


@admin.register(Doctor)
class DoctorAdmin(admin.ModelAdmin):
    list_display = ('user', 'specialty', 'license_number', 'years_experience', 'is_available')
    list_filter = ('specialty', 'is_available', 'created_at')
    search_fields = ('user__first_name', 'user__last_name', 'license_number')
    readonly_fields = ('created_at', 'updated_at')


@admin.register(Appointment)
class AppointmentAdmin(admin.ModelAdmin):
    list_display = ('patient', 'doctor', 'appointment_date', 'status', 'appointment_type')
    list_filter = ('status', 'appointment_type', 'appointment_date')
    search_fields = ('patient__user__first_name', 'doctor__user__first_name')
    date_hierarchy = 'appointment_date'
    readonly_fields = ('created_at', 'updated_at')


@admin.register(MedicalRecord)
class MedicalRecordAdmin(admin.ModelAdmin):
    list_display = ('patient', 'doctor', 'record_type', 'title', 'created_at')
    list_filter = ('record_type', 'is_confidential', 'created_at')
    search_fields = ('patient__user__first_name', 'doctor__user__first_name', 'title')
    date_hierarchy = 'created_at'
    readonly_fields = ('created_at', 'updated_at')


@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ('recipient', 'notification_type', 'title', 'is_read', 'is_sent', 'created_at')
    list_filter = ('notification_type', 'priority', 'is_read', 'is_sent', 'created_at')
    search_fields = ('recipient__first_name', 'recipient__last_name', 'title')
    date_hierarchy = 'created_at'
    readonly_fields = ('created_at', 'updated_at')


# Registrar modelos adicionales
admin.site.register(DoctorSchedule)
admin.site.register(AppointmentReminder)
admin.site.register(VirtualQueue)
admin.site.register(LabResult)
admin.site.register(ImagingResult)
admin.site.register(Prescription)
admin.site.register(NotificationTemplate)
admin.site.register(NotificationSettings)

# Personalizar el sitio de administración
admin.site.site_header = "Paciente 360 - Administración"
admin.site.site_title = "Paciente 360 Admin"
admin.site.index_title = "Panel de Administración"
