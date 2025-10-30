import 'package:flutter/material.dart';
import 'package:school_test/screens/add_school_screen.dart';
import 'package:school_test/screens/screening_sccreen_angnwadi.dart';
import 'package:school_test/screens/screening_screen_school.dart';
import 'package:school_test/screens/add_angan_wadi_screen.dart';

class HomeScreen extends StatefulWidget {
  final int? doctorId;
  final String doctorName;

  const HomeScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /* 
  for later cause in_ap_update is not working as we want it to be working 
 */
  //  final _updateChecker = InappUpdate();

  // initState() async {
  //   super.initState();
  //   // You can add any initialization code here if needed
  //   /// checking if  updates ar avialable
  //   // await _updateChecker.checkForAppUpdate();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Responsive sizing
    final isSmallScreen = width < 360;
    final isMediumScreen = width >= 360 && width < 600;
    final isLargeScreen = width >= 600;

    // Dynamic padding
    final horizontalPadding = width * 0.05;
    final verticalPadding = height * 0.02;

    // Dynamic font sizes
    final titleFontSize = isSmallScreen
        ? 18.0
        : isMediumScreen
        ? 20.0
        : 24.0;
    final subtitleFontSize = isSmallScreen
        ? 10.0
        : isMediumScreen
        ? 12.0
        : 14.0;
    final sectionFontSize = isSmallScreen ? 16.0 : 18.0;
    final cardTitleFontSize = isSmallScreen ? 14.0 : 16.0;
    final cardSubtitleFontSize = isSmallScreen ? 10.0 : 12.0;

    // Dynamic icon sizes
    final headerIconSize = isSmallScreen
        ? 32.0
        : isMediumScreen
        ? 36.0
        : 40.0;
    final cardIconSize = isSmallScreen
        ? 28.0
        : isMediumScreen
        ? 32.0
        : 36.0;

    // Dynamic card height
    final cardHeight = isSmallScreen
        ? 140.0
        : isMediumScreen
        ? 160.0
        : 180.0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Screening App',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              widget.doctorName,
              style: TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w400,
                color: Colors.white.withAlpha(200),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        toolbarHeight: isSmallScreen ? 60 : 70,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800), // Max width for tablets
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[700]!, Colors.blue[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: isSmallScreen
                                  ? 18
                                  : isMediumScreen
                                  ? 22
                                  : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Start your screening activities',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.health_and_safety,
                        size: headerIconSize,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isSmallScreen ? 24 : 32),

              // School Section
              Text(
                'School Activities',
                style: TextStyle(
                  fontSize: sectionFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildModernCard(
                      icon: Icons.assignment_outlined,
                      title: 'Start\nScreening',
                      subtitle: 'For School',
                      color: Colors.blue,
                      height: cardHeight,
                      iconSize: cardIconSize,
                      titleFontSize: cardTitleFontSize,
                      subtitleFontSize: cardSubtitleFontSize,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScreenningSchoolScreen(
                              doctorName: widget.doctorName,
                              doctorId: widget.doctorId,
                              // schoolName: widget.S,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildModernCard(
                      icon: Icons.add_business_outlined,
                      title: 'Add\nSchool',
                      subtitle: 'Register New',
                      color: Colors.green,
                      height: cardHeight,
                      iconSize: cardIconSize,
                      titleFontSize: cardTitleFontSize,
                      subtitleFontSize: cardSubtitleFontSize,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddSchoolScreen(
                              DoctorId: widget.doctorId,
                              doctorName: widget.doctorName,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: isSmallScreen ? 24 : 32),

              // Anganwadi Section
              Text(
                'Anganwadi Activities',
                style: TextStyle(
                  fontSize: sectionFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildModernCard(
                      icon: Icons.assignment_outlined,
                      title: 'Start\nScreening',
                      subtitle: 'For Anganwadi',
                      color: Colors.orange,
                      height: cardHeight,
                      iconSize: cardIconSize,
                      titleFontSize: cardTitleFontSize,
                      subtitleFontSize: cardSubtitleFontSize,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScreenningAngnwadiScreen(
                              doctorName: widget.doctorName,
                              doctorId: widget.doctorId,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildModernCard(
                      icon: Icons.add_home_outlined,
                      title: 'Add\nAnganwadi',
                      subtitle: 'Register New',
                      color: Colors.purple,
                      height: cardHeight,
                      iconSize: cardIconSize,
                      titleFontSize: cardTitleFontSize,
                      subtitleFontSize: cardSubtitleFontSize,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddAnganWadiScreen(
                              doctorName: widget.doctorName,
                              DoctorId: widget.doctorId,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required double height,
    required double iconSize,
    required double titleFontSize,
    required double subtitleFontSize,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(iconSize * 0.4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: iconSize, color: color),
            ),
            SizedBox(height: height * 0.075),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: subtitleFontSize,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
