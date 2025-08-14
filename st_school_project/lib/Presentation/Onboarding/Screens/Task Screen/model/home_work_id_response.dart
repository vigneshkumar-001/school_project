// homework_detail_model.dart
class HomeWorkIdResponse  {
  bool status;
  int code;
  String message;
  HomeworkIdDetail data;

  HomeWorkIdResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory HomeWorkIdResponse.fromJson(Map<String, dynamic> json) =>
      HomeWorkIdResponse(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: HomeworkIdDetail.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class HomeworkIdDetail {
  int id;
  String title;
  String description;
  String date;
  String time;
  ClassInfo classInfo;
  SubjectInfo subject;
  List<TaskItem> tasks;

  HomeworkIdDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.classInfo,
    required this.subject,
    required this.tasks,
  });

  factory HomeworkIdDetail.fromJson(Map<String, dynamic> json) => HomeworkIdDetail(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    date: json["date"],
    time: json["time"],
    classInfo: ClassInfo.fromJson(json["class"]),
    subject: SubjectInfo.fromJson(json["subject"]),
    tasks: List<TaskItem>.from(
        json["tasks"].map((x) => TaskItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "date": date,
    "time": time,
    "class": classInfo.toJson(),
    "subject": subject.toJson(),
    "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
  };
}

class ClassInfo {
  int id;
  String name;
  String section;

  ClassInfo({
    required this.id,
    required this.name,
    required this.section,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) => ClassInfo(
    id: json["id"],
    name: json["name"],
    section: json["section"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "section": section,
  };
}

class SubjectInfo {
  int id;
  String name;

  SubjectInfo({
    required this.id,
    required this.name,
  });

  factory SubjectInfo.fromJson(Map<String, dynamic> json) => SubjectInfo(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class TaskItem {
  String type;
  String content;

  TaskItem({
    required this.type,
    required this.content,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
    type: json["type"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "content": content,
  };
}
