import 'dart:convert'; // for converting into json type to send to backend
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart'; // to make the survey
import 'package:http/http.dart' as http; // for sending to the backend

import 'home_screen.dart';

class SurveyScreen extends StatefulWidget {
  final int customerId;
  const SurveyScreen({super.key,required this.customerId,});

  @override
  State<SurveyScreen> createState() => SurveyScreenState();
}

class SurveyScreenState extends State<SurveyScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  int currentStep = 1;
  int currentQuestionIndex = 0;
  final List<Map<String, String>> symptoms = const [
    {'label': 'Loose stool', 'name': 'loose_stool',
      'description': 'Loose or watery bowel movements that occur more frequently than normal.'},
    {'label': 'Constipation', 'name': 'constipation',
      'description': 'Difficulty passing stools or infrequent bowel movements (fewer than 3 times per week).'},
    {'label': 'Bloating', 'name': 'bloating',
      'description': 'A feeling of fullness or tightness in the abdomen.'},
    {'label': 'Abdominal pain', 'name': 'abdominal_pain',
      'description': 'Discomfort or pain anywhere in the belly area.'},
    {'label': 'Cramping', 'name': 'cramping',
      'description': 'Sudden, involuntary muscle contractions in the abdomen that cause pain. Often comes and goes in waves.'},
    {'label': 'Flatulence', 'name': 'flatulence',
      'description': 'Excessive gas in the digestive system, leading to passing gas or a feeling of gassiness and discomfort.'},
  ];

  int get totalSteps => symptoms.length;

  Future<void> submitSurvey(Map<String, dynamic> formData) async {
    final url = Uri.parse("http://ec2-51-21-76-143.eu-north-1.compute.amazonaws.com:8080/api/response/submit");
      //submit used here because that's the url the springboot end is expecting the post request on!!
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(formData),
    );

    if (response.statusCode == 200) {
      debugPrint("Saved successfully: ${response.body}");
    } else {
      debugPrint("Failed: ${response.statusCode} -> ${response.body}");
    }
  }
  void _showSymptomDescription(String symptomLabel, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            symptomLabel,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B9FAE),
            ),
          ),
          content: Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Got it',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0868D),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSymptom = symptoms[currentQuestionIndex];
    final currentName = currentSymptom['name']!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Ferrocalm Survey',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFFFFF),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1B9FAE),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ), //white left arrow
              onPressed: () async {
                final didPop = await Navigator.maybePop(context);

                if (!context.mounted) return;

                if (!didPop) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomeScreen(customerId: widget.customerId,)),
                    (route) => false,
                  );
                }
              },
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: currentStep / totalSteps,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xFF1B9FAE),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),

          //content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 35),
                    // question description
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14.0),
                      margin: const EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF1B9FAE,
                        ).withValues(alpha: 0.12), // box background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          Text(
                            'On a scale of 0 to 10, how would you rate the following symptoms over the last week?',
                            style: TextStyle(
                              fontSize: 15.7,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    Text(
                      currentSymptom['label'] ?? '',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FormBuilderSlider(
                            name: currentName,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            initialValue: 5,
                            activeColor: Color(0xFFE0868D),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            valueWidget: (value) => Text(
                              value,
                              style: const TextStyle(
                                color: Color(0xFFE0868D),
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                _showSymptomDescription(
                                  currentSymptom['label']!,
                                  currentSymptom['description']!,
                                );
                              },
                              icon: const Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Color(0xFF1B9FAE),
                              ),
                              label: const Text(
                                'Symptom Description',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1B9FAE),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //Next question button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 43.0,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0868D), // pink
                ),

                // after click
                onPressed: () async {
                  _formKey.currentState?.save(); // collect value
                  final map = _formKey.currentState?.value ?? {};
                  debugPrint('All answers (JSON): ${jsonEncode(map)}');

                  if (currentQuestionIndex < symptoms.length - 1) {
                    // move to next question
                    setState(() {
                      currentQuestionIndex++;
                      currentStep =
                          (currentQuestionIndex + 1).clamp(1, totalSteps);
                    });
                  } else {
                    // last question: go home
                    final last = {
                      'attributes': map
                    };
                    submitSurvey(last);

                    if (!context.mounted) return;

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => HomeScreen(customerId: widget.customerId,)),
                      (route) => false,
                    );
                  }
                },
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
