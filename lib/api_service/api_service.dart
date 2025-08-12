
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mindflow_mood_tracker_app_with_firebase/model/quote_model.dart';

class ApiService {

  static const String baseUrl = 'https://api.realinspire.live/v1/';

  static String? get currentUid => FirebaseAuth.instance.currentUser?.uid;

  static Future<List<QuoteModel>> fetchAllQuotes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/quotes'));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> data = json['results'];
        return data.map((i) => QuoteModel.fromJson(i,currentUid??'')).toList();
      }
      else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<QuoteModel>> fetchRandomQuote()async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/quotes/random'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((i) => QuoteModel.fromJson(i,currentUid??'')).toList();
      }
      else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      throw e.toString();
    }
  }
}