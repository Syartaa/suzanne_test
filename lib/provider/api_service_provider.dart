import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
