from rest_framework import serializers
from .models import Patient
from apps.authentication.serializers import UserSerializer


class PatientSerializer(serializers.ModelSerializer):
    """
    Serializador para información de pacientes
    """
    user = UserSerializer(read_only=True)
    age = serializers.ReadOnlyField()
    
    class Meta:
        model = Patient
        fields = [
            'id', 'user', 'date_of_birth', 'gender', 'blood_type',
            'emergency_contact_name', 'emergency_contact_phone',
            'address', 'allergies', 'medical_conditions', 'medications',
            'insurance_provider', 'insurance_number', 'age',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class PatientCreateSerializer(serializers.ModelSerializer):
    """
    Serializador para crear pacientes
    """
    first_name = serializers.CharField(write_only=True)
    last_name = serializers.CharField(write_only=True)
    email = serializers.EmailField(write_only=True)
    phone = serializers.CharField(write_only=True, required=False)
    
    class Meta:
        model = Patient
        fields = [
            'first_name', 'last_name', 'email', 'phone',
            'date_of_birth', 'gender', 'blood_type',
            'emergency_contact_name', 'emergency_contact_phone',
            'address', 'allergies', 'medical_conditions', 'medications',
            'insurance_provider', 'insurance_number'
        ]
    
    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Este correo electrónico ya está registrado.")
        return value
