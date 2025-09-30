import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isAuthenticated = false;

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    // Simulación de login exitoso
    await Future.delayed(const Duration(seconds: 1));
    
    _user = UserModel(
      id: 1,
      username: email.split('@')[0],
      email: email,
      firstName: email.split('@')[0].toUpperCase(),
      lastName: 'USUARIO',
      fullName: '${email.split('@')[0].toUpperCase()} USUARIO',
      phone: '+52 55 1234 5678',
      role: email.contains('sterry') ? 'patient' : 'doctor',
      isVerified: true,
      dateJoined: DateTime.now(),
    );
    
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    // Simulación de registro exitoso
    await Future.delayed(const Duration(seconds: 1));
    
    _user = UserModel(
      id: 2,
      username: userData['email'].split('@')[0],
      email: userData['email'],
      firstName: userData['firstName'] ?? 'Nuevo',
      lastName: userData['lastName'] ?? 'Usuario',
      fullName: '${userData['firstName'] ?? 'Nuevo'} ${userData['lastName'] ?? 'Usuario'}',
      phone: userData['phone'] ?? '+52 55 0000 0000',
      role: userData['role'] ?? 'patient',
      isVerified: false,
      dateJoined: DateTime.now(),
    );
    
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}