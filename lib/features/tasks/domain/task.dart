import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

typedef TaskID = String;

@immutable
class Task extends Equatable {
  const Task({required this.id, required this.title,
    required this.description, required this.dueDate, required this.status });

  factory Task.fromMap(Map<String, dynamic> data, String id) {
    final dueDateMilliseconds = data['dueDate'] as int;
    final status =  Status.values.firstWhere(
            (e) => e.name == data['status'] as String);

    return Task(
      id: id,
      title: data['title'] as String,
      description: data['description'] as String,
      dueDate: DateTime.fromMillisecondsSinceEpoch(dueDateMilliseconds),
      status: status,
    );
  }
  final TaskID id;
  final String title;
  final String description;
  final DateTime dueDate;
  final Status status;

  @override
  List<Object> get props => [id, title, description, dueDate, status];

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() => {
      'title': title,
      'description': description,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'status': status.name,
    };
}

enum Status {
  pending, inProgress, completed
}
