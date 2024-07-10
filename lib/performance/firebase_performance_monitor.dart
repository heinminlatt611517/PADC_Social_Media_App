import 'package:firebase_performance/firebase_performance.dart';

/// Trace Names
const String addNewPostTrace = "add_new_post_trace";

class FirebasePerformanceMonitor {
  static final FirebasePerformanceMonitor _singleton =
      FirebasePerformanceMonitor._internal();

  factory FirebasePerformanceMonitor() {
    return _singleton;
  }

  FirebasePerformanceMonitor._internal();

  /// Trace
  final Trace performanceTrace =
      FirebasePerformance.instance.newTrace(addNewPostTrace);

  void startTrace() async {
    await performanceTrace.start();
  }

  void stopTrace() async {
    await performanceTrace.stop();
  }
}
