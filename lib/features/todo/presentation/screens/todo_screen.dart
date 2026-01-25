import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/todo_task.dart';
import '../bloc/todo_bloc.dart';
import '../widgets/todo_item.dart';

/// Main screen for ToDo list
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasksForDate(_selectedDate);
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _loadTasksForDate(DateTime date) {
    context.read<TodoBloc>().add(LoadTasksByDateEvent(date: date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date selector
          Container(
            padding: const EdgeInsets.all(AppConstants.mediumPadding),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.mediumPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE').format(_selectedDate),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          DateFormat('MMMM dd, yyyy').format(_selectedDate),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setState(() {
                              _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                            });
                            _loadTasksForDate(_selectedDate);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setState(() {
                              _selectedDate = _selectedDate.add(const Duration(days: 1));
                            });
                            _loadTasksForDate(_selectedDate);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Task list
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is TodoError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                if (state is TodoLoaded) {
                  final incompleteTasks = state.tasks.where((t) => !t.isCompleted).toList();
                  final completedTasks = state.tasks.where((t) => t.isCompleted).toList();

                  if (state.tasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 80,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks for today',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add a task to get started',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.mediumPadding,
                    ),
                    children: [
                      // Incomplete tasks
                      if (incompleteTasks.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppConstants.smallPadding,
                          ),
                          child: Text(
                            'Tasks (${incompleteTasks.length})',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        ...incompleteTasks.map((task) => TodoItem(
                          task: task,
                          onToggle: () => _toggleTask(task.id),
                          onDelete: () => _deleteTask(task.id),
                        )),
                        const SizedBox(height: AppConstants.mediumPadding),
                      ],

                      // Completed tasks
                      if (completedTasks.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppConstants.smallPadding,
                          ),
                          child: Text(
                            'Completed (${completedTasks.length})',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ),
                        ...completedTasks.map((task) => TodoItem(
                          task: task,
                          onToggle: () => _toggleTask(task.id),
                          onDelete: () => _deleteTask(task.id),
                        )),
                      ],
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          // Add task input
          Container(
            padding: const EdgeInsets.all(AppConstants.mediumPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Add a new task...',
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.mediumPadding,
                          vertical: AppConstants.smallPadding,
                        ),
                      ),
                      onSubmitted: (_) => _addTask(),
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  FloatingActionButton(
                    onPressed: _addTask,
                    mini: true,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadTasksForDate(picked);
    }
  }

  void _addTask() {
    final title = _taskController.text.trim();
    if (title.isEmpty) return;

    final task = TodoTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
      date: _selectedDate,
      createdAt: DateTime.now(),
    );

    context.read<TodoBloc>().add(AddTaskEvent(task: task));
    _taskController.clear();
  }

  void _toggleTask(String taskId) {
    context.read<TodoBloc>().add(ToggleTaskCompletionEvent(taskId: taskId));
  }

  void _deleteTask(String taskId) {
    context.read<TodoBloc>().add(DeleteTaskEvent(taskId: taskId));
  }
}
