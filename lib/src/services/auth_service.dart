import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = 'https://salesucre.woosonicpwa.com/api';
  final secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['data']['token'];
        print('responseData: $responseData');
        if (token != null) {
          await secureStorage.write(key: 'jwt', value: token);
        } else {
          throw Exception('Token not found in login response');
        }

        return responseData;
      } else {
        print('Login failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Login failed');
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProfileData() async {
    final url = Uri.parse('$baseUrl/auth/profile');

    final token = await secureStorage.read(key: 'jwt'); // Retrieve the token

    if (token == null) {
      throw Exception('No token found. Please login.'); // Handle missing token
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Use the token in the header
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Full API Response: $responseData');

        final data = responseData['data'];

        if (data is Map<String, dynamic>) {
          // Correct type check!
          return data; // No need for casting if it's already the correct type
        } else if (data is Map<dynamic, dynamic>) {
          // Handle dynamic map
          return data.cast<String, dynamic>(); // Cast if it's a dynamic map
        } else if (data == null) {
          return {}; // Return empty map if data is null
        } else {
          throw Exception('Invalid profile data type received from API: $data');
        }
      } else {
        print(
            'Profile data request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    String? gender,
    int? dobDay,
    int? dobMonth,
    int? dobYear,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      var request = http.MultipartRequest('POST', url)
        ..fields['name'] = name
        ..fields['last_name'] = lastName
        ..fields['phone'] = phone
        ..fields['email'] = email
        ..fields['password'] = password;

      if (gender != null) {
        request.fields['gender'] = gender;
      }

      if (dobDay != null) {
        request.fields['dobDay'] = dobDay.toString();
      }
      if (dobMonth != null) {
        request.fields['dobMonth'] = dobMonth.toString();
      }
      if (dobYear != null) {
        request.fields['dobYear'] = dobYear.toString();
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(responseBody);
      } else {
        print('Registration failed with status code: ${response.statusCode}');
        print('Response body: $responseBody');

        try {
          final errorData = jsonDecode(responseBody);
          final errorMessage = errorData['message'] ?? 'Registration failed';
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception('Registration failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/forgot-password');

    try {
      final response = await http.post(
        url,
        body: {'email': email},
      );

      if (response.statusCode == 200) {
        print('Password reset request sent successfully');
      } else {
        print('Password reset request failed: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Password reset request failed');
      }
    } catch (e) {
      print('Error during password reset request: $e');
      rethrow;
    }
  }
}
