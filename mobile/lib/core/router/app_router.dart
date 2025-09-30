import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/auth_provider.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/patient/patient_dashboard_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAuthenticated = authProvider.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      // Si no está autenticado y no está en login/register, redirigir a login
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      // Si está autenticado y está en login/register, redirigir según rol
      if (isAuthenticated && isLoggingIn) {
        final user = authProvider.user;
        if (user?.role == 'patient') {
          return '/patient-dashboard';
        } else if (user?.role == 'doctor') {
          return '/doctor-dashboard';
        } else if (user?.role == 'admin') {
          return '/admin-dashboard';
        }
      }

      return null;
    },
    routes: [
      // Rutas de autenticación
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Rutas de pacientes
      GoRoute(
        path: '/patient-dashboard',
        name: 'patient-dashboard',
        builder: (context, state) => const PatientDashboardScreen(),
      ),
      
      // Rutas de doctores
      GoRoute(
        path: '/doctor-dashboard',
        name: 'doctor-dashboard',
        builder: (context, state) => const _PlaceholderScreen(title: 'Dashboard Doctor'),
      ),
      
      // Rutas de administrador
      GoRoute(
        path: '/admin-dashboard',
        name: 'admin-dashboard',
        builder: (context, state) => const _PlaceholderScreen(title: 'Dashboard Administrador'),
      ),
      
      // Rutas compartidas
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const _PlaceholderScreen(title: 'Notificaciones'),
      ),
      GoRoute(
        path: '/new-appointment',
        name: 'new-appointment',
        builder: (context, state) => const _PlaceholderScreen(title: 'Nueva Cita'),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'La página que buscas no existe',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Esta funcionalidad estará disponible próximamente',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}