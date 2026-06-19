import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/note.dart';
import '../bloc/notes_bloc.dart';

/// Screen for adding or editing a note
class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _imagePath;
  final _imagePicker = ImagePicker();

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      _imagePath = widget.note!.imagePath;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveNote),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.mediumPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter note title',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.mediumPadding),

              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter note description',
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.mediumPadding),

              // Image section
              if (_imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.mediumRadius,
                  ),
                  child: Image.file(
                    File(_imagePath!),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: AppConstants.smallPadding),
                TextButton.icon(
                  onPressed: () => setState(() => _imagePath = null),
                  icon: const Icon(Icons.delete),
                  label: const Text('Remove Image'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: AppConstants.mediumPadding),
              ],

              // Add image button
              if (_imagePath == null)
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Add Image (Optional)'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final note = Note(
        id: _isEditing ? widget.note!.id : const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imagePath: _imagePath,
        localImagePath: _imagePath,

        createdAt: _isEditing ? widget.note!.createdAt : now,
        updatedAt: now,
        isSynced: false,
        isDeleted: false,
      );

      if (_isEditing) {
        context.read<NotesBloc>().add(UpdateNoteEvent(note: note));
      } else {
        context.read<NotesBloc>().add(AddNoteEvent(note: note));
      }

      Navigator.pop(context);
    }
  }
}
