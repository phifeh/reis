import 'package:reis/core/models/moment.dart';

abstract class MomentRepository {
  Future<void> save(Moment moment);
  Future<Moment?> findById(String id);
  Future<List<Moment>> findAll();
  Future<List<Moment>> findByTimeRange(DateTime start, DateTime end);
  Future<void> delete(String id);
  Future<void> addEventToMoment(
    String momentId,
    String eventId, {
    AssignmentType assignmentType = AssignmentType.auto,
  });
  Future<void> removeEventFromMoment(String momentId, String eventId);
  Future<List<Moment>> findByParentId(String parentId);
}
