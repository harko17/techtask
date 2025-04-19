import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'task_model.dart';
import '../services/supabase_service.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load tasks when the screen is initialized
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  void showAddDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Color(0xFF1B2B3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Create New Task",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Task Title Field
              Text("Task Title", style: TextStyle(color: Colors.white70)),
              SizedBox(height: 6),
              SizedBox(height: 20),

              TextField(
                controller: controller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF2D3E50),
                  hintText: "Enter task",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),

              SizedBox(height: 30),
              Text("Task Details", style: TextStyle(color: Colors.white70)),
              SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF2D3E50),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "This task will be added to your task list.",
                  style: TextStyle(color: Colors.white54),
                ),
              ),

              SizedBox(height: 30),
              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                  onPressed: () async {
                    final taskTitle = controller.text;

                    if (taskTitle.isEmpty) {
                      // Show error message if the title is empty
                      showSnackbar('Task title cannot be empty.');
                      return;
                    }

                    try {
                      await Provider.of<TaskProvider>(context, listen: false)
                          .addTask(taskTitle);
                      Navigator.pop(context);
                    } catch (e) {
                      // Handle any other errors that might occur during task creation
                      showSnackbar('An error occurred: ${e.toString()}');
                    }
                  },
                  child: Text("Create", style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final taskProvider =
        Provider.of<TaskProvider>(context); // Access TaskProvider

    return Scaffold(
      backgroundColor: Color(0xFF0F1D2D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Task Details", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () => auth.signOut(),
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("All Tasks",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: taskProvider.tasks.isEmpty
                  ? Center(
                      child: Text('No tasks available',
                          style: TextStyle(color: Colors.white70)))
                  : ListView.builder(
                      itemCount: taskProvider.tasks.length,
                      itemBuilder: (_, i) {
                        final task = taskProvider.tasks[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFF2D3E50),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(
                              task.title,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              task.completed ? 'Completed' : 'Pending',
                              style: TextStyle(
                                color: task.completed
                                    ? Colors.greenAccent
                                    : Colors.orangeAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    task.completed
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: Colors.amber,
                                  ),
                                  onPressed: () async {
                                    await taskProvider.toggleTask(
                                        task.id, !task.completed);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () async {
                                    await taskProvider.deleteTask(task.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Color(0xFF1B2B3A),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: showAddDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: Text("Add Task", style: TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}

class TaskProvider with ChangeNotifier {
  final SupabaseService service = SupabaseService();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await service.fetchTasks();
    notifyListeners();
  }

  Future<void> addTask(String taskTitle) async {
    await service.addTask(taskTitle);
    await loadTasks(); // Reload tasks after adding a new one
  }

  Future<void> toggleTask(int taskId, bool completed) async {
    await service.toggleTask(taskId, completed);
    await loadTasks(); // Reload tasks after updating status
  }

  Future<void> deleteTask(int taskId) async {
    await service.deleteTask(taskId);
    await loadTasks(); // Reload tasks after deleting
  }
}
