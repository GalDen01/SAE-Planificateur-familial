class TodoTaskModel {
  final int? id;
  final int listId;
  final String content;
  final bool isChecked;

  TodoTaskModel({
    this.id,
    required this.listId,
    required this.content,
    required this.isChecked,
  });

  factory TodoTaskModel.fromJson(Map<String, dynamic> json) {
    return TodoTaskModel(
      id: json['id'] as int?,
      listId: json['list_id'] as int,
      content: json['content'] as String,
      isChecked: json['is_checked'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'list_id': listId,
      'content': content,
      'is_checked': isChecked,
    };
  }
}
