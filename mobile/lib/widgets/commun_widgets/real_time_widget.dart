import 'package:aqua_control/widgets/commun_widgets/palettes.dart';
import 'package:aqua_control/widgets/commun_widgets/screen_size_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RealTimeWidget extends StatefulWidget {
  const RealTimeWidget({super.key});

  @override
  _RealTimeWidgetState createState() => _RealTimeWidgetState();
}

class _RealTimeWidgetState extends State<RealTimeWidget> {
  final databaseReference = FirebaseDatabase.instance.ref('realtime_ground_humidity');
  final databaseReference2 = FirebaseDatabase.instance.ref('realtime_temperature-humidity');

  String soilHumidity = '0%';
  String temperature = '-';
  String humidity = '-';

  @override
  void initState() {
    super.initState();

databaseReference.onValue.listen((event) {
  final snapshot = event.snapshot;
  if (snapshot.value != null && snapshot.value is Map) {
    int sensorValue = (snapshot.value as Map)['value'] ?? 0; 
    double humidityPercentage = (1 - (sensorValue / 4095)) * 100; 

    setState(() {
      soilHumidity = '${humidityPercentage.toStringAsFixed(1)}%';
    });
  }
});

    databaseReference2.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);

        setState(() {
          temperature = data['temperature']['value']?.toString() ?? '-';
          humidity = data['humidity']['value']?.toString() ?? '-';
        });
      }
    });
  }

@override
Widget build(BuildContext context) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Datos Ambientales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Monitoreo en tiempo real',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Temperatura',
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Colors.black, 
                ),
              ),
              SizedBox(width: 20),
              Text(
                'Humedad',
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Colors.black,
                ),
              ),
              Text(
                'Humedad del suelo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: screenHeight * 0.05,
                width: screenWidth * 0.25,
                decoration: BoxDecoration(
                  color: AppColors.mutedAquaGreen,
                  borderRadius: BorderRadius.circular(10.0), 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$temperature°C',
                      style: const TextStyle(color: Colors.white), 
                    ),
                    const SizedBox(width: 10.0,),
                    const Icon(
                      CupertinoIcons.cloud,
                      color: Colors.white, 
                    ),
                  ],
                ),
              ),
              Container(
                height: screenHeight * 0.05,
                width: screenWidth * 0.25,
                decoration: BoxDecoration(
                  color: AppColors.mutedAquaGreen,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$humidity%',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      CupertinoIcons.drop,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Container(
                height: screenHeight * 0.05,
                width: screenWidth * 0.25,
                decoration: BoxDecoration(
                  color: AppColors.mutedAquaGreen,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      soilHumidity,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                      const Icon(
                      CupertinoIcons.leaf_arrow_circlepath,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Día: 27/10/2024'),
            ],
          ),
        ],
      ),
    ),
  );
}
}