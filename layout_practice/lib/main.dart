import 'package:flutter/material.dart';

/// 自主实践：基础组件与布局系统四项任务。
/// 通过 URL 参数 ?page=N 直接打开对应任务页（1对齐 / 2弹性 / 3层叠 / 4美化），
/// 便于逐项截图记录。
void main() => runApp(const PracticeApp());

class PracticeApp extends StatelessWidget {
  const PracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'layout_practice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 读取 URL 参数，默认从第一页开始
    final page = int.tryParse(Uri.base.queryParameters['page'] ?? '1') ?? 1;
    return DefaultTabController(
      length: 4,
      initialIndex: (page - 1).clamp(0, 3),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('自主实践：基础组件与布局'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '1 对齐任务卡'),
              Tab(text: '2 弹性分配'),
              Tab(text: '3 层叠角标'),
              Tab(text: '4 容器美化'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AlignmentCardPage(),
            FlexPage(),
            StackBadgePage(),
            BeautyPage(),
          ],
        ),
      ),
    );
  }
}

/// 任务1：对齐任务卡——六种对齐场景逐一实现，参数写在标签里。
class AlignmentCardPage extends StatelessWidget {
  const AlignmentCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _scene('场景1 Row + mainAxisAlignment.start（主轴起点对齐）', Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _boxes(),
        )),
        _scene('场景2 Row + mainAxisAlignment.center（主轴居中对齐）', Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _boxes(),
        )),
        _scene('场景3 Row + MainAxisAlignment.end（主轴终点对齐）', Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _boxes(),
        )),
        _scene('场景4 Row + MainAxisAlignment.spaceBetween（两端对齐，中间均分）', Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _boxes(),
        )),
        _scene('场景5 Row + MainAxisAlignment.spaceAround（两侧留白为一半）', Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _boxes(),
        )),
        _scene('场景6 Row + crossAxisAlignment.baseline（文本基线对齐）', Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: const [
            Text('大号', style: TextStyle(fontSize: 30, color: Colors.indigo)),
            SizedBox(width: 8),
            Text('中号', style: TextStyle(fontSize: 20, color: Colors.teal)),
            SizedBox(width: 8),
            Text('小号', style: TextStyle(fontSize: 13, color: Colors.pink)),
          ],
        )),
      ],
    );
  }

  static List<Widget> _boxes() => [
        _box('A', Colors.indigo),
        _box('B', Colors.teal),
        _box('C', Colors.orange),
      ];

  static Widget _box(String t, Color c) => Container(
        width: 64,
        height: 44,
        alignment: Alignment.center,
        color: c,
        child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 18)),
      );

  static Widget _scene(String label, Widget demo) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: demo,
            ),
          ],
        ),
      );
}

/// 任务2：弹性分配实验——三栏 2:1:1 布局 + 一栏内容超长的表现记录。
class FlexPage extends StatelessWidget {
  const FlexPage({super.key});

  @override
  Widget build(BuildContext context) {
    const longText =
        '这一栏的内容非常长很长特别长，用来验证 Expanded 给它分配了多少宽度，超出的文字会被约束在这个宽度之内换行显示。';
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _item('实验A：三栏 flex 2:1:1（LayoutBuilder 显示每栏实际宽度）', Row(
          children: [
            _flexBlock(2, Colors.indigo, 'flex: 2'),
            _flexBlock(1, Colors.teal, 'flex: 1'),
            _flexBlock(1, Colors.orange, 'flex: 1'),
          ],
        )),
        const SizedBox(height: 14),
        _item('实验B：中栏（flex:1）放入超长文本 → 被约束在分配宽度内自动换行', Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _flexBlock(2, Colors.indigo, 'flex: 2'),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal,
                child: Text(longText,
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
              ),
            ),
            _flexBlock(1, Colors.orange, 'flex: 1'),
          ],
        )),
        const SizedBox(height: 14),
        _item('实验C：同样超长文本 maxLines:1 + ellipsis → 溢出部分省略号收尾', Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _flexBlock(2, Colors.indigo, 'flex: 2'),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal,
                child: const Text(longText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              ),
            ),
            _flexBlock(1, Colors.orange, 'flex: 1'),
          ],
        )),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '表现记录：\n'
            '① 三栏宽度始终按 2:1:1 比例分配剩余空间，与内容长短无关；\n'
            '② 超长文本被 Expanded 约束在本栏宽度内，自动换行，不会把别的栏挤走；\n'
            '③ 若限 maxLines:1，溢出内容按 ellipsis 策略显示省略号。',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }

  static Widget _flexBlock(int flex, Color color, String label) => Expanded(
        flex: flex,
        child: LayoutBuilder(builder: (context, c) {
          return Container(
            height: 72,
            color: color,
            alignment: Alignment.center,
            child: Text(
              '$label\n实际 ${c.maxWidth.toStringAsFixed(0)}px',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          );
        }),
      );

  static Widget _item(String label, Widget demo) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          demo,
        ],
      );
}

/// 任务3：层叠角标——头像徽标 + 图片浮层文字两个场景。
class StackBadgePage extends StatelessWidget {
  const StackBadgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _caption('场景1：头像右下角在线徽标（Stack + Positioned）'),
        Center(
          child: Stack(
            children: [
              const CircleAvatar(
                radius: 52,
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
              ),
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _caption('场景2：图片浮层文字（Stack + Positioned + 渐变遮罩）'),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 420,
              child: Stack(
                children: [
                  Image.asset('assets/images/cover.jpg',
                      width: 420, fit: BoxFit.cover),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                      child: const Text(
                        '远山与湖面 · 用 Positioned 把文字钉在图片底部',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          '要点：非定位子组件（头像/图片）参与 Stack 尺寸计算；'
          'Positioned 子组件不参与，只按 left/top/right/bottom 覆盖定位。',
          style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
        ),
      ],
    );
  }

  static Widget _caption(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      );
}

/// 任务4：容器美化——圆角、阴影、留白、剪裁至少两处。
class BeautyPage extends StatelessWidget {
  const BeautyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 美化1：卡片容器（圆角 + 阴影 + 留白）
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('卡片美化 1：圆角 + 阴影 + 留白',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('BoxDecoration(color/borderRadius(16)/boxShadow) + EdgeInsets.all(16)',
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 美化2：ClipRRect 圆角图片卡
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: double.infinity,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/cover.jpg', fit: BoxFit.cover),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('卡片美化 2：ClipRRect 圆角剪裁图片',
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 美化3：ClipOval 圆形剪裁
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                ClipOval(
                  child: Image.asset('assets/images/cover.jpg',
                      width: 96, height: 96, fit: BoxFit.cover),
                ),
                const SizedBox(height: 6),
                const Text('ClipOval 圆形剪裁', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(width: 24),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/cover.jpg',
                      width: 96, height: 96, fit: BoxFit.cover),
                ),
                const SizedBox(height: 6),
                const Text('ClipRRect 圆角 20', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
