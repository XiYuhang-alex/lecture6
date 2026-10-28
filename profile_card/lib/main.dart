import 'package:flutter/material.dart';

void main() => runApp(const ProfileCardApp());

class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'profile_card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const ProfileCardPage(),
    );
  }
}

/// 个人名片页：Scaffold + Column 骨架。
/// 步骤一：只管结构与对齐，不做装饰。
class ProfileCardPage extends StatelessWidget {
  const ProfileCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('个人名片页'), centerTitle: true),
      body: Center(
        // 卡片固定宽度，居中显示
        child: SizedBox(
          width: 340,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. 头像区
              const CircleAvatar(
                radius: 44,
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
              ),
              const SizedBox(height: 12),
              // 2. 姓名与签名（两行 Text）
              const Text(
                'Alex Xi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Flutter 初学者 · 正在攻克布局系统',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              // 3. 统计条：三个 Expanded 数字块，按比例平分宽度
              Row(
                children: [
                  _statBlock('128', '动力'),
                  _statBlock('256', '好友'),
                  _statBlock('1024', '获赞'),
                ],
              ),
              const SizedBox(height: 16),
              // 4. 标签云：Wrap 按行流动排列
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: const [
                  Chip(
                    label: Text('Flutter'),
                    backgroundColor: Color(0xFFE8EAF6),
                  ),
                  Chip(label: Text('Dart'), backgroundColor: Color(0xFFE8F5E9)),
                  Chip(
                    label: Text('基础组件'),
                    backgroundColor: Color(0xFFFFF8E1),
                  ),
                  Chip(
                    label: Text('布局系统'),
                    backgroundColor: Color(0xFFFCE4EC),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 单个统计数字块：数字 + 标签纵向排列，外层 Expanded 平分横向空间
  static Widget _statBlock(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}
