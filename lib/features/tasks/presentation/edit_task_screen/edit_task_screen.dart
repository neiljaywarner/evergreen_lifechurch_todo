import 'dart:async';

import 'package:evergreen_lifechurch_todo/common_widgets/responsive_center.dart';
import 'package:evergreen_lifechurch_todo/constants/breakpoints.dart';
import 'package:evergreen_lifechurch_todo/features/tasks/domain/task.dart';
import 'package:evergreen_lifechurch_todo/features/tasks/presentation/edit_task_screen/edit_task_screen_controller.dart';
import 'package:evergreen_lifechurch_todo/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  const EditTaskScreen({super.key, this.taskId, this.task});
  final TaskID? taskId;
  final Task? task;

  @override
  ConsumerState<EditTaskScreen> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends ConsumerState<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _title;
  String? _description;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task?.title;
      _description = widget.task?.description;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      final success =
          await ref.read(editTaskScreenControllerProvider.notifier).submit(
                taskId: widget.taskId,
                oldTask: widget.task,
                title: _title ?? '',

                //TODO(neiljaywarner): pick a different way to figure out due date
                dueDate:  DateTime.now().add(const Duration(days: 7)),
                description: _description ?? '',
              );
      if (success && mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<dynamic>>(
      editTaskScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(editTaskScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
        actions: <Widget>[
          TextButton(
            onPressed: state.isLoading ? null : _submit,
            child: Text('Save'),
          ),
        ],
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Task title'),
        keyboardAppearance: Brightness.light,
        initialValue: _title,
        validator: (value) =>
            (value ?? '').isNotEmpty ? null : "Title can't be empty",
        onSaved: (value) => _title = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Description'),
        keyboardAppearance: Brightness.light,
        initialValue: _description,
        onSaved: (value) => _description = value,
      ),
    ];
  }
}
