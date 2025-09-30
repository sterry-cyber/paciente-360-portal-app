from rest_framework import status, generics, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from .models import User
from .serializers import (
    CustomTokenObtainPairSerializer,
    UserRegistrationSerializer,
    UserSerializer,
    UserUpdateSerializer,
    ChangePasswordSerializer
)


class CustomTokenObtainPairView(TokenObtainPairView):
    """
    Vista personalizada para obtener tokens JWT
    """
    serializer_class = CustomTokenObtainPairSerializer


class UserRegistrationView(generics.CreateAPIView):
    """
    Vista para registro de nuevos usuarios
    """
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer
    permission_classes = [permissions.AllowAny]
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        
        # Generar tokens JWT para el usuario recién creado
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'user': UserSerializer(user).data,
            'tokens': {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            },
            'message': 'Usuario registrado exitosamente'
        }, status=status.HTTP_201_CREATED)


class UserProfileView(generics.RetrieveUpdateAPIView):
    """
    Vista para obtener y actualizar perfil del usuario
    """
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_object(self):
        return self.request.user


class UserUpdateView(generics.UpdateAPIView):
    """
    Vista para actualizar información del usuario
    """
    serializer_class = UserUpdateSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_object(self):
        return self.request.user


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def change_password(request):
    """
    Vista para cambiar contraseña del usuario
    """
    serializer = ChangePasswordSerializer(data=request.data, context={'request': request})
    if serializer.is_valid():
        user = request.user
        user.set_password(serializer.validated_data['new_password'])
        user.save()
        return Response({'message': 'Contraseña cambiada exitosamente'}, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def logout(request):
    """
    Vista para cerrar sesión (invalidar token)
    """
    try:
        refresh_token = request.data["refresh"]
        token = RefreshToken(refresh_token)
        token.blacklist()
        return Response({'message': 'Sesión cerrada exitosamente'}, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({'error': 'Token inválido'}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def simple_login(request):
    """
    Vista simple para login con email y password
    """
    email = request.data.get('email')
    password = request.data.get('password')
    
    if not email or not password:
        return Response(
            {'error': 'Email y password son requeridos'},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    try:
        user = User.objects.get(email=email)
        if user.check_password(password) and user.is_active:
            refresh = RefreshToken.for_user(user)
            return Response({
                'user': UserSerializer(user).data,
                'tokens': {
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                },
                'message': 'Login exitoso'
            })
        else:
            return Response(
                {'error': 'Credenciales inválidas'},
                status=status.HTTP_401_UNAUTHORIZED
            )
    except User.DoesNotExist:
        return Response(
            {'error': 'Credenciales inválidas'},
            status=status.HTTP_401_UNAUTHORIZED
        )


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def user_info(request):
    """
    Vista para obtener información del usuario autenticado
    """
    serializer = UserSerializer(request.user)
    return Response(serializer.data)
