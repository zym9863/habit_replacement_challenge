import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String badHabit;
  final String goodHabit;
  final int challengeDays;
  final DateTime startDate;
  final List<bool> checkInRecords;
  
  // UI相关属性
  final Color? badHabitColor; // 不良习惯的颜色
  final Color? goodHabitColor; // 良好习惯的颜色
  final IconData? badHabitIcon; // 不良习惯的图标
  final IconData? goodHabitIcon; // 良好习惯的图标

  Habit({
    String? id,
    required this.badHabit,
    required this.goodHabit,
    required this.challengeDays,
    required this.startDate,
    List<bool>? checkInRecords,
    this.badHabitColor,
    this.goodHabitColor,
    this.badHabitIcon,
    this.goodHabitIcon,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       checkInRecords = checkInRecords ?? List.generate(challengeDays, (_) => false);

  // 获取当前挑战天数
  int get currentDay {
    final difference = DateTime.now().difference(startDate).inDays;
    return difference < challengeDays ? difference + 1 : challengeDays;
  }

  // 获取完成率
  double get completionRate {
    int completedDays = checkInRecords.where((checked) => checked).length;
    return completedDays / challengeDays;
  }
  
  // 获取连续打卡天数
  int get currentStreak {
    int streak = 0;
    for (int i = checkInRecords.length - 1; i >= 0; i--) {
      if (checkInRecords[i]) {
        streak++;
      } else if (streak > 0) {
        break;
      }
    }
    return streak;
  }
  
  // 获取挑战状态
  String get statusText {
    final progress = (completionRate * 100).toInt();
    if (progress < 30) return "刚刚开始";
    if (progress < 60) return "坚持中";
    if (progress < 90) return "即将成功";
    return "挑战成功";
  }

  // 检查今天是否已打卡
  bool get isTodayCheckedIn {
    final today = DateTime.now().difference(startDate).inDays;
    return today < checkInRecords.length ? checkInRecords[today] : false;
  }

  // 打卡
  Habit checkIn() {
    final today = DateTime.now().difference(startDate).inDays;
    if (today < 0 || today >= challengeDays) return this;
    
    List<bool> updatedRecords = List.from(checkInRecords);
    updatedRecords[today] = true;
    
    return Habit(
      id: id,
      badHabit: badHabit,
      goodHabit: goodHabit,
      challengeDays: challengeDays,
      startDate: startDate,
      checkInRecords: updatedRecords,
      badHabitColor: badHabitColor,
      goodHabitColor: goodHabitColor,
      badHabitIcon: badHabitIcon,
      goodHabitIcon: goodHabitIcon,
    );
  }

  // 将对象转换为Map，用于存储
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'badHabit': badHabit,
      'goodHabit': goodHabit,
      'challengeDays': challengeDays,
      'startDate': startDate.millisecondsSinceEpoch,
      'checkInRecords': checkInRecords,
      // 注意：颜色和图标不存储，因为它们是UI元素，可以根据习惯类型在加载时设置
    };
  }

  // 从Map创建对象，用于读取存储的数据
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      badHabit: map['badHabit'],
      goodHabit: map['goodHabit'],
      challengeDays: map['challengeDays'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      checkInRecords: List<bool>.from(map['checkInRecords']),
      // 默认颜色和图标可以在UI层设置
    );
  }
}