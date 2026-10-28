# lecture6 · 基础组件与布局系统（第6课作业仓库）

MAPP 第6课（基础组件与布局系统）作业代码与进度报告。

## 目录结构

| 目录 | 内容 |
|------|------|
| `profile_card/` | 课堂案例复现：个人名片页（骨架对齐 → 容器美化与徽标 → 设计稿验收，三步三次提交） |
| `layout_practice/` | 自主实践：对齐任务卡（6场景）/ 弹性分配 2:1:1 实验 / 层叠角标 / 容器美化 |
| `layout_research/` | 独立研究：约束传递（撑不满与溢出）/ FittedBox 缩放策略对比 / ClipPath 波浪剪裁 |
| `screenshots/` | 全屏截图证据（含任务栏时间） |
| `progress.md` | 进度报告（Markdown 版） |
| `mapp-progress-report-6.docx` | 进度报告（提交版） |

## 运行方式

任一工程目录下执行（需 Flutter 3.x 与 Chrome）：

```bash
flutter run -d chrome
# 或
flutter run -d web-server --web-port 8090
# 浏览器访问 http://localhost:8090
# layout_practice / layout_research 支持 ?page=N 直接打开对应实验页
```

## Git 提交记录（节选）

- `feat: profile skeleton with alignment` —— 步骤一：骨架与对齐
- `feat: card decoration & status badge` —— 步骤二：容器美化与在线徽标
- `feat: match design spec, zero overflow warnings` —— 步骤三：设计稿对照验收
- `feat: layout practice demos (alignment/flex/stack/container)` —— 自主实践四项
- `feat: layout research experiments (constraints/fittedbox/clippath)` —— 独立研究三项
- `fix/style` 若干：FittedBox 演示修正、紧凑布局微调

## AI 使用说明

本次作业由 Trae（AI 编程助手）辅助完成，本人逐项运行验证并修正，符合课程"AI 辅助完成并验证、标注使用方式"的要求，详见 progress.md 第七节。
