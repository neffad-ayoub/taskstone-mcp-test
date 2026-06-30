import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  final TaskService taskService;

  const HomePage({super.key, required this.taskService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Stream<List<Task>> _taskStream;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _taskStream = widget.taskService.streamTasks();
    _taskStream.listen((_) {
      if (_isLoading && mounted) setState(() => _isLoading = false);
    });
  }

  Future<void> _addTask() async {
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (_) => const AddTaskDialog(),
    );
    if (result != null && result['title'] != null) {
      await widget.taskService.addTask(
        result['title']!,
        description: result['description'],
      );
    }
  }

  void _toggleTask(Task task) {
    widget.taskService.toggleCompletion(task.id, !task.isCompleted);
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Throw away?'),
        content: Text('Bury "${task.title}" in tar pit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('No keep'),
          ),
          FilledButton(
            onPressed: () {
              widget.taskService.deleteTask(task.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Yes bury'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskStone'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Task>>(
              stream: _taskStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '💥',
                          style: theme.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text('Ooga booga! Thing break!'),
                        Text(snapshot.error.toString()),
                      ],
                    ),
                  );
                }

                final tasks = snapshot.data ?? [];

                if (tasks.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '🦴',
                            style: theme.textTheme.displayLarge,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No task. Cave empty.',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Me bored. Add task make brain work.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final completed =
                    tasks.where((t) => t.isCompleted).length;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '📋 ${tasks.length} tasks',
                            style: theme.textTheme.titleMedium,
                          ),
                          const Spacer(),
                          Text(
                            '✅ $completed done',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return TaskTile(
                            task: task,
                            onToggle: () => _toggleTask(task),
                            onDelete: () => _deleteTask(task),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
    );
  }
}
