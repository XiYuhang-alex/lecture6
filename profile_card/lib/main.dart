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
/// 步骤三：设计稿对照验收——结构、间距、层级核对通过；
/// 去掉/恢复 Expanded 实验完成，运行无 RenderFlex 溢出告警。
class ProfileCardPage extends StatelessWidget {
  const ProfileCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('个人名片页'), centerTitle: true),
      body: Center(
        child: SizedBox(
          width: 360,
          // 整体卡片容器：圆角 + 阴影 + 留白
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. 头像区：Stack 层叠出右下角在线徽标
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 44,
                      backgroundImage: AssetImage('assets/images/avatar.jpg'),
                    ),
                    // 非定位子组件决定 Stack 尺寸，Positioned 徽标覆盖在右下角
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
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
                // 3. 统计条：Container 装饰 + 三个 Expanded 数字块
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _statBlock('128', '动力'),
                      _statBlock('256', '好友'),
                      _statBlock('1024', '获赞'),
                    ],
                  ),
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
