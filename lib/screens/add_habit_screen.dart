import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/habit_model.dart';
import '../providers/habit_provider.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _badHabitController = TextEditingController();
  final _goodHabitController = TextEditingController();
  int _challengeDays = 21; // 默认21天挑战

  bool _isSubmitting = false;

  @override
  void dispose() {
    _badHabitController.dispose();
    _goodHabitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建新挑战'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 坏习惯输入
              TextFormField(
                controller: _badHabitController,
                decoration: const InputDecoration(
                  labelText: '想要改掉的习惯',
                  hintText: '例如：熬夜刷手机',
                  prefixIcon: Icon(Icons.block),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入想要改掉的习惯';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 好习惯输入
              TextFormField(
                controller: _goodHabitController,
                decoration: const InputDecoration(
                  labelText: '替代的好习惯',
                  hintText: '例如：晚上10点阅读',
                  prefixIcon: Icon(Icons.check_circle),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入替代的好习惯';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // 挑战天数选择
              const Text(
                '挑战天数',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildDaysSelector(),
              const SizedBox(height: 16),
              
              // 挑战说明
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '挑战说明',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• 每当你想要进行坏习惯时，尝试用好习惯代替它\n'
                        '• 每天坚持打卡记录你的进步\n'
                        '• 研究表明，养成一个新习惯通常需要21-66天',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // 提交按钮
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('开始挑战', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaysSelector() {
    return Wrap(
      spacing: 8,
      children: [21, 30, 60, 90, 100].map((days) {
        return ChoiceChip(
          label: Text('$days天'),
          selected: _challengeDays == days,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _challengeDays = days;
              });
            }
          },
        );
      }).toList(),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final habitProvider = Provider.of<HabitProvider>(context, listen: false);
      
      final newHabit = Habit(
        badHabit: _badHabitController.text.trim(),
        goodHabit: _goodHabitController.text.trim(),
        challengeDays: _challengeDays,
        startDate: DateTime.now(),
      );
      
      await habitProvider.addHabit(newHabit);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('挑战创建成功！')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('创建失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}