import 'package:logger/logger.dart';

class LoggerService {
  static final Logger _logger = Logger();

  static void logError(String message) {
    _logger.e(message);
  }

  static void logDebug(String message) {
    _logger.d(message);
  }

  static void logInfo(String message) {
    _logger.i(message); // Info level log
  }
}
