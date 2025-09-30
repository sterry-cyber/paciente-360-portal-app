from rest_framework import serializers
from .models import MedicalRecord, LabResult, ImagingResult, Prescription

class MedicalRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = MedicalRecord
        fields = '__all__'

class LabResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = LabResult
        fields = '__all__'

class ImagingResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = ImagingResult
        fields = '__all__'

class PrescriptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Prescription
        fields = '__all__'
