import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit_model.dart';

class HabitService {
  static const String _habitsKey = 'habits';

  // 获取所有习惯
  Future<List<Habit>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getStringList(_habitsKey) ?? [];
    
    return habitsJson
        .map((json) => Habit.fromMap(jsonDecode(json)))
        .toList();
  }

  // 保存习惯
  Future<void> saveHabit(Habit habit) async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getStringList(_habitsKey) ?? [];
    
    // 检查是否已存在该习惯，如果存在则更新
    final habitIndex = habitsJson.indexWhere((json) {
      final map = jsonDecode(json);
      return map['id'] == habit.id;
    });
    
    if (habitIndex >= 0) {
      habitsJson[habitIndex] = jsonEncode(habit.toMap());
    } else {
      habitsJson.add(jsonEncode(habit.toMap()));
    }
    
    await prefs.setStringList(_habitsKey, habitsJson);
  }

  // 删除习惯
  Future<void> deleteHabit(String habitId) async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getStringList(_habitsKey) ?? [];
    
    final filteredHabits = habitsJson.where((json) {
      final map = jsonDecode(json);
      return map['id'] != habitId;
    }).toList();
    
    await prefs.setStringList(_habitsKey, filteredHabits);
  }

  // 打卡
  Future<void> checkInHabit(String habitId) async {
    final habits = await getHabits();
    final habitIndex = habits.indexWhere((h) => h.id == habitId);
    
    if (habitIndex >= 0) {
      final updatedHabit = habits[habitIndex].checkIn();
      await saveHabit(updatedHabit);
    }
  }
}