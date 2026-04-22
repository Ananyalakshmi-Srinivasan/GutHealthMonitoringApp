import 'package:flutter/material.dart';
import 'package:guthealth_app/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'calendar_screen.dart';

class RecipesScreen extends StatefulWidget {
  final int customerId;
  const RecipesScreen({super.key,required this.customerId,});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {

  Future<void> _openPdf(String fileName) async {
    final Uri url = Uri.parse("http://ec2-51-21-76-143.eu-north-1.compute.amazonaws.com:8080/docs/$fileName");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open PDF');
    }
  }

  void _handleBottomNavigation(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(customerId: widget.customerId,)),
      );
    }
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CalendarScreen(customerId: widget.customerId,)),
      );
    }
  }

  void _handleProfile() {}

  void _handleNotifications() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF1B9FAE),

        leading: IconButton(
          icon: const Icon(Icons.person),
          color: Colors.white,
          onPressed: _handleProfile,
          iconSize: 30,
        ),

        title: Image.asset(
          'assets/pinklogo.png',
          height: 55,
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: _handleNotifications,
            iconSize: 30,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 35),

            const Text(
              "Recipes",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1B9FAE),
              ),
            ),

            const SizedBox(height: 35),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [

                  RecipeButton(
                    icon: Icons.breakfast_dining,
                    label: "Breakfast",
                    onTap: () => _openPdf("breakfasts.pdf"),
                  ),

                  const SizedBox(height: 15),

                  RecipeButton(
                    icon: Icons.lunch_dining,
                    label: "Lunch",
                    onTap: () => _openPdf("lunches.pdf"),
                  ),

                  const SizedBox(height: 15),

                  RecipeButton(
                    icon: Icons.dinner_dining,
                    label: "Dinner",
                    onTap: () => _openPdf("dinners.pdf"),
                  ),

                  const SizedBox(height: 15),

                  RecipeButton(
                    icon: Icons.soup_kitchen,
                    label: "Soups & Salads",
                    onTap: () => _openPdf("soups_salads.pdf"),
                  ),

                  const SizedBox(height: 15),

                  RecipeButton(
                    icon: Icons.local_drink,
                    label: "Smoothies",
                    onTap: () => _openPdf("smoothies.pdf"),
                  ),
                  const SizedBox(height: 15),

                ],
              ),
            )
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1B9FAE),
        ),
        child: BottomNavigationBar(
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


class RecipeButton extends StatelessWidget {

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const RecipeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF1B9FAE),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),

        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}