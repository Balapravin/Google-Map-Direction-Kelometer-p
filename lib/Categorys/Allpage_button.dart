import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:location/location.dart';
import 'package:maptrack/Categorys/Main_Module.dart';
import 'package:maptrack/Categorys/Fixed_location_picker.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:maptrack/Categorys/Main_Module_2.dart';
import 'package:maptrack/config.dart';

class CommonButton extends StatefulWidget {
  const CommonButton({super.key});

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
 
  PickResult? fromAddress;
  PickResult? toAddress;

  TextEditingController sourceAddress = TextEditingController();
  TextEditingController destinationAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Map',
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                Container(
                    height: 40,
                    decoration: BoxDecoration(border: Border.all(width: 2,color: Colors.black38),
                    borderRadius: BorderRadius.circular(8)),
                    child: Center(child:TextButton(child: Text('Location Picker',style: TextStyle(color: Colors.black, fontSize: 12),),onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationPicker()));
                    },) ),      
                   ),     
                   SizedBox(height: 30),   
             Container(
                    height: 40,
                    decoration: BoxDecoration(border: Border.all(width: 2,color: Colors.black38),
                    borderRadius: BorderRadius.circular(8)),
                    child: Center(child:TextButton(child: Text('Main Module 1',style: TextStyle(color: Colors.black, fontSize: 12),),onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MainModule()));
                    },) ),      
                   ),     
                   SizedBox(height: 30),                   
                    Container(
                    height: 40,
                    decoration: BoxDecoration(border: Border.all(width: 2,color: Colors.black38),
                    borderRadius: BorderRadius.circular(8)),
                    child: Center(child:TextButton(child: Text('Main Module 2',style: TextStyle(color: Colors.black, fontSize: 12),),onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DefaultApp()));
                    },) ),),   
           
          ],
        ),
      ),
      // ),
    );
  }
}

