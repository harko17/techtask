import 'package:supabase_flutter/supabase_flutter.dart';
import '../dashboard/task_model.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<List<Task>> fetchTasks() async {
    final response = await _client.from('tasks').select().order('id', ascending: false);
    return response.map((t) => Task.fromMap(t)).toList();
  }
  final userId = Supabase.instance.client.auth.currentUser!.id;
  Future<void> addTask(String title) async {
    await _client.from('tasks').insert({'title': title, 'completed': false,'user_id': userId,});
  }

  Future<void> deleteTask(int id) async {
    await _client.from('tasks').delete().eq('id', id);
  }

  Future<void> toggleTask(int id, bool completed) async {
    await _client.from('tasks').update({'completed': completed}).eq('id', id);
  }
}
