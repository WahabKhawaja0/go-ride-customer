import 'dart:convert';

import 'package:customer/controller/home_controller.dart';
import 'package:customer/model/order/location_lat_lng.dart';
import 'package:customer/ui/serachTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import 'package:http/http.dart' as http;

import '../../../../main.dart';

Future destinationBottomSheet(BuildContext context,HomeController cont) {
  cont.uuid = Uuid();
  cont.locationSearchController.addListener(() {
    if (cont.sessionToken == null) {
      cont.sessionToken = cont.uuid!.v4();
    }
    cont.getSuggestions(
        cont.locationSearchController.text.trim().toString(),
        cont.sessionToken,
        cont);
  });

  return showModalBottomSheet(
    context: context,
    // backgroundColor:Colors.white,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0,
                  -3), // Offset in the negative y-axis to create a top shadow
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.horizontal_rule,
                  size: 40,
                  color: Colors.black,
                ),
              ],
            ),
            Container(
              // height: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            // width: mq.width * 0.2,
                            child: Icon(Icons.cancel_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 15,),
                  Text('Enter your Location',style: TextStyle(color: Colors.black),),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Divider(),
            ),
            SearchTextField(context, cont),
            Obx(() {
              return cont.placeList.length == 0
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text("No Result Found Yet",style: TextStyle(color: Colors.black),),
                    Text("Try to adding more details, like 123 Main Street Black Bay Boston",style: TextStyle(color: Colors.black),),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Divider(),
                    ),
                    Text('Add a city for better results',style: TextStyle(color: Colors.black),),
                  ],
                ),
              )
                  : Expanded(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: cont.placeList.length,
                    itemBuilder: (context, index) {
                      return cont.placeList.length == 0
                          ? Container()
                          : ListTile(
                        title: Text(cont
                            .placeList[index]['description']
                            .toString(),style: TextStyle(color: Colors.black),),
                        subtitle: Text(cont
                            .placeList[index]
                        ['structured_formatting']
                        ['secondary_text']
                            .toString(),style: TextStyle(color: Colors.black),),
                        onTap: ()  async{

                          cont.selectedPlace.value = cont
                              .placeList[index]['description']
                              .toString();
                          print("++++xxxxxxxxxxxxxx+++++++");
                          print(cont.selectedPlace.value);
                          await cont.GetCoordinates(context);
                          cont.locationSearchController
                              .clear();
                          cont.placeList.value=[];

                          if (true) {
                            cont
                                .destinationLocationController
                                .value
                                .text =
                                cont.selectedPlace.value
                                    .toString();
                           cont.destinationLocationLAtLng
                                .value =
                                LocationLatLng(
                                    latitude: cont.loc.value.latitude,
                                    longitude: cont.loc.value.longitude);
                            cont
                                .calculateAmount();
                          }




                          Navigator.pop(context);
                        },
                      );
                    }),
              );
            }),
          ],
        ),
      );
    },
  );
}
