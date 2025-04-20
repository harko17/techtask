import 'package:supabase_flutter/supabase_flutter.dart';
import '../dashboard/task_model.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<List<Task>> fetchTasks() async {
    final response = await _client.from('tasks').select().order('id', ascending: false);
    return response.map((t) => Task.fromMap(t)).toList();
  }
  final userId = Supabase.instance.client.auth.currentUser!.id;
  Future<void> addTask(String title, String detail) async {
    await _client.from('tasks').insert({'title': title,'detail': detail, 'completed': false,'user_id': userId,});
  }
  Future<void> updateTask(int taskId, String newTitle, String newDetail) async {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    final response = await _client
        .from('tasks')
        .update({
      'title': newTitle,
      'detail': newDetail,
    })
        .eq('id', taskId)
        .eq('user_id', userId); // ensures only the current user's task is updated

    if (response.error != null) {
      throw Exception('Failed to update task: ${response.error!.message}');
    }
  }

  Future<void> deleteTask(int id) async {
    await _client.from('tasks').delete().eq('id', id);
  }

  Future<void> toggleTask(int id, bool completed) async {
    await _client.from('tasks').update({'completed': completed}).eq('id', id);
  }
}
