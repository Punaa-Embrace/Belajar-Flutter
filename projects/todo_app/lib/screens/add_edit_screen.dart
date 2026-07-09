import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../helpers/database_helper.dart';
import '../helpers/notification_helper.dart';

class AddEditScreen extends StatefulWidget {
  final Todo? todo;

  const AddEditScreen({super.key, this.todo});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late String target;
  late String priority;
  DateTime? deadline;

  final List<String> priorities = ['High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    title = widget.todo?.title ?? '';
    description = widget.todo?.description ?? '';
    target = widget.todo?.target ?? '';
    priority = widget.todo?.priority ?? 'Medium';
    if (widget.todo?.deadline != null) {
      deadline = DateTime.parse(widget.todo!.deadline!);
    }
  }

  void _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final todo = Todo(
        id: widget.todo?.id,
        title: title,
        description: description,
        target: target,
        priority: priority,
        deadline: deadline?.toIso8601String(),
        isDone: widget.todo?.isDone ?? 0,
      );

      int savedId;
      if (widget.todo == null) {
        savedId = await DatabaseHelper.instance.insertTodo(todo);
      } else {
        savedId = widget.todo!.id!;
        await DatabaseHelper.instance.updateTodo(todo);
        // Cancel old notification
        await NotificationHelper().cancelNotification(savedId);
      }

      // Schedule notification if deadline is set and in the future
      if (deadline != null && deadline!.isAfter(DateTime.now()) && todo.isDone == 0) {
        await NotificationHelper().scheduleNotification(
          savedId,
          'Deadline Reminder: $title',
          'Target: $target',
          deadline!,
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
              surface: Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(deadline ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF6366F1),
                onPrimary: Colors.white,
                surface: Color(0xFF1E293B),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          deadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isEditing ? 'Edit Task' : 'New Task',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("What needs to be done?"),
                const SizedBox(height: 16),
                _buildTextField(
                  initialValue: title,
                  label: 'Task Title',
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                  onSaved: (value) => title = value!,
                  accentColor: const Color(0xFF6366F1),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("Target / Goal"),
                const SizedBox(height: 12),
                _buildTextField(
                  initialValue: target,
                  label: 'What do you want to achieve?',
                  onSaved: (value) => target = value ?? '',
                  accentColor: const Color(0xFF10B981),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("Priority"),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: priority,
                            dropdownColor: const Color(0xFF1E293B),
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            decoration: _inputDecoration('Select Priority', const Color(0xFFF59E0B)),
                            items: priorities.map((String p) {
                              return DropdownMenuItem<String>(
                                value: p,
                                child: Text(p),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                priority = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("Deadline"),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _selectDateTime(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          deadline != null
                              ? DateFormat('dd MMM yyyy, HH:mm').format(deadline!)
                              : 'Set a deadline (Optional)',
                          style: TextStyle(
                            color: deadline != null ? Colors.white : Colors.white.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.calendar_month, color: deadline != null ? const Color(0xFFEC4899) : Colors.white54),
                      ],
                    ),
                  ),
                ),
                if (deadline != null)
                   Padding(
                     padding: const EdgeInsets.only(top: 8),
                     child: GestureDetector(
                       onTap: () => setState(() => deadline = null),
                       child: const Text('Clear Deadline', style: TextStyle(color: Colors.redAccent)),
                     ),
                   ),
                const SizedBox(height: 24),
                _buildSectionTitle("Additional details"),
                const SizedBox(height: 12),
                _buildTextField(
                  initialValue: description,
                  label: 'Description (Optional)',
                  maxLines: 4,
                  onSaved: (value) => description = value ?? '',
                  accentColor: const Color(0xFF8B5CF6),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEC4899).withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _saveTodo,
                    child: const Text(
                      'Save Task',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
    );
  }

  InputDecoration _inputDecoration(String label, Color accentColor) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accentColor, width: 2),
      ),
    );
  }

  Widget _buildTextField({
    required String initialValue,
    required String label,
    required Function(String?) onSaved,
    required Color accentColor,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: _inputDecoration(label, accentColor),
      validator: validator,
      onSaved: onSaved,
      maxLines: maxLines,
    );
  }
}
