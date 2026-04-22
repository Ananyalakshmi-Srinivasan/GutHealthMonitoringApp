import 'package:flutter/material.dart';
import 'recipe_screen.dart';
import 'past_data_screen.dart';
import 'survey_screen.dart';
import 'mood_log.dart';
import 'calendar_screen.dart';
import 'notification_screen.dart';


class HomeScreen extends StatefulWidget {
  final int customerId;

  const HomeScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _handleProfile() {
    // Implement navigation to profile screen
  }

  void _handleLogSymptoms() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => SurveyScreen(customerId: widget.customerId)),
    );
  }


  void _handleViewPreviousData() {
    // Implement navigation to previous data screen
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => PastDataScreen(customerId: widget.customerId),
      ),
    );
  }

  void _handleMoodLog() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => EmotionSearchPage(customerId: widget.customerId,)),
    );
  }

  void _handleRecipes() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => RecipesScreen(customerId: widget.customerId)),
    );
  }

  void _handleCalendar() {
    // Implement navigation to calendar screen
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (_) => CalendarScreen(customerId: widget.customerId)), );
  }

  void _handleBottomNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 1:
        _handleCalendar();
        break;
    }
  }

  void _handleNotifications() {
    // Implement navigation to notifications screen
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const NotificationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // top navigation bar
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF1B9FAE),
        // profile button
        leading: IconButton(
          icon: const Icon(Icons.person),
          color: Colors.white,
          onPressed: _handleProfile,
          iconSize: 30,
        ),
        // logo
        title: Image.asset(
          'assets/pinklogo.png',
          height: 55,
        ),
        // notifications button
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: _handleNotifications,
            iconSize: 30,
          ),
        ]

      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 35),

            // Welcome text
            const Text(
              "Welcome user",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1B9FAE),
              ),
            ),

            const SizedBox(height: 50),

            // Log mood
            GestureDetector(
              onTap: _handleLogSymptoms,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                  ),
                  Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE0868D),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Log Symptoms",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 50),

            // Buttons for other pages
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _handleMoodLog,
                    child: HomeButtons(
                      icon: Icons.mood,
                      label: "Mood Log",
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleRecipes,
                    child: HomeButtons(
                      icon: Icons.restaurant,
                      label: "Recipes",
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleViewPreviousData,
                    child: HomeButtons(
                        icon: Icons.auto_graph,
                        label: "Past data"
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom navigation bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1B9FAE),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _handleBottomNavigation,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1B9FAE),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withValues(alpha: 0.7),

          selectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
          ],
        ),
      ),
    );
  }
}
// class to standardise the buttons
class HomeButtons extends StatelessWidget {
  final IconData icon;
  final String label;

  const HomeButtons({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF1B9FAE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
