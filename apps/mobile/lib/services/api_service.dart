import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080';
  
  String? _jwtToken;

  void _loadToken() {
    // For now, token is stored in memory only
  }

  Future<void> _saveToken(String token) async {
    // For now, token is stored in memory only
    _jwtToken = token;
  }

  Future<void> clearToken() async {
    // For now, token is stored in memory only
    _jwtToken = null;
  }

  Map<String, String> _getHeaders({bool requireAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    
    if (requireAuth && _jwtToken != null) {
      headers['Authorization'] = 'Bearer $_jwtToken';
    }
    
    return headers;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body, {bool requireAuth = false}) async {
    _loadToken();
    final url = Uri.parse('$baseUrl$endpoint');
    return http.post(url, headers: _getHeaders(requireAuth: requireAuth), body: jsonEncode(body));
  }

  Future<http.Response> get(String endpoint, {bool requireAuth = true}) async {
    _loadToken();
    final url = Uri.parse('$baseUrl$endpoint');
    return http.get(url, headers: _getHeaders(requireAuth: requireAuth));
  }

  Future<http.Response> patch(String endpoint, Map<String, dynamic> body) async {
    _loadToken();
    final url = Uri.parse('$baseUrl$endpoint');
    return http.patch(url, headers: _getHeaders(requireAuth: true), body: jsonEncode(body));
  }

  Future<http.Response> delete(String endpoint) async {
    _loadToken();
    final url = Uri.parse('$baseUrl$endpoint');
    return http.delete(url, headers: _getHeaders(requireAuth: true));
  }

  // Auth endpoints
  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    final response = await post('/api/v1/auth/register', {
      'email': email,
      'password': password,
      'name': name,
    });

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['token'] != null) {
        await _saveToken(data['token']);
      }
      return data;
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await post('/api/v1/auth/login', {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['token'] != null) {
        await _saveToken(data['token']);
      }
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  // User endpoints
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await get('/api/v1/users/me');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getUserById(String id) async {
    final response = await get('/api/v1/users/$id');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> updates) async {
    final response = await patch('/api/v1/users/me', updates);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  // Graph endpoints
  Future<Map<String, dynamic>> getKinScore(String targetId) async {
    final response = await get('/api/v1/graph/kin-score/$targetId');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get kin score: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> requestKinnection(String targetId) async {
    final response = await post('/api/v1/graph/kinnections', {'targetId': targetId});
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to request kinnection: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> confirmKinnection(String kinnectionId) async {
    final response = await patch('/api/v1/graph/kinnections/$kinnectionId/confirm', {});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to confirm kinnection: ${response.body}');
    }
  }

  // Feed endpoints
  Future<List<dynamic>> getLineFeed() async {
    final response = await get('/api/v1/feed/line');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['memories'] ?? [];
    } else {
      throw Exception('Failed to get line feed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> postMemory(String content, {String? mediaUrl}) async {
    final body = <String, dynamic>{'content': content};
    if (mediaUrl != null) {
      body['mediaUrl'] = mediaUrl;
    }
    final response = await post('/api/v1/feed/memories', body);
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post memory: ${response.body}');
    }
  }

  Future<void> pulseMemory(String memoryId) async {
    final response = await post('/api/v1/feed/memories/$memoryId/pulse', {});
    if (response.statusCode != 200) {
      throw Exception('Failed to pulse memory: ${response.body}');
    }
  }

  // DNA endpoints
  Future<Map<String, dynamic>> submitDnaKit(String kitCode) async {
    final response = await post('/api/v1/dna/kit', {'kitCode': kitCode});
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit DNA kit: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getDnaStatus() async {
    final response = await get('/api/v1/dna/status');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get DNA status: ${response.body}');
    }
  }

  // Media endpoints
  Future<Map<String, dynamic>> getUploadToken() async {
    final response = await post('/api/v1/media/upload-token', {});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get upload token: ${response.body}');
    }
  }
}
