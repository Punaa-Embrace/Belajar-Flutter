class Todo {
  int? id;
  String title;
  String description;
  String target;
  String priority; // 'High', 'Medium', 'Low'
  String? deadline; // Store as ISO8601 string
  int isDone; // 0 = false, 1 = true

  Todo({
    this.id,
    required this.title,
    this.description = '',
    this.target = '',
    this.priority = 'Medium',
    this.deadline,
    this.isDone = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'target': target,
      'priority': priority,
      'deadline': deadline,
      'isDone': isDone,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      target: map['target'] ?? '',
      priority: map['priority'] ?? 'Medium',
      deadline: map['deadline'],
      isDone: map['isDone'] ?? 0,
    );
  }
}
