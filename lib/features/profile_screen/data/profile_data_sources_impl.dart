import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app/features/profile_screen/data/profile_-models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_data_sources.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ProfileRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      'Content-Type': 'application/json',
      'token': token,
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<UserModel> getProfile() async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/profile'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data['data'] ?? data['user'] ?? data);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {
    final headers = await _getHeaders();
    final response = await client.put(
      Uri.parse('$baseUrl/profile'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'avatarId': avatarIndex,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  @override
  Future<void> deleteAccount() async {
    final headers = await _getHeaders();
    final response = await client.delete(
      Uri.parse('$baseUrl/profile'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete account');
    }
  }

  @override
  Future<List<ProfileMovieModel>> getWatchList() async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/watchlist'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['data'] ?? data['movies'] ?? [];
      return list.map((item) => ProfileMovieModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load watchlist');
    }
  }
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String _historyKey = 'user_history_movies';

  @override
  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  @override
  Future<List<ProfileMovieModel>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_historyKey) ?? [];
    return historyJson
        .map((item) => ProfileMovieModel.fromJson(jsonDecode(item)))
        .toList();
  }

  @override
  Future<void> saveToHistory(ProfileMovieModel movie) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyJson = prefs.getStringList(_historyKey) ?? [];

    historyJson.removeWhere((item) {
      final decoded = jsonDecode(item);
      return decoded['id'] == movie.id;
    });

    historyJson.insert(0, jsonEncode(movie.toJson()));

    if (historyJson.length > 20) {
      historyJson = historyJson.sublist(0, 20);
    }

    await prefs.setStringList(_historyKey, historyJson);
  }
}