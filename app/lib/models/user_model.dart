// Class-kan User wuxuu matalaa xogta user-ka (isticmaalaha)
class User {
  final String id;
  final String name;
  final String email;
  final String gender;

  // Constructor-ka User
  // Waa in dhammaan xogta la keenaa marka User la abuurayo
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
  });

  // Factory method-kan wuxuu JSON uga beddelayaa User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'] ?? 'male',
    );
  }

  // Method-kan wuxuu User object u beddelayaa JSON
  // Waxaa loo adeegsadaa marka xogta backend loo dirayo
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'gender': gender,
    };
  }

  // Method-kan copyWith wuxuu kuu ogolaanayaa
  // inaad wax ka beddesho User adigoon tirtirin kii hore
  User copyWith({
    String? name,
    String? email,
    String? gender,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
    );
  }
}
