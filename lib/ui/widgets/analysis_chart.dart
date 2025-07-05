// import 'package:flutter/foundation.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class AnalysisSection {
//   const AnalysisSection({required this.title, required this.value, this.color});
//   final String title;
//   final double value;
//   final Color? color;
// }

// class AnalysisChart extends StatefulWidget {
//   const AnalysisChart({
//     Key? key,
//     required this.sections,
//     this.radius = 50,
//     this.strokeWidth = 12,
//     this.legendGap = 8,
//     this.animationDuration = const Duration(seconds: 8),
//   }) : super(key: key);

//   final List<AnalysisSection> sections;
//   final double radius;
//   final double strokeWidth;
//   final double legendGap;
//   final Duration animationDuration;

//   @override
//   State<AnalysisChart> createState() => _AnalysisChartState();
// }

// class _AnalysisChartState extends State<AnalysisChart>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _rotationAnim;
//   late Animation<double> _fadeOutAnim;
//   late Animation<double> _fadeInAnim;

//   List<AnalysisSection> _oldSections = [];
//   List<AnalysisSection> _newSections = [];
//   bool _swapped = false;

//   @override
//   void initState() {
//     super.initState();
//     _oldSections = widget.sections;
//     _newSections = widget.sections;

//     _ctrl = AnimationController(
//       vsync: this,
//       duration: widget.animationDuration,
//     );

//     _rotationAnim = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

//     _fadeOutAnim = Tween<double>(begin: 1, end: 0).animate(
//       CurvedAnimation(
//         parent: _ctrl,
//         curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
//       ),
//     );

//     _fadeInAnim = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _ctrl,
//         curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
//       ),
//     );

//     _ctrl.addListener(
//       () => setState(() {
//         _animationTick();
//       }),
//     );
//   }

//   @override
//   void didUpdateWidget(covariant AnalysisChart old) {
//     super.didUpdateWidget(old);
//     if (!listEquals(old.sections, widget.sections)) {
//       _newSections = widget.sections;
//       _swapped = false;
//       _ctrl.duration = widget.animationDuration;
//       _ctrl.forward(from: 0);
//     }
//   }

//   void _animationTick() {
//     if (!_swapped && _ctrl.value >= 0.5) {
//       _oldSections = _newSections;
//       _swapped = true;
//     }
//     if (_ctrl.value >= 1.0) {
//       _ctrl.stop();
//     }
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final secs = _ctrl.isAnimating ? _oldSections : _newSections;
//     if (secs.isEmpty) return const SizedBox.shrink();

//     final total = secs.fold<double>(0, (s, e) => s + e.value.abs());
//     if (total == 0) return const SizedBox.shrink();

//     final palette = Colors.primaries;
//     final sections = <PieChartSectionData>[];
//     for (var i = 0; i < secs.length; i++) {
//       final s = secs[i];
//       final color = s.color ?? palette[i % palette.length];
//       sections.add(
//         PieChartSectionData(
//           value: s.value.abs(),
//           color: color,
//           radius: widget.radius,
//           showTitle: false,
//         ),
//       );
//     }

//     final legend = <Widget>[];
//     for (var i = 0; i < secs.length; i++) {
//       final s = secs[i];
//       final color = s.color ?? palette[i % palette.length];
//       final pct = (s.value.abs() / total * 100).toStringAsFixed(0) + '%';
//       legend.add(
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 10,
//               height: 10,
//               decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//             ),
//             const SizedBox(width: 4),
//             Flexible(
//               child: Text(
//                 '$pct ${s.title}',
//                 style: const TextStyle(fontSize: 12),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return RotationTransition(
//       turns: _rotationAnim,
//       child: Opacity(
//         opacity: _ctrl.value < 0.5 ? _fadeOutAnim.value : _fadeInAnim.value,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               width: widget.radius * 2,
//               height: widget.radius * 2,
//               child: PieChart(
//                 PieChartData(
//                   sections: sections,
//                   centerSpaceRadius: widget.radius - widget.strokeWidth,
//                   startDegreeOffset: -90,
//                   sectionsSpace: 0,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 50),
//             Wrap(
//               spacing: widget.legendGap,
//               runSpacing: widget.legendGap / 2,
//               alignment: WrapAlignment.center,
//               children: legend,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
