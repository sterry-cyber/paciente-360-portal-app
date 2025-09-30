from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from apps.patients.models import Patient
from apps.doctors.models import Doctor
from datetime import date

User = get_user_model()


class Command(BaseCommand):
    help = 'Crear usuarios STERRY y WAYMARA con credenciales de login'

    def handle(self, *args, **options):
        self.stdout.write(
            self.style.SUCCESS('🏥 Creando usuarios para Paciente 360...')
        )
        self.stdout.write('=' * 50)
        
        # Usuario STERRY (Paciente)
        sterry_user, created = User.objects.get_or_create(
            email='sterry@paciente360.com',
            defaults={
                'username': 'sterry',
                'first_name': 'STERRY',
                'last_name': 'PACIENTE',
                'phone': '+52 55 1234 5678',
                'role': 'patient',
                'is_verified': True,
                'is_active': True,
            }
        )
        
        if created:
            sterry_user.set_password('sterry123')
            sterry_user.save()
            self.stdout.write(
                self.style.SUCCESS('✅ Usuario STERRY creado exitosamente')
            )
        else:
            self.stdout.write(
                self.style.WARNING('ℹ️ Usuario STERRY ya existe')
            )
        
        # Crear perfil de paciente para STERRY
        sterry_patient, created = Patient.objects.get_or_create(
            user=sterry_user,
            defaults={
                'date_of_birth': date(1990, 5, 15),
                'gender': 'M',
                'blood_type': 'O+',
                'emergency_contact_name': 'María González',
                'emergency_contact_phone': '+52 55 9876 5432',
                'address': 'Av. Reforma 123, Ciudad de México',
                'allergies': 'Penicilina',
                'medical_conditions': 'Ninguna',
                'medications': 'Ninguno',
                'insurance_provider': 'Seguro Popular',
                'insurance_number': 'SP123456789',
            }
        )
        
        if created:
            self.stdout.write(
                self.style.SUCCESS('✅ Perfil de paciente STERRY creado exitosamente')
            )
        else:
            self.stdout.write(
                self.style.WARNING('ℹ️ Perfil de paciente STERRY ya existe')
            )
        
        # Usuario WAYMARA (Doctor)
        waymara_user, created = User.objects.get_or_create(
            email='waymara@paciente360.com',
            defaults={
                'username': 'waymara',
                'first_name': 'WAYMARA',
                'last_name': 'DOCTOR',
                'phone': '+52 55 2468 1357',
                'role': 'doctor',
                'is_verified': True,
                'is_active': True,
            }
        )
        
        if created:
            waymara_user.set_password('waymara123')
            waymara_user.save()
            self.stdout.write(
                self.style.SUCCESS('✅ Usuario WAYMARA creado exitosamente')
            )
        else:
            self.stdout.write(
                self.style.WARNING('ℹ️ Usuario WAYMARA ya existe')
            )
        
        # Crear perfil de doctor para WAYMARA
        waymara_doctor, created = Doctor.objects.get_or_create(
            user=waymara_user,
            defaults={
                'license_number': 'DOC123456',
                'specialty': 'general',
                'years_experience': 8,
                'education': 'Universidad Nacional Autónoma de México - Medicina General',
                'certifications': 'Certificación en Medicina Interna',
                'languages': 'Español, Inglés',
                'consultation_fee': 500.00,
                'is_available': True,
                'consultation_duration': 30,
                'bio': 'Doctora especializada en medicina general con más de 8 años de experiencia.',
            }
        )
        
        if created:
            self.stdout.write(
                self.style.SUCCESS('✅ Perfil de doctor WAYMARA creado exitosamente')
            )
        else:
            self.stdout.write(
                self.style.WARNING('ℹ️ Perfil de doctor WAYMARA ya existe')
            )
        
        self.stdout.write('\n' + '=' * 50)
        self.stdout.write(self.style.HTTP_INFO('📋 CREDENCIALES DE LOGIN'))
        self.stdout.write('=' * 50)
        self.stdout.write(self.style.HTTP_INFO('👤 PACIENTE STERRY:'))
        self.stdout.write('   Email: sterry@paciente360.com')
        self.stdout.write('   Contraseña: sterry123')
        self.stdout.write('   Rol: Paciente')
        self.stdout.write('')
        self.stdout.write(self.style.HTTP_INFO('👩‍⚕️ DOCTOR WAYMARA:'))
        self.stdout.write('   Email: waymara@paciente360.com')
        self.stdout.write('   Contraseña: waymara123')
        self.stdout.write('   Rol: Doctor')
        self.stdout.write('=' * 50)
        self.stdout.write('')
        self.stdout.write(
            self.style.SUCCESS('🎉 ¡Usuarios creados exitosamente!')
        )
        self.stdout.write(
            self.style.SUCCESS('Ahora puedes usar estas credenciales para hacer login en la aplicación.')
        )
