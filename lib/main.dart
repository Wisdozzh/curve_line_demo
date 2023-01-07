
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/slide_selector.dart';
import 'components/week_summary.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
  ));
  runApp(const LOLTrackerApp());
}

class LOLTrackerApp extends StatelessWidget {
   const LOLTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'LOLTracker',
        debugShowCheckedModeBanner: false,
        home:Scaffold(
          extendBodyBehindAppBar: true,
          body: Dashboard(),
        ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin{
  int activeWeek = 3;
  PageController summaryController = PageController(
    viewportFraction: 1,
    initialPage: 3
  );
  double chartHeight = 240;

  @override
  void initState() {
    super.initState();
  }

  void changeWeek(int week) {
    setState(() {
      activeWeek = week;
      summaryController.animateToPage(week, duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DashboardBackground(),
        ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 60,
              margin: const EdgeInsets.only(top: 60),
              alignment: Alignment.center,
              child: const Text(
                'LOL 😆 Tracker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SlideSelector(
                defaultSelectedIndex: activeWeek - 1,
                items: <SlideSelectorItem>[
                  SlideSelectorItem(
                      text: 'Week 1',
                      onTap: () {
                        changeWeek(1);
                      },
                  ),
                  SlideSelectorItem(
                      text: 'Week 2',
                      onTap: () {
                        changeWeek(2);
                      },
                  ),
                  SlideSelectorItem(
                      text: 'Week 3',
                      onTap: () {
                        changeWeek(3);
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              height: chartHeight,
              color: const Color(0XFF158443),
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, chartHeight),
                    painter: PathPainter(
                      path: drawPath(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: 400,
              child: PageView.builder(
                clipBehavior: Clip.none,
                  physics: const NeverScrollableScrollPhysics(),
                  controller: summaryController,
                  itemCount: 4,
                  itemBuilder: (_, i) {
                    return WeekSummary(week: i);
                  }),
            )
          ],
        ),
      ],
    );
  }

  Path drawPath() {
    final width = MediaQuery.of(context).size.width;
    final height = chartHeight;
    final path = Path();
    path.moveTo(0, height);
    path.lineTo(width / 2, height * 0.5);
    path.lineTo(width, height * 0.75);
    return path;
  }
}

class DashboardBackground extends StatelessWidget {
   const DashboardBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: const Color(0xFF158443),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class PathPainter extends CustomPainter {
  Path path;
  PathPainter({required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    // paint the line
    final paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}