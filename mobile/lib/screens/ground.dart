import 'package:aqua_control/screens/temp.dart';
import 'package:aqua_control/widgets/commun_widgets/palettes.dart';
import 'package:aqua_control/widgets/commun_widgets/real_time_widget.dart';
import 'package:aqua_control/widgets/commun_widgets/screen_size_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class Ground extends StatefulWidget {
  const Ground({super.key});

  @override
  State<Ground> createState() => _Ground();
}

class _Ground extends State<Ground> {
  final databaseReference = FirebaseDatabase.instance.ref('ground_humidity');
  String fechaGrafica = '';
  Map<String, dynamic>? _firebaseData;
  int currentDay = 10; 
  List<BarChartGroupData> _bars = [];
  final Map<double, String> _dayTimeMap = {};

  @override
  void initState() {
    super.initState();
    _fetchDataForCurrentDay();
  }

 void _fetchDataForCurrentDay() {
  databaseReference.onValue.listen((event) {
    final snapshot = event.snapshot;
    if (snapshot.value != null && snapshot.value is Map) {
      Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      List<BarChartGroupData> bars = [];
      _dayTimeMap.clear();

      String currentDayFormatted = currentDay.toString().padLeft(2, '0');

      if (data.containsKey(currentDayFormatted)) {
        Map<String, dynamic> times = Map<String, dynamic>.from(data[currentDayFormatted]);

        times.forEach((time, valueMap) {
          if (valueMap is Map && valueMap['value'] != null) {
            double normalizeHumidity(double rawValue) {
              return 100 - (rawValue / 4095) * 100;
            }

            double humidity = normalizeHumidity((valueMap['value'] as num).toDouble());

            print('Hora: $time, Humedad cruda: ${valueMap['value']}, Humedad normalizada: $humidity');

            List<String> timeParts = time.split(':');
            double hour = double.parse(timeParts[0]);
            double minute = double.parse(timeParts[1]) / 60.0;
            double x = hour + minute;

            _dayTimeMap[x] = time;  

            bars.add(
              BarChartGroupData(
                x: hour.toInt(),
                barRods: [
                  BarChartRodData(
                    toY: humidity.clamp(0, 100), 
                    color: AppColors.mutedAquaGreen,
                    width: 25,
                    borderRadius: BorderRadius.zero
                  ),
                ],
              ),
            );
          }
        });

        bars.sort((a, b) => a.x.compareTo(b.x));
      }

      setState(() {
        _bars = bars;
        fechaGrafica = '$currentDay/10/2024'; 
      });
    }
  });
}


  void _incrementDay() {
    if (currentDay < 31) {
      setState(() {
        currentDay++;
        _fetchDataForCurrentDay();
      });
    }
  }

  void _decrementDay() {
    if (currentDay > 1) {
      setState(() {
        currentDay--;
        _fetchDataForCurrentDay();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      final size = MediaQuery.of(context).size;
      screenWidth = size.width;
      screenHeight = size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Card(
              elevation: 4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: _bars.isNotEmpty
                          ? BarChart(
                              BarChartData(
                                maxY: 100, 
                                minY: 0,   
                                barGroups: _bars,
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        if (value % 10 == 0) {
                                          return Text('${value.toInt()}%');
                                        }
                                        return Container();
                                      },
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  bottomTitles: const AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                color: AppColors.mutedAquaGreen,
                              ),
                              const SizedBox(width: 8),
                              const Text('Humedad en %'),
                            ],
                          ),
                          Text(fechaGrafica),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [  
                    Container(
                      height: screenHeight * 0.05,
                      width: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        color: AppColors.mutedAquaGreen, 
                        borderRadius: BorderRadius.circular(12), 
                      ),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 15), 
                          onPressed: _decrementDay,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), 
                    Container(
                      height: screenHeight * 0.05,
                      width: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        color: AppColors.mutedAquaGreen, 
                        borderRadius: BorderRadius.circular(12), 
                      ),
                      child: Center( 
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 15), 
                          onPressed: _incrementDay,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const RealTimeWidget(),
          ],
        ),
      ),
        bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.mutedAquaGreen,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Iconify(Mdi.sun_thermometer, color: Colors.white,),
            label: 'Grafico',
          ),
          BottomNavigationBarItem(
            icon: Iconify(Mdi.plant, color: Colors.white,),
            label: 'Lista',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false, 
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Temp()), 
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Ground()), 
            );
          }
        }
        )
    );
  }
}
