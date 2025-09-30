import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/custom_button.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _DoctorHomeTab(),
    const _DoctorAppointmentsTab(),
    const _DoctorPatientsTab(),
    const _DoctorScheduleTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            const AppLogoSmall(
              size: 32,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Dr. ${user?.firstName ?? 'Usuario'}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.go('/notifications'),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                authProvider.logout();
                context.go('/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Cerrar Sesión'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.secondaryColor,
        unselectedItemColor: AppTheme.mediumGray,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outlined),
            activeIcon: Icon(Icons.people),
            label: 'Pacientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule_outlined),
            activeIcon: Icon(Icons.schedule),
            label: 'Horario',
          ),
        ],
      ),
    );
  }
}

class _DoctorHomeTab extends StatelessWidget {
  const _DoctorHomeTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen del día
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.today, color: AppTheme.secondaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Resumen del Día',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Citas Hoy',
                          value: '8',
                          icon: Icons.calendar_today,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Pacientes',
                          value: '12',
                          icon: Icons.people,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Pendientes',
                          value: '3',
                          icon: Icons.pending,
                          color: AppTheme.warningColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Completadas',
                          value: '5',
                          icon: Icons.check_circle,
                          color: AppTheme.successColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Próximas citas
          Text(
            'Próximas Citas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          _AppointmentCard(
            patientName: 'María González',
            time: '09:00 AM',
            type: 'Consulta General',
            status: 'Confirmada',
            statusColor: AppTheme.successColor,
          ),
          const SizedBox(height: 8),
          _AppointmentCard(
            patientName: 'Carlos Rodríguez',
            time: '09:30 AM',
            type: 'Seguimiento',
            status: 'En espera',
            statusColor: AppTheme.warningColor,
          ),
          const SizedBox(height: 8),
          _AppointmentCard(
            patientName: 'Ana Martínez',
            time: '10:00 AM',
            type: 'Consulta General',
            status: 'Confirmada',
            statusColor: AppTheme.successColor,
          ),
          
          const SizedBox(height: 20),
          
          // Acciones rápidas
          Text(
            'Acciones Rápidas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Nueva Cita',
                  onPressed: () => context.go('/new-appointment'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Ver Pacientes',
                  onPressed: () => context.go('/doctor-dashboard/patients'),
                  backgroundColor: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String patientName;
  final String time;
  final String type;
  final String status;
  final Color statusColor;

  const _AppointmentCard({
    required this.patientName,
    required this.time,
    required this.type,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    type,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Tabs funcionales para el doctor
class _DoctorAppointmentsTab extends StatelessWidget {
  const _DoctorAppointmentsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestión de Citas',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Filtros
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Hoy',
                    onPressed: () {},
                    backgroundColor: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: 'Esta Semana',
                    onPressed: () {},
                    backgroundColor: AppTheme.backgroundColor,
                    textColor: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: 'Este Mes',
                    onPressed: () {},
                    backgroundColor: AppTheme.backgroundColor,
                    textColor: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Lista de citas
            ...List.generate(5, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _AppointmentCard(
                patientName: 'Paciente ${index + 1}',
                time: '${9 + index}:00 AM',
                type: 'Consulta General',
                status: index % 2 == 0 ? 'Confirmada' : 'Pendiente',
                statusColor: index % 2 == 0 ? AppTheme.successColor : AppTheme.warningColor,
              ),
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/new-appointment'),
        backgroundColor: AppTheme.secondaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _DoctorPatientsTab extends StatelessWidget {
  const _DoctorPatientsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mis Pacientes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Búsqueda
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar paciente...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppTheme.backgroundColor,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Lista de pacientes
            ...List.generate(8, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      'P${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('Paciente ${index + 1}'),
                  subtitle: Text('Última visita: ${DateTime.now().subtract(Duration(days: index * 7)).day}/${DateTime.now().month}'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navegar a detalles del paciente
                  },
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _DoctorScheduleTab extends StatelessWidget {
  const _DoctorScheduleTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mi Horario',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Horario semanal
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Horario Semanal',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ...['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'].map((day) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                day,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '08:00 AM - 05:00 PM',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Configuración de horarios
            CustomButton(
              text: 'Configurar Horario',
              onPressed: () {},
              backgroundColor: AppTheme.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
