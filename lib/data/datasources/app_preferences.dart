import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _keyIsFirstLaunch = 'is_first_launch';
  static const String _keyFailedAttempts = 'failed_attempts';
  static const String _keyLockUntil = 'lock_until';

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsFirstLaunch) ?? true;
  }

  static Future<void> setFirstLaunchDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsFirstLaunch, false);
  }

  // App lock methods
  static Future<int> getFailedAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyFailedAttempts) ?? 0;
  }

  static Future<void> setFailedAttempts(int attempts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyFailedAttempts, attempts);
  }

  static Future<void> incrementFailedAttempts() async {
    final currentAttempts = await getFailedAttempts();
    await setFailedAttempts(currentAttempts + 1);
  }

  static Future<void> resetFailedAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFailedAttempts);
    await prefs.remove(_keyLockUntil);
  }

  static Future<DateTime?> getLockUntilTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_keyLockUntil);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  static Future<void> setLockUntilTime(DateTime lockUntil) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLockUntil, lockUntil.millisecondsSinceEpoch);
  }

  static Future<bool> isAppLocked() async {
    final lockUntil = await getLockUntilTime();
    if (lockUntil == null) return false;
    return DateTime.now().isBefore(lockUntil);
  }

  static Duration getLockDuration(int failedAttempts) {
    switch (failedAttempts) {
      case 5:
        return const Duration(minutes: 5);
      case 6:
        return const Duration(minutes: 15);
      case 7:
        return const Duration(minutes: 20);
      case 8:
        return const Duration(minutes: 30);
      case 9:
        return const Duration(minutes: 60);
      default:
        if (failedAttempts > 9) {
          // Lock until next day (24 hours from now)
          return const Duration(days: 1);
        }
        return Duration.zero;
    }
  }

  static Future<void> lockApp(int failedAttempts) async {
    final lockDuration = getLockDuration(failedAttempts);
    final lockUntil = DateTime.now().add(lockDuration);
    await setLockUntilTime(lockUntil);
  }
}
