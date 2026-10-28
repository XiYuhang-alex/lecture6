# 进度报告6（第8周 · 基础组件与布局系统）

> 姓名：习宇航（XiYuhang-alex）　学号：见雨课堂　日期：2026-10-28
> 说明：6A 扩展练习本次不做；其余（案例复现、自主实践、独立研究）全部完成。

## 一、任务理解

本课主题是**基础组件与布局系统**。围绕"父给约束 → 子报尺寸 → 父定位置"这一布局心智模型，我需要完成三件事：

1. **案例复现**：按三步复现个人名片页 `profile_card`——骨架与对齐、容器美化（圆角/阴影/留白）与 Stack 在线徽标、设计稿对照验收，每步一次规范 Git 提交，全程无 RenderFlex 溢出告警；
2. **自主实践**：对齐任务卡六种对齐场景逐一实现并标注参数、三栏 2:1:1 弹性分配实验与"一栏内容超长"的表现记录、层叠角标两场景（头像徽标+图片浮层文字）、容器美化至少两处；
3. **独立研究**：约束传递实验（复现"撑不满"与"溢出"并用 Inspector 读约束解释成因）、FittedBox 三种缩放策略对比与选型结论、ClipPath 自定义剪裁异形卡片头图。

所有代码推送到 GitHub 仓库 `lecture6`，并按模板完成本进度报告。

## 二、环境与工具

| 项目 | 配置 |
|------|------|
| Flutter | 3.47.2（Windows） |
| 调试目标 | Chrome（`flutter run -d web-server --web-port 8090` 后访问 localhost:8090） |
| 编辑器 | Trae（AI 辅助编码） |
| 版本管理 | Git 2.51 + GitHub 仓库 XiYuhang-alex/lecture6 |
| 截图方式 | PowerShell 全屏截取（整屏含桌面与任务栏时间） |
| 图片素材 | 本仓库自带资产（`assets/images/` 头像与封面图），不使用来路不明的网络图片 |

## 三、过程记录

1. `flutter create profile_card`（web/windows），完成**步骤一**骨架：Scaffold + Center + SizedBox(340) + Column——CircleAvatar(44) 头像、两行 Text（姓名/签名）、Row 内三个 Expanded 统计块、Wrap 标签云；提交 `feat: profile skeleton with alignment`；
2. **步骤二**：整体卡片 Container（白底、圆角16、阴影、内边距24）+ 统计条 Container（浅底、圆角12）+ 头像 Stack+Positioned 绿色在线徽标；提交 `feat: card decoration & status badge`；
3. **步骤三故意实验**：把统计块外层 Expanded 临时去掉——128/256/1024 立即挤成一团（截图03）；随后恢复 Expanded，无任何溢出告警；提交 `feat: match design spec, zero overflow warnings`；
4. 自主实践工程 `layout_practice`：一个应用四个 Tab（URL 参数 `?page=N` 直达），完成六场景对齐卡、弹性实验、层叠角标、容器美化四项；提交 `feat: layout practice demos (...)`；
5. 独立研究工程 `layout_research`：三页 Tab 完成约束传递、FittedBox、ClipPath 三项；期间修正 FittedBox 演示（见"问题与调试"问题2），提交 `feat: layout research experiments (...)` 与 `fix: fittedbox demo ...`；
6. 每个关键节点全屏截图存档，最终以 `git log` 与 GitHub 仓库页面留证。

## 四、关键代码

**统计条——Expanded 平分剩余空间**（`profile_card/lib/main.dart`）：

```dart
Row(
  children: [
    _statBlock('128', '动力'),   // Expanded 内部：数字+标签纵向排列
    _statBlock('256', '好友'),
    _statBlock('1024', '获赞'),
  ],
)

static Widget _statBlock(String value, String label) {
  return Expanded(                    // 去掉它，三个块立即挤成一团
    child: Column(children: [
      Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
    ]),
  );
}
```

**层叠徽标——Stack + Positioned**：

```dart
Stack(children: [
  const CircleAvatar(radius: 44, backgroundImage: AssetImage('assets/images/avatar.jpg')),
  Positioned(                       // 非定位子组件决定 Stack 尺寸，徽标只负责覆盖
    right: 2, bottom: 2,
    child: Container(width: 16, height: 16,
      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2))),
  ),
])
```

**图片浮层文字**（`layout_practice`）：`Stack` + 底部 `Positioned` 渐变遮罩 Container + 白色文字。

**波浪剪裁**（`layout_research`）：自定义 `WaveClipper extends CustomClipper<Path>`，`getClip` 里两段 `quadraticBezierTo` 画出头图波浪底边。

## 五、检查点结果

- **与设计稿一致**：结构四件套齐全（头像区/姓名签名/统计条/标签云），间距按骨架核对（头像半径44、卡片圆角16、内边距24、统计条圆角12）✓ 最终效果见截图04；
- **运行无 RenderFlex 溢出告警**：最终版控制台无任何 overflow 告警 ✓（故意去掉 Expanded 的挤团现象见截图03，恢复后正常）；
- **口头解释**：统计条为什么必须用 Expanded——因为三个数字块要求**始终等分横向剩余空间**：Expanded 把 Row 的剩余约束按 flex 强制分给每个子块，内容再短也不会缩；去掉 Expanded 后子组件只按内容报告尺寸，三块立即挤到左边成一团。

