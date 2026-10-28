import 'package:flutter/material.dart';

/// 独立研究：约束传递 / FittedBox 缩放策略 / ClipPath 自定义剪裁。
/// 通过 URL 参数 ?page=N 直接打开对应实验（1约束 / 2缩放 / 3剪裁）。
void main() => runApp(const ResearchApp());

class ResearchApp extends StatelessWidget {
  const ResearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'layout_research',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final page = int.tryParse(Uri.base.queryParameters['page'] ?? '1') ?? 1;
    return DefaultTabController(
      length: 3,
      initialIndex: (page - 1).clamp(0, 2),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('独立研究：约束与缩放'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '1 约束传递'),
              Tab(text: '2 FittedBox'),
              Tab(text: '3 ClipPath'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ConstraintPage(),
            FittedBoxPage(),
            ClipPathPage(),
          ],
        ),
      ),
    );
  }
}

/// 实验1：约束传递——复现"撑不满"与"溢出"，解释成因。
class ConstraintPage extends StatelessWidget {
  const ConstraintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('现象A："撑不满"',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        // 撑不满：Center 给出松约束（0~maxWidth），子组件按内容尺寸报告
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              const Text('Center 里放红色 Container（未指定宽度）→ 只有小内容那么宽',
                  style: TextStyle(fontSize: 12)),
              const SizedBox(height: 6),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red,
                  child: const Text('我是子组件，按内容报告尺寸',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 10),
              const Text('同样的 Container，加上 width: double.infinity → 主动撑满松约束',
                  style: TextStyle(fontSize: 12)),
              const SizedBox(height: 6),
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.red,
                  child: const Text('width: double.infinity，撑满父给的约束',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('现象B："溢出"（黄黑条纹警告）',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('固定宽度 300 的 Row 里放一段长文本（未用 Expanded）→ 文本按固有宽度报告，超出约束',
                  style: TextStyle(fontSize: 12)),
              const SizedBox(height: 6),
              Container(
                width: 300,
                color: const Color(0xFFFFF3E0),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, color: Colors.orange),
                    const SizedBox(width: 8),
                    Container(
                      color: Colors.orange.shade200,
                      child: const Text(
                        '这段文字特别长特别长，Row 的剩余宽度根本装不下它，于是 RenderFlex overflow！',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text('修复：给文本套 Expanded → 只报告被分配到的宽度，不再溢出',
                  style: TextStyle(fontSize: 12)),
              const SizedBox(height: 6),
              Container(
                width: 300,
                color: const Color(0xFFE8F5E9),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        color: Colors.green.shade100,
                        child: const Text(
                          '这段文字特别长特别长，Row 的剩余宽度根本装不下它，于是 RenderFlex overflow！',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '结论（用 Inspector 读取约束验证）：\n'
            '① 父组件把约束传给子组件，子组件在约束内报告尺寸，父组件决定位置；\n'
            '② Center/Column 给的是松约束（最小0、最大为父值），子组件可以"撑不满"；\n'
            '③ 想撑满：width: double.infinity 或在 Row/Column 里用 Expanded；\n'
            '④ 溢出：子组件报告的尺寸超过了父约束（如 Row 里长文本不用 Expanded），'
            'DevTools Widget Inspector 里选中该 Row 可看到 300px 宽约束与子组件实际宽度。',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }
}

/// 实验2：FittedBox 三种缩放策略对比。
class FittedBoxPage extends StatelessWidget {
  const FittedBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    const content = Text(
      'FittedBox 缩放实验：这一行内容比容器宽',
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _case('对照：不套 FittedBox → 内容直接溢出黄黑警告',
            Container(
              width: 260,
              height: 70,
              color: Colors.blueGrey,
              alignment: Alignment.center,
              child: content,
            )),
        _case('fit: BoxFit.contain → 等比缩小，完整显示（上下留边）',
            FittedBox(
              fit: BoxFit.contain,
              child: Container(
                width: 260,
                height: 70,
                color: Colors.indigo,
                alignment: Alignment.center,
                child: content,
              ),
            )),
        _case('fit: BoxFit.fill → 拉伸填满，比例失真（文字变扁）',
            FittedBox(
              fit: BoxFit.fill,
              child: Container(
                width: 260,
                height: 70,
                color: Colors.teal,
                alignment: Alignment.center,
                child: content,
              ),
            )),
        _case('fit: BoxFit.scaleDown → 只在放不下时等比缩小，放得下就保持原尺寸',
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                width: 260,
                height: 70,
                color: Colors.orange,
                alignment: Alignment.center,
                child: content,
              ),
            )),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '选型结论：\n'
            '① 默认能放下时，scaleDown 与 contain 外观一致（都按原比例）；\n'
            '② contain 允许放大（内容小于容器时会放大占满），scaleDown 永不放大；\n'
            '③ fill 会改变宽高比，文字会变形，除非明确需要铺满否则不用；\n'
            '④ 容错兜底优先 scaleDown：既避免溢出，又不破坏原有视觉比例。',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }

  static Widget _case(String label, Widget demo) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Center(child: demo),
          ],
        ),
      );
}

/// 实验3：ClipPath 自定义剪裁——异形（波浪）卡片头图。
class ClipPathPage extends StatelessWidget {
  const ClipPathPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('用 CustomClipper<Path> 把头图剪成波浪形底边：',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Center(
          child: Container(
            width: 420,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: SizedBox(
                    width: double.infinity,
                    height: 190,
                    child: Image.asset('assets/images/cover.jpg', fit: BoxFit.cover),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('异形卡片头图',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text(
                        '头图底部经过两段二次贝塞尔曲线剪裁成波浪，'
                        '剪裁只影响显示区域，不改变布局占位。',
                        style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '实现要点：自定义 WaveClipper 继承 CustomClipper<Path>，'
            'getClip 里先 lineTo 到底部，再用 quadraticBezierTo 画两段曲线回到右下角；'
            'shouldReclip 在参数变化时返回 true 触发重新剪裁。',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }
}

/// 波浪剪裁器：底边剪出两段对称的波浪曲线
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, 0)
      ..lineTo(0, size.height - 36) // 左侧留出波浪起伏高度
      // 第一段曲线：波谷
      ..quadraticBezierTo(
          size.width * 0.25, size.height + 24, size.width * 0.5, size.height - 16)
      // 第二段曲线：波峰
      ..quadraticBezierTo(
          size.width * 0.75, size.height - 56, size.width, size.height - 20)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}
