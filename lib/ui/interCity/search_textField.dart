import 'package:customer/controller/home_controller.dart';
import 'package:customer/controller/interCity_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



Widget SearchTextField(BuildContext context , InterCityController cont){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: TextFormField(
      style: TextStyle(
        color: Colors.black
      ),
      controller: cont.locationSearchController,
      readOnly: false,
      textInputAction: TextInputAction.search,
      obscureText: false,
      keyboardType: TextInputType.streetAddress,
      onChanged: (value) {},
      onTapOutside: (value){
        FocusScope.of(context).unfocus();

      },

      // focusNode: focNode,
      decoration: InputDecoration(
        labelText: 'Type an address and city',
        labelStyle: TextStyle(color: Colors.black),
        floatingLabelAlignment: FloatingLabelAlignment.start,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(),
        ),
        prefixIcon: Icon(
          CupertinoIcons.search,
          size: 26,
          color: Colors.green,
        ),
        enabled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          BorderSide(color: Colors.green),
        ),

      ),
    ),
  );
}