## 六、问题与调试

**问题1：去掉 Expanded 后统计条挤成一团。**
复现：临时把 `_statBlock` 外层 Expanded 摘掉（截图03，1282561024 挤在一起）。
定位：用 DevTools 的 Widget Inspector 展开该 Row 的子树（截图12），可以看到未加 Expanded 时子组件收到的是**松约束**，各自按内容尺寸报告，Row 主轴的剩余空间无人认领；Expanded 的作用正是把父约束按 flex 切分并**强制子组件撑满分配额**。
修复：恢复 Expanded，重新运行无任何告警（截图04）。

**问题2：FittedBox 四种 fit 看不出差别。**
复现：第一版演示把长文本放进 260×70 的固定 Container 再套 FittedBox，四个盒子几乎一模一样（截图初次尝试）。
定位：用 Inspector 查看 FittedBox 的 child 实际尺寸——固定宽度的 Container 让文本在 260px 内**换行**，child 恰好约 260×56，缩放比≈1，自然看不出差异。
修复：把内容改成 `softWrap: false` 的单行长文本（固有宽约 500px），对照组用 Row 复现出黄黑溢出条纹，contain/fill/scaleDown 立刻拉开差距，并补了"放得下时 contain 放大 vs scaleDown 不放大"的对照组（截图10）。

**问题3：约束传递"撑不满/溢出"复现**（独立研究任务1）：Center 给出松约束，红色 Container 不指定宽度时只包内容（撑不满）；Row 里长文本不用 Expanded 时按固有宽 500px 报告、超出 300px 容器约束 → 黄黑条纹；套 Expanded 后子组件只报告被分配的宽度，溢出消失（截图09）。

## 七、AI 使用记录（使用方式标注）

本次作业在 **Trae（AI 编程助手）**辅助下完成，属于"AI 辅助完成并验证"：

- AI 起草了三个工程的代码、运行与截图脚本、报告初稿；
- 本人对每个实验**逐页运行验证**（全屏截图核对渲染效果），并亲手推动了两处关键修正：FittedBox 演示改为单行文本才能暴露差异、对齐/弹性页面压缩到一屏；
- 所有结论（Expanded 作用、FittedBox 选型、约束传递成因）均在运行现象中核对后才写入报告；
- Git 提交信息、README、报告为 AI 起草 + 本人确认，AI 使用记录真实可追溯（本节即标注）。

## 八、证据截图

| 编号 | 内容 | 文件 |
|------|------|------|
| 01 | 步骤一：骨架与对齐（无装饰） | `screenshots/01-profile-skeleton.png` |
| 02 | 步骤二：容器美化 + 在线徽标 | `screenshots/02-profile-decorated.png` |
| 03 | 步骤三实验：去掉 Expanded 挤成一团 | `screenshots/03-profile-expanded-removed.png` |
| 04 | 步骤三最终版：设计稿对照验收通过 | `screenshots/04-profile-final.png` |
| 05 | 自主实践1：对齐任务卡六场景 | `screenshots/05-practice-alignment.png` |
| 06 | 自主实践2：弹性 2:1:1 + 超长内容表现 | `screenshots/06-practice-flex.png` |
| 07 | 自主实践3：层叠角标两场景 | `screenshots/07-practice-stack.png` |
| 08 | 自主实践4：容器美化（圆角/阴影/剪裁） | `screenshots/08-practice-container.png` |
| 09 | 独立研究1：约束传递（撑不满/溢出/修复） | `screenshots/09-research-constraint.png` |
| 10 | 独立研究2：FittedBox 三种策略对比 | `screenshots/10-research-fittedbox.png` |
| 11 | 独立研究3：ClipPath 波浪头图 | `screenshots/11-research-clippath.png` |
| 12 | DevTools Widget Inspector 定位过程 | `screenshots/12-devtools-inspector.png` |
| 13 | Git 提交记录（git log 全屏） | `screenshots/13-git-log.png` |
| 14 | GitHub 仓库 lecture6 已推送 | `screenshots/14-github-repo.png` |

## 九、自评

| 评分项 | 自评 | 依据 |
|--------|------|------|
| 案例复现（15） | 15 | 三步全部完成，三次规范提交，最终版无溢出 |
| 检查点（5） | 5 | 结构/无告警/Expanded 解释三项均落实 |
| Git 规范（5） | 5 | feat:/fix: 前缀、粒度清晰、仓库含 README |
| 报告记录（5） | 5 | 十节齐全，14 张全屏截图可追溯 |

自主实践四项全部完成；独立研究三项全部完成（含两个"故意实验"与一次真实调试回环）。
不足：课堂设计稿原件未在手边，卡片样式按指引描述还原；DevTools 属性面板数值未截到，以 Inspector 树定位 + 运行现象截图为准。

## 十、一句话收获与下一步计划

**收获**：约束传递是布局的心智模型核心——"父给约束、子报尺寸、父定位置"；Expanded、FittedBox、Stack/Positioned、ClipPath 全是围绕这条链路做文章。
**下一步**：进入第7课前把 Widget Inspector 的约束/尺寸面板用熟，并补做 6A 扩展练习。
