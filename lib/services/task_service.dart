import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';

class TaskService {
  final SupabaseClient _client;

  TaskService(this._client);

  Future<List<Task>> getTasks() async {
    final response = await _client
        .from('tasks')
        .select('*')
        .order('created_at', ascending: true);
    return (response as List).map((e) => Task.fromMap(e)).toList();
  }

  Stream<List<Task>> streamTasks() {
    return _client
        .from('tasks')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .map((events) => events.map((e) => Task.fromMap(e)).toList());
  }

  Future<Task> addTask(String title, {String? description}) async {
    final response = await _client.from('tasks').insert({
      'title': title,
      'description': description,
    }).select() as List;
    return Task.fromMap(response.single as Map<String, dynamic>);
  }

  Future<void> toggleCompletion(String id, bool isCompleted) async {
    await _client
        .from('tasks')
        .update({'is_completed': isCompleted})
        .eq('id', id);
  }

  Future<void> updateTask(
    String id, {
    String? title,
    String? description,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (data.isNotEmpty) {
      await _client.from('tasks').update(data).eq('id', id);
    }
  }

  Future<void> deleteTask(String id) async {
    await _client.from('tasks').delete().eq('id', id);
  }
}
