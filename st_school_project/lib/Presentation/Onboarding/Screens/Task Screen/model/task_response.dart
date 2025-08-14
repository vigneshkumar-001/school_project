
class TaskResponse {
  bool status;
  int code;
  String message;
  List<YourTask> data;

  TaskResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) => TaskResponse(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    data: List<YourTask>.from(json["data"].map((x) => YourTask.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class YourTask {
  int id;
  String title;
  String description;
  DateTime date;
  DateTime time;
  String assignedByName;
  String subject;
  int subjectId;
  String type;

  YourTask({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.assignedByName,
    required this.subject,
    required this.subjectId,
    required this.type,
  });

  factory YourTask.fromJson(Map<String, dynamic> json) => YourTask(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    date: DateTime.parse(json["date"]),
    time: DateTime.parse(json["time"]),
    assignedByName: json["assigned_by_name"],
    subject: json["subject"],
    subjectId: json["subject_id"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "date": date.toIso8601String(),
    "time": time.toIso8601String(),
    "assigned_by_name": assignedByName,
    "subject": subject,
    "subject_id": subjectId,
    "type": type,
  };
}
