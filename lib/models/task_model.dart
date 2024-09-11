class Task {
  int? id;
  late String title;
  late String note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;
  String? priority;
  String? completedAt;
  String? createdAt;
  String? updatedAt;

  Task({
    this.id,
    required this.title,
    required this.note,
    this.isCompleted = 0, // Default to not completed
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
    this.priority,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    color = json['color'];
    remind = json['remind'];
    priority = json['priority'];
    repeat = json['repeat'];
    completedAt = json['completedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['note'] = note;
    data['isCompleted'] = isCompleted;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['color'] = color;
    data['remind'] = remind;
    data['priority'] = priority;
    data['repeat'] = repeat;
    data['completedAt'] = completedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  // Method to mark the task as completed
  void markAsCompleted() {
    isCompleted = 1;
    completedAt = DateTime.now().toIso8601String();
  }

  // Method to update task details
  void updateTask({
    String? newTitle,
    String? newNote,
    String? newDate,
    String? newStartTime,
    String? newEndTime,
    int? newColor,
    int? newRemind,
    String? newRepeat,
    String? newPriority,
  }) {
    title = newTitle ?? title;
    note = newNote ?? note;
    date = newDate ?? date;
    startTime = newStartTime ?? startTime;
    endTime = newEndTime ?? endTime;
    color = newColor ?? color;
    remind = newRemind ?? remind;
    repeat = newRepeat ?? repeat;
    priority = newPriority ?? priority;
    updatedAt = DateTime.now().toIso8601String();
  }
}
