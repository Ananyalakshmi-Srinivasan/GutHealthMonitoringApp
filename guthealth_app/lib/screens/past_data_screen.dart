import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PastDataScreen extends StatefulWidget {
  static http.Client httpClient = http.Client();
  final int customerId;

  const PastDataScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<PastDataScreen> createState() => _PastDataScreenState();
}

class _PastDataScreenState extends State<PastDataScreen> {
  String selectedSymptom = 'loose_stool';
  List<FlSpot> chartData = [];
  List<String> xLabels = [];

  final String baseUrl = 'http://ec2-51-21-76-143.eu-north-1.compute.amazonaws.com:8080';

  final List<Map<String, String>> symptoms = const [
    {'label': 'Loose stool', 'name': 'loose_stool'},
    {'label': 'Constipation', 'name': 'constipation'},
    {'label': 'Bloating', 'name': 'bloating'},
    {'label': 'Abdominal pain', 'name': 'abdominal_pain'},
    {'label': 'Cramping', 'name': 'cramping'},
    {'label': 'Flatulence', 'name': 'flatulence'},
  ];

  @override
  void initState() {
    super.initState();
    loadChartData();
  }

  Future<void> loadChartData() async {
    final url = Uri.parse(
      '$baseUrl/api/response/graph/${widget.customerId}/$selectedSymptom',
    );

    try {
      final response = await PastDataScreen.httpClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          xLabels = data.map((item) => item['date'].toString()).toList();

          chartData = data.asMap().entries.map((entry) {
            final item = entry.value;
            return FlSpot(
              entry.key.toDouble(),
              (item['severityScore'] as num).toDouble(),
            );
          }).toList();
        });
      } else {
        setState(() {
          chartData = [];
          xLabels = [];
        });
        debugPrint('Failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      setState(() {
        chartData = [];
        xLabels = [];
      });
      debugPrint('Error loading chart data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Past Data',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1B9FAE),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
              MaterialPageRoute<void>(builder: (context) => HomeScreen(customerId: widget.customerId),)
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            Container(
              height: 1,
              width: double.infinity,
              color: Color(0xFF1B9FAE),
            ),
            const SizedBox(height: 15),
            // Title
            const Text(
              'Symptom history:',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Container(
              height: 1,
              width: double.infinity,
              color: Color(0xFF1B9FAE),
            ),
            const SizedBox(height: 15),
            // Symptom dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedSymptom,
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: symptoms.map((symptom) {
                  return DropdownMenuItem<String>(
                    value: symptom['name'],
                    child: Text(
                      symptom['label']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedSymptom = newValue;
                    });
                    loadChartData();
                  }
                },
              ),
            ),
            SizedBox(
              height: 350,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 16),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 2,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= xLabels.length) {
                              return const SizedBox();
                            }

                            return Transform.rotate(
                              angle: -0.5,
                              child: Text(
                                xLabels[index],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black87,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: Colors.grey.shade400),
                        bottom: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    minY: 0,
                    maxY: 10,
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartData,
                        isCurved: false,
                        color: Colors.black87,
                        barWidth: 2,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.black87,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
