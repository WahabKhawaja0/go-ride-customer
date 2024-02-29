import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:customer/constant/constant.dart';
import 'package:customer/controller/dash_board_controller.dart';
import 'package:customer/model/airport_model.dart';
import 'package:customer/model/banner_model.dart';
import 'package:customer/model/contact_model.dart';
import 'package:customer/model/order/location_lat_lng.dart';
import 'package:customer/model/payment_model.dart';
import 'package:customer/model/service_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/utils/Preferences.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loct;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {



 dynamic uuid = "";
 dynamic sessionToken;
 TextEditingController locationSearchController = TextEditingController();



  DashBoardController dashboardController = Get.put(DashBoardController());

  Rx<TextEditingController> sourceLocationController = TextEditingController().obs;
  Rx<TextEditingController> destinationLocationController = TextEditingController().obs;
  Rx<TextEditingController> offerYourRateController = TextEditingController().obs;
  Rx<ServiceModel> selectedType = ServiceModel().obs;

  Rx<LocationLatLng> sourceLocationLAtLng = LocationLatLng().obs;
  Rx<LocationLatLng> destinationLocationLAtLng = LocationLatLng().obs;

  RxString currentLocation = "".obs;
  RxBool isLoading = true.obs;
  RxList serviceList = <ServiceModel>[].obs;
  RxList bannerList = <BannerModel>[].obs;
  final PageController pageController = PageController(viewportFraction: 0.96, keepPage: true);

  var colors = [
    AppColors.serviceColor1,
    AppColors.serviceColor2,
    AppColors.serviceColor3,
  ];
  late  GoogleMapController mapController ;
 // late GoogleMapController mapController;


  @override
  void onInit() {
    // TODO: implement onInit
    // mapController;
    getServiceType();
    getPaymentData();
    getContact();
    _getCurrentLocation();
    super.onInit();
  }

 Rx<LatLng> currentPosition = Rx<LatLng>(LatLng(0.0, 0.0));



 Future<void> _getCurrentLocation() async {
   // loc.Location location = loc.Location();
   loct.Location location = loct.Location();
   loct.LocationData locationData = await location.getLocation();
   currentPosition.value = LatLng(locationData.latitude!, locationData.longitude!);
 }

 void animateToCurrentLocation() {
   mapController.animateCamera(
     CameraUpdate.newLatLngZoom(currentPosition.value, 14),
   );
 }

  getServiceType() async {
    await FireStoreUtils.getService().then((value) {
      serviceList.value = value;
      if (serviceList.isNotEmpty) {
        selectedType.value = serviceList.first;
      }
    });

    await FireStoreUtils.getBanner().then((value) {
      bannerList.value = value;
    });

    isLoading.value = false;

    await Utils.getCurrentLocation().then((value) {
      Constant.currentLocation = value;
    });
    await placemarkFromCoordinates(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude).then((value) {
      Placemark placeMark = value[0];

      currentLocation.value = "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
    }).catchError((error) {
      debugPrint("------>${error.toString()}");
    });
  }

  RxString duration = "".obs;
  RxString distance = "".obs;
  RxString amount = "".obs;

  calculateAmount() async {
    if (sourceLocationLAtLng.value.latitude != null && destinationLocationLAtLng.value.latitude != null) {
      await Constant.getDurationDistance(
              LatLng(sourceLocationLAtLng.value.latitude!, sourceLocationLAtLng.value.longitude!), LatLng(destinationLocationLAtLng.value.latitude!, destinationLocationLAtLng.value.longitude!))
          .then((value) {
        if (value != null) {
          duration.value = value.rows!.first.elements!.first.duration!.text.toString();
          if (Constant.distanceType == "Km") {
            distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1000).toString();
            amount.value = Constant.amountCalculate(selectedType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
          } else {
            distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1609.34).toString();
            amount.value = Constant.amountCalculate(selectedType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
          }
        }
      });
    }
  }

  Rx<PaymentModel> paymentModel = PaymentModel().obs;

  RxString selectedPaymentMethod = "".obs;

  RxList airPortList = <AriPortModel>[].obs;

  getPaymentData() async {
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;
      }
    });
  }

  RxList<ContactModel> contactList = <ContactModel>[].obs;
  Rx<ContactModel> selectedTakingRide = ContactModel(fullName: "Myself", contactNumber: "").obs;
  Rx<AriPortModel> selectedAirPort = AriPortModel().obs;

  setContact() {
    print(jsonEncode(contactList));
    Preferences.setString(Preferences.contactList, json.encode(contactList.map<Map<String, dynamic>>((music) => music.toJson()).toList()));
    getContact();
  }

  getContact() {
    String contactListJson = Preferences.getString(Preferences.contactList);

    if (contactListJson.isNotEmpty) {
      print("---->");
      contactList.clear();
      contactList.value = (json.decode(contactListJson) as List<dynamic>).map<ContactModel>((item) => ContactModel.fromJson(item)).toList();
    }
  }


 RxList placeList = [].obs;
 RxInt results = 0.obs;
 RxString selectedPlace = 'Tap to Search'.obs;

 void getSuggestions(
     String input, dynamic sessionToken, HomeController cont) async {
   String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
   String kPLACES_API_KEY = ''
       'AIzaSyCdnrssnmZUvPplGu-jBMIzsj09CUh_6rQ';
   String request =
       '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$sessionToken';


   var response = await http.get(Uri.parse(request)).then((response) {
     if (response.statusCode == 200) {
       List predictions = jsonDecode(response.body.toString())['predictions'];
       List bostonPredictions = predictions.toList();
       print("++++++++++++++++++++++++++++++++++++++++++");
       print(predictions);
       print(bostonPredictions);
       // List bostonPredictions = predictions.where((prediction) {
       //   return prediction['description'].toLowerCase().contains('boston');
       // }).toList();

       results.value = bostonPredictions.length;
       // cont.state.placeList.value =
       cont.placeList.value = bostonPredictions;

     } else {

     }
   }).onError((error, stackTrace) {

   });
 }


final loc = LatLng(0,0).obs;
 Future<void> GetCoordinates(BuildContext context) async {

   List<Location> coordinates =
   await locationFromAddress(selectedPlace.toString());
   if (coordinates.isNotEmpty) {
     final lat = coordinates.first;
     loc.value = LatLng(lat.latitude, lat.longitude);
   }
   print(loc.value.latitude);
   print(loc.value.longitude);
 }
}
