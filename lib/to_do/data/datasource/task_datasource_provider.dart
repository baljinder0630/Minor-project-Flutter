import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasource/datasource.dart';

final taskDatasourceProvider = Provider<TaskDatasource>((ref) {
  return TaskDatasource();
});
