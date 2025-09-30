class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String phone;
  final String role;
  final bool isVerified;
  final DateTime dateJoined;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.isVerified,
    required this.dateJoined,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'patient',
      isVerified: json['is_verified'] ?? false,
      dateJoined: DateTime.parse(json['date_joined'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'phone': phone,
      'role': role,
      'is_verified': isVerified,
      'date_joined': dateJoined.toIso8601String(),
    };
  }
}