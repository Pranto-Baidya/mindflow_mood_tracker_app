import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JournalModel {
  final String id;
  final String uid;
  final DateTime date;
  final TimeOfDay time;
  final String mood;
  final String content;
  final List<String> tags;

  JournalModel({
    required this.id,
    required this.uid,
    required this.date,
    required this.time,
    required this.mood,
    required this.content,
    required this.tags,
  });

  factory JournalModel.fromMap(String id, Map<String, dynamic> data) {
    return JournalModel(
      id: id,
      uid: data['uid'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'] != null ? TimeOfDay(
        hour: int.parse(data['time'].split(':')[0]),
        minute: int.parse(data['time'].split(':')[1]),
      )
          : TimeOfDay.now(),
      mood: data['mood'] ?? '',
      content: data['content'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    String timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    return {
      'uid': uid,
      'date': Timestamp.fromDate(date),
      'time': timeString,
      'mood': mood,
      'content': content,
      'tags': tags,
    };
  }
}