/*

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
    description: json["description"]??"",
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
*/

class TaskResponse {
  final bool status;
  final int code;
  final String message;
  final List<YourTask> data;

  TaskResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final List<YourTask> parsed = <YourTask>[];

    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          try {
            parsed.add(YourTask.fromJson(Map<String, dynamic>.from(item)));
          } catch (_) {
            // skip bad item instead of crashing
          }
        }
      }
    }

    return TaskResponse(
      status: _toBool(json['status']),
      code: _toInt(json['code']),
      message: _toStr(json['message']),
      data: parsed,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.map((x) => x.toJson()).toList(),
  };
}

class YourTask {
  final int id;
  final String title;
  final String description;

  /// Always non-null; falls back to today if missing.
  final DateTime date;

  /// Concrete DateTime. If API sends only a time, we combine with `date`.
  final DateTime time;
  final String assignedByName;
  final String subject;
  final int subjectId;
  final String type;

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

  // factory YourTask.fromJson(Map<String, dynamic> json) {
  //   final dateStr = _toStr(json['date']); // e.g. "2025-09-05" or ISO
  //   final timeStr = _toStr(json['time']); // e.g. "14:30:00" or ISO
  //
  //   // 1) Date
  //   DateTime parsedDate = DateTime.now();
  //   if (dateStr.isNotEmpty) {
  //     parsedDate = DateTime.tryParse(dateStr) ?? parsedDate;
  //   }
  //
  //   // 2) Time
  //   // Try full ISO first:
  //   DateTime? parsedTime =
  //       timeStr.isNotEmpty ? DateTime.tryParse(timeStr) : null;
  //
  //   // If only clock given (HH:mm or HH:mm:ss), combine with parsedDate
  //   if (parsedTime == null && timeStr.isNotEmpty) {
  //     final combined1 = '${_yyyyMmDd(parsedDate)}T$timeStr';
  //     parsedTime = DateTime.tryParse(combined1);
  //     // If server sent “HH:mm” (no seconds), DateTime.tryParse still works, but just in case:
  //     parsedTime ??= DateTime.tryParse(
  //       '${_yyyyMmDd(parsedDate)}T${_padClock(timeStr)}',
  //     );
  //   }
  //
  //   parsedTime ??= parsedDate;
  //
  //   return YourTask(
  //     id: _toInt(json['id']),
  //     title: _toStr(json['title']),
  //     description: _toStr(json['description'] ?? ''),
  //     date: parsedDate,
  //     time: parsedTime,
  //     assignedByName: _toStr(json['assigned_by_name']),
  //     subject: _toStr(json['subject']),
  //     subjectId: _toInt(json['subject_id']),
  //     type: _toStr(json['type']),
  //   );
  // }


  factory YourTask.fromJson(Map<String, dynamic> json) {
    // --- Safe helpers ---
    String _toStr(dynamic v) => v?.toString() ?? '';
    int _toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    String _yyyyMmDd(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-'
            '${d.month.toString().padLeft(2, '0')}-'
            '${d.day.toString().padLeft(2, '0')}';

    String _padClock(String clock) {
      final parts = clock.split(':');
      if (parts.length == 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}:00';
      } else if (parts.length == 3) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}:${parts[2].padLeft(2, '0')}';
      }
      return clock;
    }

    final String dateStr = _toStr(json['date']); // may be "YYYY-MM-DD", ISO, or null
    final String timeStr = _toStr(json['time']); // may be "HH:mm[:ss]", ISO, or null

    // 1) Date
    DateTime parsedDate = DateTime.now();
    if (dateStr.isNotEmpty) {
      parsedDate = DateTime.tryParse(dateStr) ?? parsedDate;
    }

    // 2) Time
    DateTime parsedTime = parsedDate; // default: same as date
    if (timeStr.isNotEmpty) {
      // Try full ISO first
      final iso = DateTime.tryParse(timeStr);
      if (iso != null) {
        parsedTime = iso;
      } else {
        // Combine clock-only with parsedDate
        final combined1 = '${_yyyyMmDd(parsedDate)}T$timeStr';
        parsedTime = DateTime.tryParse(combined1) ??
            DateTime.tryParse('${_yyyyMmDd(parsedDate)}T${_padClock(timeStr)}') ??
            parsedDate;
      }
    }

    return YourTask(
      id: _toInt(json['id']),
      title: _toStr(json['title']),                // safe ('' if null)
      description: _toStr(json['description']),    // safe ('' if null)
      date: parsedDate,
      time: parsedTime,
      assignedByName: _toStr(json['assigned_by_name']),
      subject: _toStr(json['subject']),
      subjectId: _toInt(json['subject_id']),
      type: _toStr(json['type']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'time': time.toIso8601String(),
    'assigned_by_name': assignedByName,
    'subject': subject,
    'subject_id': subjectId,
    'type': type,
  };
}

/// ---------- Safe helpers ----------
int _toInt(dynamic v) {
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v.trim()) ?? 0;
  return 0;
}

bool _toBool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final s = v.toLowerCase().trim();
    return s == 'true' || s == '1' || s == 'yes';
  }
  return false;
}

String _toStr(dynamic v) => v?.toString() ?? '';

String _yyyyMmDd(DateTime d) {
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
}

/// Pads "H:mm" -> "HH:mm:ss"
String _padClock(String t) {
  final parts = t.split(':');
  if (parts.length == 1) {
    return parts[0].padLeft(2, '0') + ':00:00';
  } else if (parts.length == 2) {
    return parts[0].padLeft(2, '0') + ':' + parts[1].padLeft(2, '0') + ':00';
  } else {
    // HH:mm:ss (or longer) → ensure HH and mm are 2-digits
    final hh = parts[0].padLeft(2, '0');
    final mm = parts[1].padLeft(2, '0');
    final ss = parts[2];
    return '$hh:$mm:$ss';
  }
}
