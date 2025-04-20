import 'package:flutter/material.dart';
import '../app/theme_provider.dart';
import '../auth/auth_service.dart';
import 'task_model.dart';
import '../services/supabase_service.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }
  void showEditDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final detailsController = TextEditingController(text: task.detail);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1B2B3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Edit Task", style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Task Title",
                  hintStyle: const TextStyle(color: Colors.white54),
                  fillColor: const Color(0xFF2D3E50),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: detailsController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Task Detail",
                  hintStyle: const TextStyle(color: Colors.white54),
                  fillColor: const Color(0xFF2D3E50),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () async {
              final newTitle = titleController.text;
              final newDetail = detailsController.text;

              if (newTitle.isEmpty || newDetail.isEmpty) {
                showSnackbar("Both title and details are required.");
                return;
              }
              try {
                await Provider.of<TaskProvider>(context, listen: false)
                    .updateTask(task.id, newTitle, newDetail);
                Navigator.pop(context);
                showSnackbar("Task Updated Successfully");
              } catch (e) {
                Navigator.pop(context);
                showSnackbar("Failed_1 : "+e.toString() );
              }
            },
            child: const Text("Update", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final detailsController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 30);
    DateTime selectedDate = DateTime(2022, 11, 15);

    void pickTime() async {
      final picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked != null) {
        selectedTime = picked;
      }
    }

    void pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      );
      if (picked != null) {
        selectedDate = picked;
      }
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: const Color(0xFF1B2B3A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: const [
                      Icon(Icons.arrow_back, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Create New Task",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Task Title
                  const Text("Task Title", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2D3E50),
                      hintText: "Hi-Fi Wireframe",
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Task Details
                  const Text("Task Details", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: detailsController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2D3E50),
                      hintText: "Enter task details",
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Team Members
                  const Text("Add team members", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildMemberChip("Robert"),
                      _buildMemberChip("Sophia"),
                      ActionChip(
                        avatar: const Icon(Icons.add, color: Colors.white),
                        label: const Text("Add", style: TextStyle(color: Colors.white)),
                        backgroundColor: const Color(0xFF2D3E50),
                        onPressed: () {
                          // Add logic to add new member
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Time & Date
                  const Text("Time & Date", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          pickTime();
                          setState(() {});
                        },
                        icon: const Icon(Icons.access_time, color: Colors.white),
                        label: Text(
                          selectedTime.format(context),
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D3E50),
                          elevation: 0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          pickDate();
                          setState(() {});
                        },
                        icon: const Icon(Icons.calendar_today, color: Colors.white),
                        label: Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D3E50),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Add New", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Create Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () async {
                        final title = titleController.text;
                        final detail = detailsController.text;

                        if (title.isEmpty) {
                          showSnackbar("Task title cannot be empty.");
                          return;
                        }
                        if (detail.isEmpty) {
                          showSnackbar("Task details cannot be empty.");
                          return;
                        }

                        try {
                          await Provider.of<TaskProvider>(context, listen: false)
                              .addTask(title,detail);
                          Navigator.pop(context);
                        } catch (e) {
                          showSnackbar("Error: ${e.toString()}");
                        }
                      },
                      child: const Text("Create", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberChip(String name) {
    return Chip(
      backgroundColor: const Color(0xFF2D3B45),
      avatar: const Icon(Icons.person, color: Colors.white, size: 18),
      label: Text(name, style: const TextStyle(color: Colors.white)),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).clearTasks();
              auth.signOut();
            },
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
                          child: GestureDetector(
                            onTap: () {
                              showEditDialog(context, task);
                            },
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
            onPressed: (){
              showAddDialog(context);
            },
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
  Future<void> updateTask(int taskId, String newTitle, String newDetail) async {
    await service.updateTask(taskId, newTitle, newDetail);
    await loadTasks(); // Reload after update
  }

  Future<void> addTask(String taskTitle,String taskDetail) async {
    await service.addTask(taskTitle,taskDetail);

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
  void clearTasks() {
    _tasks.clear();
    notifyListeners();
  }
}
