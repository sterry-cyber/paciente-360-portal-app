from rest_framework import generics, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import Doctor, DoctorSchedule
from .serializers import DoctorSerializer

class DoctorListCreateView(generics.ListCreateAPIView):
    queryset = Doctor.objects.all()
    serializer_class = DoctorSerializer
    permission_classes = [IsAuthenticated]

class DoctorDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Doctor.objects.all()
    serializer_class = DoctorSerializer
    permission_classes = [IsAuthenticated]

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def doctor_profile(request):
    try:
        doctor = Doctor.objects.get(user=request.user)
        serializer = DoctorSerializer(doctor)
        return Response(serializer.data)
    except Doctor.DoesNotExist:
        return Response(
            {'error': 'Perfil de doctor no encontrado'},
            status=status.HTTP_404_NOT_FOUND
        )

class DoctorScheduleView(generics.ListCreateAPIView):
    queryset = DoctorSchedule.objects.all()
    serializer_class = DoctorSerializer
    permission_classes = [IsAuthenticated]
