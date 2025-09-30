from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .models import MedicalRecord, LabResult, ImagingResult
from .serializers import MedicalRecordSerializer

class MedicalRecordListCreateView(generics.ListCreateAPIView):
    queryset = MedicalRecord.objects.all()
    serializer_class = MedicalRecordSerializer
    permission_classes = [IsAuthenticated]

class MedicalRecordDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = MedicalRecord.objects.all()
    serializer_class = MedicalRecordSerializer
    permission_classes = [IsAuthenticated]

class PatientMedicalRecordsView(generics.ListAPIView):
    serializer_class = MedicalRecordSerializer
    permission_classes = [IsAuthenticated]

class LabResultView(generics.ListCreateAPIView):
    queryset = LabResult.objects.all()
    serializer_class = MedicalRecordSerializer
    permission_classes = [IsAuthenticated]

class ImagingResultView(generics.ListCreateAPIView):
    queryset = ImagingResult.objects.all()
    serializer_class = MedicalRecordSerializer
    permission_classes = [IsAuthenticated]
