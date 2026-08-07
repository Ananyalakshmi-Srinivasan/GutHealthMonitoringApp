import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MoodEntry {
  final DateTime date;
  final List<Emotion> emotions;
  final String journal;

  const MoodEntry({
    required this.date,
    required this.emotions,
    required this.journal,
  });
}

class Emotion {//define a class named emotion
  final String emoji;
  final String label;
  final String id;

  Emotion({required this.emoji, required this.label, required this.id});
}


List<Emotion> allEmotions = [
  Emotion(emoji: '😄', label: 'Happy' , id: '1'),
  Emotion(emoji: '😁', label: 'Excited', id: '2'),
  Emotion(emoji: '🤩', label: 'Energetic', id: '3'),
  Emotion(emoji: '😊', label: 'Content', id: '4'),
  Emotion(emoji: '😌', label: 'Relaxed', id: '5'),
  Emotion(emoji: '😐', label: 'Meh', id: '6'),
  Emotion(emoji: '😴', label: 'Tired', id: '7'),
  Emotion(emoji: '😢', label: 'Sad', id: '8'),
  Emotion(emoji: '😫', label: 'Stressed', id: '9'),
  Emotion(emoji: '😰', label: 'Anxious', id: '10'),
  Emotion(emoji: '😖', label: 'Discomfort', id: '11'),
  Emotion(emoji: '😠', label: 'Irritable', id: '12'),

];

class EmotionSearchPage extends StatefulWidget {//define a state page
  final int customerId;

  const EmotionSearchPage({super.key,required this.customerId,});

  @override
  State<EmotionSearchPage> createState() => _EmotionSearchPageState();
}

class _EmotionSearchPageState extends State<EmotionSearchPage> {
  int _currentIndex = 0;

  void _handleBottomNavigation(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen(customerId: widget.customerId)));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => CalendarScreen(customerId: widget.customerId)));
        break;
    }
  }

  //search bar controller
  //get textfield content，listen different enter，empty search bar
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _journalController = TextEditingController();

  List<Emotion> filteredEmotions = [];

  List<Emotion> selectedEmotions = [];


  Future<void> submitMood() async {
    if (selectedEmotions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one mood')),
      );
      return;
    }

    final url = Uri.parse('http://10.0.0.2:8080/api/mood/submit');

    final body = {
      "emotions": selectedEmotions.map((emotion) => emotion.id).toList(),
      "journal": _journalController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Saved successfully: ${response.body}");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mood saved successfully')),
        );
      } else {
        debugPrint("Saved successfully: ${response.body}");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Save failed, continue anyway')),
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CalendarScreen(
            customerId: widget.customerId,
            journal: _journalController.text.trim(),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No backend connection, continue anyway')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CalendarScreen(
            customerId: widget.customerId,
            journal: _journalController.text.trim(),
          ),
        ),
      );
    }
  }



  @override
  void initState() {//run once when create the page
    super.initState();
    filteredEmotions = allEmotions; // show all initially

    // listen search bar，every enter or delete will run _onSearchChanged
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _journalController.dispose();
    super.dispose();
  }

  // local search
  void _onSearchChanged() {
    //get enter content，turn into lower case，delete front and back space
    String query = _searchController.text.toLowerCase().trim();
    //if the state has been changed, then refresh
    setState(() {
      if (query.isEmpty) {
        filteredEmotions = allEmotions;
      } else {
        filteredEmotions = allEmotions.where((emotion) {
          // search in label，include key word will be fine
          return emotion.label.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Widget _buildJournalBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE0868D)),
      ),
      child: TextField(
        controller: _journalController,
        maxLines: 5,
        decoration: const InputDecoration(
          hintText: 'Write how you feel today...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(//avoid heading
          child: Column(
            children: [
              SizedBox(height: 16),
              // search bar
              _buildSearchBar(),

              // search result
              Expanded(
                child: ListView(
                  children: [
                    _buildEmojiSection('Selected Moods', selectedEmotions),
                    SizedBox(height: 16),

                    _buildEmotionGrid('All Moods', filteredEmotions),

                    SizedBox(height: 16),
                    _buildJournalBox(),
                  ],
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: submitMood,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFe0868d),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Continue',
                      style:  Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white,fontWeight:FontWeight.w600),
                    ),
                  ),

                ),
              ),
              SizedBox(height: 16)
            ],
          ),
        ),

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


  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Color(0xFFE0868D), width: 2),
      ),
      child: TextField(//fix enter controller
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '🔍   Search Moods',
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          // delete button
          suffixIcon: _searchController.text.isNotEmpty
          //press to delete all
              ? IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
            },
          )
              : null,
        ),
      ),
    );
  }

  //add a new list
  Widget _buildEmojiSection(
      String title,
      List<Emotion> emotions,
      ) {
    if (emotions.isEmpty) return SizedBox();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: emotions.length,
              separatorBuilder: (_, _) => SizedBox(width: 12),
              itemBuilder: (context, index) {
                final emotion = emotions[index];
                return _buildEmojiItem(emotion);
              },
            ),
          ),
        ],
      ),
    );
  }

  //individual emoji
  Widget _buildEmojiItem(Emotion emotion) {
    bool isSelected =
    selectedEmotions.any((e) => e.id == emotion.id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedEmotions.removeWhere((e) => e.id == emotion.id);
          } else {
            selectedEmotions.add(emotion);
          }
        });
      },
      child: Container(
        width: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Color(0xFFE8B4BC), width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            emotion.emoji,
            style: TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }


  Widget _buildEmotionGrid(String title, List<Emotion> emotions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!
            //TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: emotions.length,
            itemBuilder: (context, index) {
              return _buildEmotionCard(emotions[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionCard(Emotion emotion) {
    bool isSelected = selectedEmotions.any((e) => e.id == emotion.id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedEmotions.removeWhere((e) => e.id == emotion.id);
          } else {
            selectedEmotions.add(emotion);
          }
        });
      },
      // all moods emoji boards
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // colour when you select a mood.
          border: isSelected
              ? Border.all(color: Color(0xFFE8B4BC), width: 3)
              : null,
        ),
        padding: EdgeInsets.all(4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [ // selects each emoji and draws a box
              Text(emotion.emoji, style: TextStyle(fontSize: 32)),
              SizedBox(height: 4),

              // labels each emoji  on the page.
              Text(
                emotion.label,
                style:  Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

