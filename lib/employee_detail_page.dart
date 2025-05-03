import 'package:flutter/material.dart';
import 'employee.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Employee employee;

  EmployeeDetailPage({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(employee.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${employee.name}', style: TextStyle(fontSize: 20)),
            Text('Position: ${employee.position}', style: TextStyle(fontSize: 20)),
            Text('Secretary: ${employee.secretary}', style: TextStyle(fontSize: 20)),
            Text('Phone: ${employee.phone}', style: TextStyle(fontSize: 20)),
            Text('Fax: ${employee.fax}', style: TextStyle(fontSize: 20)),
            Text('Email: ${employee.email}', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}