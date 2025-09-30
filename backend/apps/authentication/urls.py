from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView
from . import views

urlpatterns = [
    # Autenticación
    path('login/', views.CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('simple-login/', views.simple_login, name='simple_login'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('register/', views.UserRegistrationView.as_view(), name='user_registration'),
    path('logout/', views.logout, name='logout'),
    
    # Perfil de usuario
    path('profile/', views.UserProfileView.as_view(), name='user_profile'),
    path('update/', views.UserUpdateView.as_view(), name='user_update'),
    path('change-password/', views.change_password, name='change_password'),
    path('me/', views.user_info, name='user_info'),
]
