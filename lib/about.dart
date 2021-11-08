import 'package:flutter/material.dart';
import 'package:mobile_final_project/page/mainscreen.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_left_outlined,
            size: 30.0,
          ),
          onPressed: () {
            
          },
        ),
        title: const Text("About"),
      ),

      body: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'About Page',
                  style: TextStyle(
                    fontSize: 40, fontWeight: FontWeight.bold
                  ),
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
