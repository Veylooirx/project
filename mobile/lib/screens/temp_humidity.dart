import 'package:aqua_control/screens/ground.dart';
import 'package:aqua_control/widgets/commun_widgets/palettes.dart';
import 'package:aqua_control/widgets/commun_widgets/real_time_widget.dart';
import 'package:aqua_control/widgets/commun_widgets/screen_size_widget.dart';
import 'package:aqua_control/screens/temp.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';


class TempHumidity extends StatefulWidget {
  const TempHumidity({super.key});

  @override
  State<TempHumidity> createState() => _TempHumidity();
}

class _TempHumidity extends State<TempHumidity> {
  final databaseReference = FirebaseDatabase.instance.ref('temperature-humidity');
  String fechaGrafica = '';
  Map<String, dynamic>? _firebaseData;
  int currentDay = 10; 
  List<FlSpot> _spots = [];
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
        List<FlSpot> spots = [];
        _dayTimeMap.clear();

        String currentDayFormatted = currentDay.toString().padLeft(2, '0');

        if (data.containsKey(currentDayFormatted)) {
          Map<String, dynamic> times = Map<String, dynamic>.from(data[currentDayFormatted]);

          times.forEach((time, valueMap) {
            if (valueMap is Map && valueMap['humidity'] != null) {
              double humidity = (valueMap['humidity']['value'] as num).toDouble();

              List<String> timeParts = time.split(':');
              double hour = double.parse(timeParts[0]);
              double minute = double.parse(timeParts[1]) / 60.0;
              double x = hour + minute;

              spots.add(FlSpot(x, humidity));
              _dayTimeMap[x] = time;
            }
          });

          spots.sort((a, b) => a.x.compareTo(b.x));
        }

        setState(() {
          _spots = spots;
          fechaGrafica = '$currentDay/10/2024'; 
        });
      }
    });
  }
void _incrementDay() {
    if (currentDay < 31) {
      setState(() {
        currentDay++;
        print(currentDay);
        _fetchDataForCurrentDay();
      });
    }
  }

  void _decrementDay() {
    if (currentDay > 1) {
      setState(() {
        currentDay--;
        print(currentDay);
        _fetchDataForCurrentDay();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox( height: 20.0),
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
                      child: _spots.isNotEmpty
                          ? LineChart(
                              LineChartData(
                                minY: 0,
                                maxY: 80,
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        if (value % 5 == 0) {
                                          return Text('${value.toInt()}%');
                                        }
                                        return Container();
                                      },
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _spots,
                                    isCurved: false,
                                    color: Colors.blue,
                                    belowBarData: BarAreaData(show: false),
                                  ),
                                ],
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipItems: (touchedSpots) {
                                      return touchedSpots.map((spot) {
                                        String time = _dayTimeMap[spot.x] ?? 'Desconocido';
                                        double humidity = spot.y;
                                        return LineTooltipItem(
                                          'Hora: $time\nHumedad: ${humidity.toStringAsFixed(1)}%',
                                          const TextStyle(color: Colors.white),
                                        );
                                      }).toList();
                                    },
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
                                width: screenWidth * 0.1,
                                height: screenWidth * 0.01,
                                color: Colors.blue,
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
                Container(
                  height: screenHeight * 0.05,
        
                  decoration: BoxDecoration(
                    color: AppColors.mutedAquaGreen, 
                    borderRadius: BorderRadius.circular(12), 
                  ),
                  child: Row(
                    children: 
                    [ 
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye, color: Colors.white, size: 20), 
                        onPressed: () {  
                          Navigator.push(
                            context,MaterialPageRoute(builder: (context) => const Temp()));   
                        },
                      ),
                      const Text("Temperatura")
                    ]
                  ),
                ),
                const SizedBox(width: 16), 
                Row(
                  children: [  
                    Container(
                      height: screenHeight * 0.05,
                      width: screenWidth * 0.20,
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
                      width: screenWidth * 0.20,
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
            const RealTimeWidget()
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