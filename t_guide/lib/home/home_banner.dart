import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
class HomeFirst extends StatelessWidget {
Widget build(BuildContext context) {
   

    return GestureDetector(
    
      child: Scaffold(
       
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(0, 1),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.403,
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, -1.77),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwzfHx0cmF2ZWx8ZW58MHx8fHwxNzA1ODE1NTU4fDA&ixlib=rb-4.0.3&q=80&w=1080',
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.322,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.1, 0.99),
                      child: Container(
                        width: 281,
                        height: 173,
                        decoration: BoxDecoration(
                          color:Color.fromARGB(255, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color.fromARGB(255, 40, 40, 40),
                              offset: Offset(0, 2),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-0.53, -0.75),
                              child: Icon(
                                Icons.car_rental,
                                color:
                                    Color.fromARGB(255, 0, 0, 0),
                                size: 60,
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.59, -0.73),
                              child: Icon(
                                Icons.hotel,
                                color:
                                    Color.fromARGB(255, 0, 0, 0),
                                size: 60,
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-0.49, 0.63),
                              child: Icon(
                                Icons.food_bank,
                                color:
                                   Color.fromARGB(255, 0, 0, 0),
                                size: 60,
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.54, 0.79),
                              child: Icon(
                                Icons.event,
                                color:
                                    Color.fromARGB(255, 0, 0, 0),
                                size: 60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}