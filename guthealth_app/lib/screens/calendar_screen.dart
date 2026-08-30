import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:table_calendar/table_calendar.dart'; // for the actual calendar
import 'mood_log.dart';
import 'journal.dart';

//import 'package:flutter_dotenv/flutter_dotenv.dart';

class CalendarScreen extends StatefulWidget {
  final int customerId;
  final String journal;

  const CalendarScreen({
    super.key,
    required this.customerId,
    this.journal = '',
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}


class _CalendarScreenState extends State<CalendarScreen> {
  int _currentIndex = 1;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Emotion moodForDay(DateTime day) {
    final key = day.year * 10000 + day.month * 100 + day.day;
    return allEmotions[key % allEmotions.length];
  }

  void _handleProfile() {
    // Implement navigation to profile screen
  }


  void _handleHome() {
    Navigator.push(
      context,
        MaterialPageRoute<void>(builder: (context) => HomeScreen(customerId: widget.customerId),)
    );
  }

  void _handleBottomNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        _handleHome();
        break;
    }
  }

  void _handleNotifications() {
    // Implement navigation to notifications screen
  }


  void _handleJournal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JournalPage(
          journal: widget.journal,
        ),
      ),
    );
  }

    @override
    Widget build(BuildContext context) {
      //emotion show on page
      final mood = moodForDay(_selectedDay);
      return Scaffold(
        // top navigation bar
        appBar: AppBar(
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Calendar Widget
                Container(
                  decoration: BoxDecoration(
                   //color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    // month view
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                    },
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: const BoxDecoration(
                        color: Color(0xFF1B9FAE),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: const Color(0xFF1B9FAE).withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: const HeaderStyle( // header for month.
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                ),

                const SizedBox(height: 45), // Mood text box
                Center(
                  child: Text(
                    'Mood',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800, color:Colors.white )
                  )
                ),

                const SizedBox(height: 5), // Mood emoji box
                Center(
                  child: Text(
                    mood.emoji,
                    key: const Key('mood_emoji'), //add for test
                    style: const TextStyle(fontSize: 50),
                  ),
                ),

                const SizedBox(height: 5), // Buttons box

                //back to mood log
                SizedBox(
                  height: 53,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B9FAE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _handleJournal,
                    child: Text(
                      'View Journal',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith()

                  ),
                  ),
                ),
                const SizedBox(height: 12),

                //View symptom log
                SizedBox(
                  height: 53,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B9FAE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'View Symptom Log',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith()
                    ,
                    ),
                  ),
                ),
              ],

            ),
          ),
        ),
        // Bottom navigation bar
        bottomNavigationBar: Container(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _handleBottomNavigation,
            type: BottomNavigationBarType.fixed,
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
