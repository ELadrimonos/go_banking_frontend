
class User {
  final String dni;
  final String fullName;
  final String email;

  User({
    required this.dni,
    required this.fullName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      dni: json['dni'],
      fullName: json['full_name'],
      email: json['email'],
    );
  }
}
