import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cred_flutter_assignment/core/models/card_model.dart';
import 'package:cred_flutter_assignment/core/errors/api_errors.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static Future<List<CardItem>> fetchCards({required bool small}) async {
    final url = small
        ? 'https://api.mocklets.com/p26/mock1'
        : 'https://api.mocklets.com/p26/mock2';

    // Use mock data directly for web to avoid CORS issues
    if (kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      return _getMockData(small);
    }
    
    try {
      final resp = await http.get(Uri.parse(url));
      
      switch (resp.statusCode) {
        case 200:
          final data = json.decode(resp.body);
          if (data is Map && data['template_properties']?['child_list'] != null) {
            final childList = data['template_properties']['child_list'] as List;
            return childList.map((e) => CardItem.fromJson(e)).toList();
          }
          throw const ParseError();
        case 401:
          throw const UnauthorizedError();
        case 404:
          throw const NotFoundError();
        default:
          throw ServerError(resp.statusCode);
      }
    } catch (e) {
      // Fallback to mock data if API fails
      return _getMockData(small);
    }
  }
  
  static List<CardItem> _getMockData(bool small) {
    final mockData = small ? _smallMockData : _largeMockData;
    return mockData.map((e) => CardItem.fromJson({
      'external_id': e['id'],
      'template_properties': {
        'body': {
          'title': e['title'],
          'sub_title': e['subtitle'],
          'payment_amount': e['amount'],
          'logo': {'url': e['image']},
          'footer_text': e['footer'],
          if (e['flipper'] == true) 'flipper_config': {
            'items': [
              {'text': e['flipText1'] ?? 'GET CASHBACK'},
              {'text': e['flipText2'] ?? 'DUE TODAY'}
            ]
          }
        }
      }
    })).toList();
  }
  
  static const _smallMockData = [
    {
      "id": "1",
      "title": "VIL",
      "subtitle": "Miss Blake Murazik",
      "amount": "₹200",
      "image": "https://picsum.photos/400/600?random=1",
      "footer": "due today",
      "flipper": false
    },
    {
      "id": "2", 
      "title": "HDFC Bank",
      "subtitle": "XXXX XXXX 6582",
      "amount": "₹45,000",
      "image": "https://picsum.photos/400/600?random=2",
      "flipper": true,
      "flipText1": "GET 1% BACK AS GOLD UPTO ₹200",
      "flipText2": "DUE TODAY"
    }
  ];
  
  static const _largeMockData = [ // 9 items for vertical carousel
    {
      "id": "1",
      "title": "SBI",
      "subtitle": "XXXX XXXX 1236",
      "amount": "₹2,15,705",
      "image": "https://picsum.photos/400/600?random=1",
      "footer": "OVERDUE",
      "flipper": false
    },
    {
      "id": "2",
      "title": "HDFC Bank",
      "subtitle": "XXXX XXXX 6582",
      "amount": "₹45,000",
      "image": "https://picsum.photos/400/600?random=2",
      "flipper": true,
      "flipText1": "GET 1% BACK AS GOLD UPTO ₹200",
      "flipText2": "DUE TODAY"
    },
    {
      "id": "3",
      "title": "VIL",
      "subtitle": "Miss Blake Murazik",
      "amount": "₹200",
      "image": "https://picsum.photos/400/600?random=3",
      "footer": "due today",
      "flipper": false
    },
    {
      "id": "4",
      "title": "BESCOM",
      "subtitle": "Kurt Orn",
      "amount": "₹200",
      "image": "https://picsum.photos/400/600?random=4",
      "flipper": true,
      "flipText1": "Get 5% off on UPI payments",
      "flipText2": "DUE"
    },
    {
      "id": "5",
      "title": "AIRTEL POSTPAID",
      "subtitle": "Rajinder Kaur",
      "amount": "₹1,94,000",
      "image": "https://picsum.photos/400/600?random=5",
      "flipper": true,
      "flipText1": "Get 5% off on UPI payments",
      "flipText2": "DUE IN 3 DAYS"
    },
    {
      "id": "6",
      "title": "HDFC Bank",
      "subtitle": "XXXX XXXX 5948",
      "amount": "₹45,000",
      "image": "https://picsum.photos/400/600?random=6",
      "flipper": true,
      "flipText1": "Get 5% off on UPI payments",
      "flipText2": "DUE TODAY"
    },
    {
      "id": "7",
      "title": "HDFC Bank",
      "subtitle": "XXXX XXXX 3126",
      "amount": "₹45,000",
      "image": "https://picsum.photos/400/600?random=7",
      "footer": "DUE TODAY",
      "flipper": false
    },
    {
      "id": "8",
      "title": "SBI",
      "subtitle": "XXXX XXXX 1111",
      "amount": "₹2,15,705",
      "image": "https://picsum.photos/400/600?random=8",
      "flipper": true,
      "flipText1": "Get 5% off on UPI payments",
      "flipText2": "OVERDUE"
    },
    {
      "id": "9",
      "title": "SBI",
      "subtitle": "XXXX XXXX 1211",
      "amount": "₹2,15,405",
      "image": "https://picsum.photos/400/600?random=9",
      "flipper": true,
      "flipText1": "Get 5% off on UPI payments",
      "flipText2": "OVERDUE"
    }
  ];
}
