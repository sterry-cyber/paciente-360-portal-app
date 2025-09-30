from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .models import Appointment, VirtualQueue
from .serializers import AppointmentSerializer

class AppointmentListCreateView(generics.ListCreateAPIView):
    queryset = Appointment.objects.all()
    serializer_class = AppointmentSerializer
    permission_classes = [IsAuthenticated]

class AppointmentDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Appointment.objects.all()
    serializer_class = AppointmentSerializer
    permission_classes = [IsAuthenticated]

class PatientAppointmentsView(generics.ListAPIView):
    serializer_class = AppointmentSerializer
    permission_classes = [IsAuthenticated]

class DoctorAppointmentsView(generics.ListAPIView):
    serializer_class = AppointmentSerializer
    permission_classes = [IsAuthenticated]

class VirtualQueueView(generics.ListCreateAPIView):
    queryset = VirtualQueue.objects.all()
    serializer_class = AppointmentSerializer
    permission_classes = [IsAuthenticated]
