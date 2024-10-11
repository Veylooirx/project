import 'package:aqua_control/screens/temp_humidity.dart';
import 'package:aqua_control/widgets/commun_widgets/palettes.dart';
import 'package:aqua_control/widgets/commun_widgets/screen_size_widget.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);

    return Scaffold(
      body: Stack(
        children: [
            Image.asset(
            'assets/tractor.jpg', 
            width: screenWidth,
            height: screenHeight * 0.4,
            fit: BoxFit.cover, 
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.7,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(36.0), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), 
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5), 
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 25.0),
                  Container(
                    padding: const EdgeInsets.all(0),
                    height: screenHeight * 0.12,
                    width: screenHeight * 0.12,
                    child: Image.asset(
                      'assets/logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "AgroTecNM",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: AppColors.mutedAquaGreen,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4), 
                          offset: const Offset(1.0, 1.0), 
                          blurRadius: 3.0, 
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Text(
                    "¡Bienvenido a AgroTecNM!", 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24, 
                      color: AppColors.mutedAquaGreen,
                      fontWeight: FontWeight.w800, 
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    width: screenWidth,
                    child: const Text(
                      "Estamos aquí para ayudarte a optimizar tus cultivos y mejorar tu productividad agrícola. Podrás monitorear tus tierras.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16, 
                        color: Colors.black
                      ),
                    ),
                  ),
                  const Text(
                    "Juntos cultivamos un futuro más sostenible", 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.black
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Text(
                    "¡Empecemos a cosechar exitos!", 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.black,
                      fontWeight: FontWeight.w600, 
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  SizedBox(
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.9,
                    child: TextButton(
                      onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TempHumidity()),
                            );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.mutedAquaGreen, 
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      ),
                      child: const Text(
                        "Iniciar",
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 18, 
                        ),
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
        ]),
      );
  }
}
