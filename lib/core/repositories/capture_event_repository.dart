import 'package:reis/core/models/capture_event.dart';

abstract class CaptureEventRepository {
  Future<void> save(CaptureEvent event);
  Future<CaptureEvent?> findById(String id);
  Future<List<CaptureEvent>> findAll();
  Future<List<CaptureEvent>> findByTimeRange(
    DateTime start,
    DateTime end,
  );
  Future<List<CaptureEvent>> findByIds(List<String> ids);
  Future<void> delete(String id);
}
