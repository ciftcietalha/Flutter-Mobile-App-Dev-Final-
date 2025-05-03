class Employee {
  final String name;
  final String position;
  final String secretary;
  final String phone;
  final String fax;
  final String email;
  final String pictureUrl;

  Employee({
    required this.name,
    required this.position,
    required this.secretary,
    required this.phone,
    required this.fax,
    required this.email,
    required this.pictureUrl,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'] ?? 'Unknown', // Default to 'Unknown' if not found
      position: json['position'] ?? 'N/A', // Default to 'N/A' if not found
      secretary: json['secretary'] ?? 'N/A', // Default to 'N/A' if not found
      phone: json['phone'] ?? 'N/A', // Default to 'N/A' if not found
      fax: json['fax'] ?? 'N/A', // Default to 'N/A' if not found
      email: json['email'] ?? 'N/A', // Default to 'N/A' if not found
      pictureUrl: json['pictureUrl'] ?? '', // Default to empty string if not found
    );
  }
}