enum TaskCategory {
  fitness,
  education,
  development,
  hobby,
  mind,
  personal,
  other,
}

extension TaskCategoryExtension on TaskCategory {
  String get name {
    switch (this) {
      case TaskCategory.fitness:
        return 'Fitness';
      case TaskCategory.education:
        return 'Education';
      case TaskCategory.development:
        return 'Development';
      case TaskCategory.hobby:
        return 'Hobby';
      case TaskCategory.mind:
        return 'Mind';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.other:
        return 'Other';
    }
  }

  String localizedName(
    String language,
  ) {
    if (language != 'ru') {
      return name;
    }

    switch (this) {
      case TaskCategory.fitness:
        return 'Фитнес';
      case TaskCategory.education:
        return 'Образование';
      case TaskCategory.development:
        return 'Разработка';
      case TaskCategory.hobby:
        return 'Хобби';
      case TaskCategory.mind:
        return 'Разум';
      case TaskCategory.personal:
        return 'Личное';
      case TaskCategory.other:
        return 'Другое';
    }
  }
}

class Task {
  final String id;
  final String name;
  final int xp;
  final TaskCategory category;
  final List<int> days;
  final String time;

  Task({
    required this.id,
    required this.name,
    required this.xp,
    required this.category,
    required this.days,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'xp': xp,
      'category': category.name,
      'days': days,
      'time': time,
    };
  }

  factory Task.fromJson(
    Map<String, dynamic> json,
  ) {
    return Task(
      id: json['id'],
      name: json['name'],
      xp: json['xp'],
      category: TaskCategory.values.firstWhere(
        (category) =>
            category.name == json['category'],
        orElse: () => TaskCategory.other,
      ),
      days: List<int>.from(json['days']),
      time: json['time'],
    );
  }
}