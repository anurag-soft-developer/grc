import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get appName => dotenv.env['APP_NAME'] ?? 'GRC';
  static String get baseApiUrl => dotenv.env['BASE_API_URL'] ?? '';
  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';

  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
    _validateRequiredVariables();
  }

  static void _validateRequiredVariables() {
    final missing = <String>[];
    if (baseApiUrl.isEmpty) missing.add('BASE_API_URL');
    if (appName.isEmpty) missing.add('APP_NAME');
    if (missing.isNotEmpty) {
      throw Exception(
        'Missing required environment variables: ${missing.join(', ')}',
      );
    }
  }
}
