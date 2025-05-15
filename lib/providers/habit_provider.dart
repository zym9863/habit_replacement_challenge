import 'package:flutter/foundation.dart';
import '../models/habit_model.dart';
import '../services/habit_service.dart';

class HabitProvider with ChangeNotifier {
  final HabitService _habitService = HabitService();
  List<Habit> _habits = [];
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  // 初始化，加载所有习惯
  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      _habits = await _habitService.getHabits();
    } catch (e) {
      print('加载习惯失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 添加新习惯
  Future<void> addHabit(Habit habit) async {
    try {
      await _habitService.saveHabit(habit);
      await loadHabits(); // 重新加载所有习惯
    } catch (e) {
      print('添加习惯失败: $e');
    }
  }

  // 更新习惯
  Future<void> updateHabit(Habit habit) async {
    try {
      await _habitService.saveHabit(habit);
      await loadHabits(); // 重新加载所有习惯
    } catch (e) {
      print('更新习惯失败: $e');
    }
  }

  // 删除习惯
  Future<void> deleteHabit(String habitId) async {
    try {
      await _habitService.deleteHabit(habitId);
      await loadHabits(); // 重新加载所有习惯
    } catch (e) {
      print('删除习惯失败: $e');
    }
  }

  // 打卡
  Future<void> checkInHabit(String habitId) async {
    try {
      await _habitService.checkInHabit(habitId);
      await loadHabits(); // 重新加载所有习惯
    } catch (e) {
      print('打卡失败: $e');
    }
  }
}