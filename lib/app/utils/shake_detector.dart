import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector {
  final void Function() onShake;
  final double threshold;
  final Duration debounce;

  DateTime? _lastShakeTime;
  StreamSubscription<AccelerometerEvent>? _subscription;

  ShakeDetector({
    required this.onShake,
    this.threshold = 15.0,
    this.debounce = const Duration(seconds: 2),
  });

  void startListening() {
    _subscription = accelerometerEvents.listen((event) {
      final acc = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      final now = DateTime.now();
      if (acc > threshold) {
        if (_lastShakeTime == null || now.difference(_lastShakeTime!) > debounce) {
          _lastShakeTime = now;
          onShake();
        }
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
  }
}
