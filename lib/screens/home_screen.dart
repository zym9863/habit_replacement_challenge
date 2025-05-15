import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/habit_model.dart';
import '../providers/habit_provider.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 加载习惯数据
    Future.microtask(() => 
      Provider.of<HabitProvider>(context, listen: false).loadHabits()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('不如换掉它'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          if (habitProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (habitProvider.habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sentiment_satisfied_alt, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    '还没有习惯挑战',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '点击下方按钮创建一个新的习惯替换挑战',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _navigateToAddHabit(context),
                    child: const Text('创建新挑战'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: habitProvider.habits.length,
            itemBuilder: (context, index) {
              final habit = habitProvider.habits[index];
              return _buildHabitCard(context, habit);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddHabit(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitCard(BuildContext context, Habit habit) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final progress = (habit.completionRate * 100).toInt();
    final formattedDate = DateFormat('yyyy-MM-dd').format(habit.startDate);
    
    // 为习惯设置默认颜色和图标
    final badHabitColor = habit.badHabitColor ?? Theme.of(context).colorScheme.error;
    final goodHabitColor = habit.goodHabitColor ?? Theme.of(context).colorScheme.secondary;
    final badHabitIcon = habit.badHabitIcon ?? Icons.remove_circle;
    final goodHabitIcon = habit.goodHabitIcon ?? Icons.check_circle;
    
    // 根据完成率设置进度条颜色
    Color progressColor;
    if (progress < 30) {
      progressColor = Colors.orange;
    } else if (progress < 70) {
      progressColor = Colors.blue;
    } else {
      progressColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => habitProvider.deleteHabit(habit.id),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '删除',
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
            ),
          ],
        ),
        child: Card(
          child: InkWell(
            onTap: () => _navigateToHabitDetail(context, habit),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题和打卡按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 不良习惯
                            Row(
                              children: [
                                Icon(badHabitIcon, color: badHabitColor, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '不做: ${habit.badHabit}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: badHabitColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // 良好习惯
                            Row(
                              children: [
                                Icon(goodHabitIcon, color: goodHabitColor, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '改做: ${habit.goodHabit}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: goodHabitColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildCheckInButton(context, habit),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // 进度条
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: habit.completionRate,
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      color: progressColor,
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // 进度信息
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 进度百分比和状态
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '进度: $progress%',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: progressColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: progressColor, width: 1),
                            ),
                            child: Text(
                              habit.statusText,
                              style: TextStyle(
                                fontSize: 12,
                                color: progressColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // 日期和连续打卡信息
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (habit.currentStreak > 0)
                            Row(
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '连续打卡: ${habit.currentStreak}天',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInButton(BuildContext context, Habit habit) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final bool isCheckedIn = habit.isTodayCheckedIn;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ElevatedButton(
        onPressed: isCheckedIn ? null : () => habitProvider.checkInHabit(habit.id),
        style: ElevatedButton.styleFrom(
          backgroundColor: isCheckedIn 
              ? Colors.grey[400] 
              : Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.white,
          elevation: isCheckedIn ? 0 : 4,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCheckedIn ? Icons.check_circle : Icons.check_circle_outline,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              isCheckedIn ? '已打卡' : '打卡',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddHabit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    );
  }

  void _navigateToHabitDetail(BuildContext context, Habit habit) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HabitDetailScreen(habit: habit)),
    );
  }
}