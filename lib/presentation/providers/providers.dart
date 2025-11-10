import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/card_model.dart';
import '../../data/api/api_service.dart';

final cardsProvider = FutureProvider.family<List<CardItem>, bool>((ref, small) {
  return ApiService.fetchCards(small: small);
});
