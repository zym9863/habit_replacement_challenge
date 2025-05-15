import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/habit_model.dart';
import '../providers/habit_provider.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habit;

  const HabitDetailScreen({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.goodHabit), // 显示良好习惯作为标题
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0, // 与首页 AppBar 风格统一
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHabitInfo(context),
            const SizedBox(height: 24),
            _buildProgressSection(context),
            const SizedBox(height: 24),
            _buildCheckInCalendar(context),
            const SizedBox(height: 24),
            _buildMotivationCard(context), // 传递 context
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHabitInfo(BuildContext context) {
    final Color badHabitColor = habit.badHabitColor ?? Theme.of(context).colorScheme.error;
    final Color goodHabitColor = habit.goodHabitColor ?? Theme.of(context).colorScheme.secondary;
    final IconData badHabitIcon = habit.badHabitIcon ?? Icons.remove_circle_outline;
    final IconData goodHabitIcon = habit.goodHabitIcon ?? Icons.check_circle_outline;

    return Card(
      elevation: 2, // 降低一些阴影，使其更柔和
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // 与首页卡片圆角一致
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 统一外边距
      child: Padding(
        padding: const EdgeInsets.all(20), // 增加内边距
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '习惯目标',
              style: TextStyle(
                fontSize: 20, // 稍大字体
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              '不再做', 
              habit.badHabit, 
              badHabitIcon, 
              badHabitColor,
              context
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              '替换为', 
              habit.goodHabit, 
              goodHabitIcon, 
              goodHabitColor,
              context
            ),
            const Divider(height: 32, thickness: 0.5),
            _buildInfoRow(
              '开始日期', 
              DateFormat('yyyy年MM月dd日').format(habit.startDate),
              Icons.calendar_today_outlined, // 使用 outlined 图标
              Theme.of(context).colorScheme.onSurfaceVariant,
              context,
              isSecondary: true,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              '挑战天数', 
              '${habit.challengeDays} 天',
              Icons.flag_outlined, // 使用 outlined 图标
              Theme.of(context).colorScheme.onSurfaceVariant,
              context,
              isSecondary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color, BuildContext context, {bool isSecondary = false}) {
    final textStyle = TextStyle(
      fontSize: isSecondary ? 15 : 17, // 主要信息字体稍大
      fontWeight: isSecondary ? FontWeight.normal : FontWeight.w500,
      color: isSecondary ? Theme.of(context).colorScheme.onSurfaceVariant : color,
    );
    final labelStyle = TextStyle(
      fontSize: isSecondary ? 14 : 16,
      fontWeight: FontWeight.bold,
      color: isSecondary ? Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8) : color,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: isSecondary ? 20 : 24), // 主要图标稍大
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: labelStyle,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: textStyle,
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final progressPercent = (habit.completionRate * 100).toInt();
    final daysCompleted = habit.checkInRecords.where((checked) => checked).length;
    
    Color progressColor;
    if (progressPercent < 30) {
      progressColor = Colors.orangeAccent;
    } else if (progressPercent < 70) {
      progressColor = Colors.lightBlueAccent;
    } else {
      progressColor = Colors.greenAccent;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '挑战进度',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // 与首页一致
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                        begin: 0, // 可以从上次的进度开始，如果需要更复杂的动画
                        end: habit.completionRate,
                      ),
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: value,
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                          color: progressColor,
                          minHeight: 12, // 稍粗一点
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$progressPercent%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // 更均匀分布
              children: [
                _buildProgressStat(
                  context,
                  '已完成', 
                  '$daysCompleted 天', 
                  Icons.check_circle_outline_rounded, 
                  Theme.of(context).colorScheme.secondary
                ),
                _buildProgressStat(
                  context,
                  '当前第', 
                  '${habit.currentDay} 天', 
                  Icons.trending_up_rounded, 
                  Theme.of(context).colorScheme.tertiary
                ),
                _buildProgressStat(
                  context,
                  '剩余', 
                  '${habit.challengeDays - habit.currentDay +1} 天', // 修正剩余天数计算
                  Icons.hourglass_empty_rounded, 
                  Theme.of(context).colorScheme.onSurfaceVariant
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStat(BuildContext context, String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label, 
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7), 
            fontSize: 13
          )
        ),
        const SizedBox(height: 2),
        Text(
          value, 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 17,
            color: color,
          )
        ),
      ],
    );
  }

  Widget _buildCheckInCalendar(BuildContext context) {
    final todayColor = Theme.of(context).colorScheme.primary;
    final checkedInColor = Theme.of(context).colorScheme.secondary;
    final missedColor = Theme.of(context).colorScheme.error.withOpacity(0.7);
    final futureColor = Theme.of(context).colorScheme.surfaceVariant;
    final defaultDayColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '打卡日历',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.1, // 调整宽高比使格子更美观
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: habit.challengeDays,
              itemBuilder: (context, index) {
                final day = index + 1;
                final isCheckedIn = index < habit.checkInRecords.length && habit.checkInRecords[index];
                final isToday = index == habit.currentDay - 1;
                final isPast = index < habit.currentDay - 1;

                Color tileColor;
                Color textColor = defaultDayColor;
                Widget? icon;

                if (isCheckedIn) {
                  tileColor = checkedInColor.withOpacity(0.15);
                  textColor = checkedInColor;
                  icon = Icon(Icons.check_circle_rounded, color: checkedInColor, size: 18);
                } else if (isToday) {
                  tileColor = todayColor.withOpacity(0.1);
                  textColor = todayColor;
                } else if (isPast) {
                  tileColor = missedColor.withOpacity(0.1);
                  textColor = missedColor;
                  icon = Icon(Icons.cancel_rounded, color: missedColor, size: 18);
                } else { // isFuture
                  tileColor = futureColor.withOpacity(0.5);
                  textColor = Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6);
                }
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: tileColor,
                    borderRadius: BorderRadius.circular(10), // 更圆润的格子
                    border: isToday && !isCheckedIn
                        ? Border.all(color: todayColor, width: 1.5)
                        : null,
                    boxShadow: isToday && !isCheckedIn ? [
                      BoxShadow(
                        color: todayColor.withOpacity(0.3),
                        blurRadius: 3,
                        spreadRadius: 1
                      )
                    ] : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.toString(),
                        style: TextStyle(
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          fontSize: 15,
                          color: textColor,
                        ),
                      ),
                      if (icon != null) ...[
                        const SizedBox(height: 2),
                        icon,
                      ]
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(context, checkedInColor.withOpacity(0.8), '已打卡'),
                _buildLegendItem(context, todayColor, '今天'),
                _buildLegendItem(context, missedColor, '未打卡'),
                _buildLegendItem(context, defaultDayColor.withOpacity(0.6), '未来'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3), // 图例颜色稍浅以区分
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: color, width: 1)
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label, 
          style: TextStyle(
            fontSize: 12, 
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8)
          )
        ),
      ],
    );
  }

  Widget _buildMotivationCard(BuildContext context) { // 添加 BuildContext context 参数
    final motivationalQuotes = [
      '每一个微小的改变，都是通往更好自己的一步。',
      '习惯决定命运，今天的选择塑造明天的你。',
      '不要等待完美的时刻，现在就行动。',
      '坚持不是因为看到希望才去坚持，而是坚持了才会看到希望。',
      '改变习惯，就是改变人生。',
      '成功的秘诀在于对目标的执着追求。',
      '小习惯，大成就。',
      '自律即自由。'
    ];
    
    final quoteIndex = habit.id.hashCode % motivationalQuotes.length;
    final quote = motivationalQuotes[quoteIndex.abs()];
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.7), // 使用主题颜色
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Icon(
              Icons.emoji_objects_outlined, // 更换图标
              color: Theme.of(context).colorScheme.onTertiaryContainer, 
              size: 36
            ),
            const SizedBox(height: 12),
            Text(
              quote,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.9),
                height: 1.5, // 增加行高
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final bool isCheckedIn = habit.isTodayCheckedIn;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20), // 调整内边距
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // 使用主题表面颜色
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // 更柔和的阴影
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        // 可以考虑顶部圆角，如果设计需要
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(20),
        //   topRight: Radius.circular(20),
        // )
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: ElevatedButton(
          onPressed: isCheckedIn
              ? null
              : () async {
                  final navigator = Navigator.of(context); // 在异步操作前获取 Navigator
                  final scaffoldMessenger = ScaffoldMessenger.of(context); // 在异步操作前获取 ScaffoldMessenger
                  await habitProvider.checkInHabit(habit.id);
                  // 不再需要检查 context.mounted，因为已经在异步操作前获取了 navigator 和 scaffoldMessenger
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: const Text('今日打卡成功！继续加油！'),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      behavior: SnackBarBehavior.floating, // 浮动效果
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                  navigator.pop(); // 返回上一页
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18), // 增加按钮高度
            backgroundColor: isCheckedIn 
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3) // 已打卡颜色
                : Theme.of(context).colorScheme.secondary, // 未打卡颜色
            foregroundColor: isCheckedIn
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                : Theme.of(context).colorScheme.onSecondary,
            disabledBackgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
            disabledForegroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
            elevation: isCheckedIn ? 0 : 5, // 根据状态调整阴影
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // 与首页按钮一致的圆角
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher( // 为图标切换添加动画
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isCheckedIn ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                  key: ValueKey<bool>(isCheckedIn), // 确保动画正确触发
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                isCheckedIn ? '今日已打卡' : '完成今日打卡',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
