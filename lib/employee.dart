class Employee {
  final int id;
  final String fullName;
  final String username;
  final String email;

  Employee({required this.id, required this.fullName, required this.username, required this.email});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
    );
  }
}