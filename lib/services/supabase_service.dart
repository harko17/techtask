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
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not authenticated');
    }
  print(taskId.toString()+" "+userId.toString());
    final response = await Supabase.instance.client
        .from('tasks')
        .update({
      'title': newTitle,
      'detail': newDetail,
    })
        .eq('id', taskId)
        .eq('user_id', userId)
        .select(); // Important: add .select() to get updated rows

    if (response.isEmpty) {
      throw Exception('No task found or not authorized to update');
    }

    print('Task updated: $response');
  }


  Future<void> deleteTask(int id) async {
    await _client.from('tasks').delete().eq('id', id);
  }

  Future<void> toggleTask(int id, bool completed) async {
    await _client.from('tasks').update({'completed': completed}).eq('id', id);
  }
}
