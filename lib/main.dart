import 'package:ass12/weather_service.dart';
import 'package:ass12/weatherpage.dart';
import 'package:flutter/material.dart';
import 'package:ass12/lib/employee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

// Main Function
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      home: LoginPage(),
    );
  }
}

// Login Page
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');

    if (_usernameController.text == storedUsername &&
        _passwordController.text == storedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmployeesPage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid credentials. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                _usernameController.clear();
                _passwordController.clear();
                Navigator.pop(ctx);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}

// Sign Up Page
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  Future<void> _showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm'),
        content: Text('Do you want to save your details?'),
        actions: [
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('username', _usernameController.text);
              await prefs.setString('password', _passwordController.text);
              await prefs.setString('fullName', _fullNameController.text);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EmployeesPage()),
              );
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              _usernameController.clear();
              _passwordController.clear();
              _fullNameController.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _showConfirmationDialog,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

// Employees Page
class EmployeesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                children: [
                  Image.asset("lib/assets/images/rsu_logo.png", height: 100), // Replace with your logo path
                  FutureBuilder<SharedPreferences>(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        String fullName = snapshot.data?.getString('fullName') ?? '';
                        return Text(fullName, style: TextStyle(color: Colors.white, fontSize: 20));
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Employees'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Weather'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherPage()),
                );
              },
            ),
            ListTile(
              title: Text('Exit'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Optionally, you can add exit functionality here
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome to the Employees Page!'),
      ),
    );
  }
}

// Weather Page
class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Weather'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Current Weather'),
              Tab(text: 'Air Pollution'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CurrentWeatherTab(),
            AirPollutionTab(),
          ],
        ),
      ),
    );
  }
}



// Current Weather Tab
class CurrentWeatherTab extends StatefulWidget {
  @override
  _CurrentWeatherTabState createState() => _CurrentWeatherTabState();
}

class _CurrentWeatherTabState extends State<CurrentWeatherTab> {
  WeatherService weatherService = WeatherService();
  Map<String, dynamic>? currentWeather;
  bool isLoading = true;
  String temperatureUnit = 'Celsius';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentWeather = await weatherService.getCurrentWeather(position.latitude, position.longitude);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print("Error fetching weather data: $e");
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Temperature: ${currentWeather!['main']['temp']}°$temperatureUnit',
            style: TextStyle(fontSize: 24),
          ),
          // Add more weather details here if needed
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                temperatureUnit = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return {'Celsius', 'Fahrenheit'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }
}

