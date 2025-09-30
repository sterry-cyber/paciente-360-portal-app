from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from .models import Patient
from .serializers import PatientSerializer, PatientCreateSerializer
from apps.authentication.models import User


class PatientListCreateView(generics.ListCreateAPIView):
    """
    Vista para listar y crear pacientes
    """
    queryset = Patient.objects.all()
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['gender', 'blood_type']
    search_fields = ['user__first_name', 'user__last_name', 'user__email']
    ordering_fields = ['created_at', 'user__first_name']
    ordering = ['-created_at']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return PatientCreateSerializer
        return PatientSerializer
    
    def perform_create(self, serializer):
        # Crear usuario primero
        user_data = self.request.data
        user = User.objects.create_user(
            username=user_data['email'],
            email=user_data['email'],
            first_name=user_data['first_name'],
            last_name=user_data['last_name'],
            phone=user_data.get('phone'),
            role='patient'
        )
        
        # Crear perfil de paciente
        serializer.save(user=user)


class PatientDetailView(generics.RetrieveUpdateDestroyAPIView):
    """
    Vista para obtener, actualizar y eliminar un paciente específico
    """
    queryset = Patient.objects.all()
    serializer_class = PatientSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        # Los pacientes solo pueden ver su propio perfil
        if self.request.user.role == 'patient':
            return Patient.objects.filter(user=self.request.user)
        # Los doctores y admin pueden ver todos los pacientes
        return Patient.objects.all()


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def patient_profile(request):
    """
    Vista para obtener el perfil del paciente autenticado
    """
    try:
        patient = Patient.objects.get(user=request.user)
        serializer = PatientSerializer(patient)
        return Response(serializer.data)
    except Patient.DoesNotExist:
        return Response(
            {'error': 'Perfil de paciente no encontrado'},
            status=status.HTTP_404_NOT_FOUND
        )


@api_view(['PUT'])
@permission_classes([permissions.IsAuthenticated])
def update_patient_profile(request):
    """
    Vista para actualizar el perfil del paciente autenticado
    """
    try:
        patient = Patient.objects.get(user=request.user)
        serializer = PatientSerializer(patient, data=request.data, partial=True)
        
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Patient.DoesNotExist:
        return Response(
            {'error': 'Perfil de paciente no encontrado'},
            status=status.HTTP_404_NOT_FOUND
        )
