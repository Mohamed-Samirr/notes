import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/color_palette.dart';
import '../../domain/entities/journal_entry.dart';
import '../bloc/journal_bloc.dart';

/// Main screen for journal entries
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  DateTime _selectedDate = DateTime.now();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEntriesForDate(_selectedDate);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _loadEntriesForDate(DateTime date) {
    context.read<JournalBloc>().add(LoadAllEntriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
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
                              _selectedDate = _selectedDate.subtract(
                                const Duration(days: 1),
                              );
                            });
                            _loadEntriesForDate(_selectedDate);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setState(() {
                              _selectedDate = _selectedDate.add(
                                const Duration(days: 1),
                              );
                            });
                            _loadEntriesForDate(_selectedDate);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Add entry input
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.mediumPadding,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.mediumPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Write Your Thoughts',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppConstants.mediumPadding),
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: 'What\'s on your mind today...',
                        border: InputBorder.none,
                      ),
                      maxLines: 5,
                      onSubmitted: (_) => _addEntry(),
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    ElevatedButton.icon(
                      onPressed: _addEntry,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Entry'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(
                          AppConstants.mediumPadding,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: AppConstants.mediumPadding),

          // Entries list
          Expanded(
            child: BlocBuilder<JournalBloc, JournalState>(
              builder: (context, state) {
                if (state is JournalLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is JournalError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                if (state is JournalEntriesLoaded) {
                  // Filter entries for selected date
                  final selectedDateNormalized = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                  );

                  final todayEntries = state.entries.where((entry) {
                    final entryDate = DateTime(
                      entry.date.year,
                      entry.date.month,
                      entry.date.day,
                    );
                    return entryDate == selectedDateNormalized;
                  }).toList();

                  if (todayEntries.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book_outlined,
                            size: 80,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No entries for this day',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Write your thoughts below',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.mediumPadding,
                    ),
                    itemCount: todayEntries.length,
                    itemBuilder: (context, index) {
                      final entry = todayEntries[index];
                      final cardColor = ColorPalette.getColorById(
                        entry.id,
                        prefix: 'journal_',
                      );
                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: AppConstants.mediumPadding,
                        ),
                        color: cardColor.withOpacity(isDark ? 0.15 : 0.1),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppConstants.mediumRadius,
                            ),
                            border: Border.all(
                              color: cardColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              AppConstants.mediumPadding,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat(
                                        'HH:mm',
                                      ).format(entry.createdAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: cardColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                      onPressed: () => _deleteEntry(entry.id),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: AppConstants.smallPadding,
                                ),
                                Text(
                                  entry.content,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
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
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadEntriesForDate(picked);
    }
  }

  void _addEntry() {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    final now = DateTime.now();
    final entry = JournalEntry(
      id: const Uuid().v4(),
      date: _selectedDate,
      content: content,
      createdAt: now,
      updatedAt: now,
      isSynced: false,
      isDeleted: false,
    );

    context.read<JournalBloc>().add(SaveJournalEntryEvent(entry: entry));
    _contentController.clear();
  }

  void _deleteEntry(String entryId) {
    context.read<JournalBloc>().add(DeleteJournalEntryEvent(entryId: entryId));
  }
}
