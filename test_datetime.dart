void main() {
  final str = "2026-07-01 18:00:00+00";
  try {
    final parsed = DateTime.parse(str);
    print("Parsed: $parsed");
    print("Is UTC: ${parsed.isUtc}");
    
    final now = DateTime.now();
    print("Now: $now (Local)");
    print("Now UTC: ${now.toUtc()}");
    
    print("Parsed.day: ${parsed.day}");
    print("Now.day (Local): ${now.day}");
    print("Now.toUtc().day: ${now.toUtc().day}");
    
    final localParsed = parsed.toLocal();
    print("Local Parsed: $localParsed");
    print("Local Parsed.day: ${localParsed.day}");
  } catch (e) {
    print("Error parsing: $e");
  }
}
