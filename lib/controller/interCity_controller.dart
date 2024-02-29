import 'dart:convert';
import 'package:location/location.dart' as loct;
import 'package:customer/constant/constant.dart';
import 'package:customer/controller/dash_board_controller.dart';
import 'package:customer/model/contact_model.dart';
import 'package:customer/model/freight_vehicle.dart';
import 'package:customer/model/intercity_service_model.dart';
import 'package:customer/model/order/location_lat_lng.dart';
import 'package:customer/model/payment_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/utils/Preferences.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
class InterCityController extends GetxController {
  DashBoardController dashboardController = Get.put(DashBoardController());

  Rx<TextEditingController> sourceCityController = TextEditingController().obs;
  Rx<TextEditingController> sourceLocationController = TextEditingController().obs;
  Rx<LocationLatLng> sourceLocationLAtLng = LocationLatLng().obs;

  Rx<TextEditingController> destinationCityController = TextEditingController().obs;
  Rx<TextEditingController> destinationLocationController = TextEditingController().obs;
  Rx<LocationLatLng> destinationLocationLAtLng = LocationLatLng().obs;

  Rx<TextEditingController> parcelWeight = TextEditingController().obs;
  Rx<TextEditingController> parcelDimension = TextEditingController().obs;

  Rx<TextEditingController> noOfPassengers = TextEditingController().obs;
  Rx<TextEditingController> offerYourRateController = TextEditingController().obs;
  Rx<TextEditingController> whenController = TextEditingController().obs;
  Rx<TextEditingController> commentsController = TextEditingController().obs;

  RxList<IntercityServiceModel> intercityService = <IntercityServiceModel>[].obs;
  RxList<FreightVehicle> frightVehicleList = <FreightVehicle>[].obs;
  Rx<IntercityServiceModel> selectedInterCityType = IntercityServiceModel().obs;
  Rx<FreightVehicle> selectedFreightVehicle = FreightVehicle().obs;

  Rx<bool> loaderNeeded = false.obs;

  DateTime? dateAndTime;

  RxList<XFile> images = <XFile>[].obs;

  late GoogleMapController mapController;
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

  var colors = [
    AppColors.serviceColor1,
    AppColors.serviceColor2,
    AppColors.serviceColor3,
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    getPaymentData();
    getIntercityService();
    _getCurrentLocation();


    super.onInit();
  }

  RxBool isLoading = true.obs;

  getIntercityService() async {
    await FireStoreUtils.getIntercityService().then((value) {
      intercityService.value = value;
      if (intercityService.isNotEmpty) {
        selectedInterCityType.value = intercityService.first;
      }
    });
    await FireStoreUtils.getFreightVehicle().then((value) {
      frightVehicleList.value = value;
      // if (frightVehicleList.isNotEmpty) {
      //   selectedFreightVehicle.value = frightVehicleList.first;
      // }
    });
    isLoading.value = false;
  }

  Rx<PaymentModel> paymentModel = PaymentModel().obs;

  RxString selectedPaymentMethod = "".obs;

  getPaymentData() async {
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;
      }
    });
  }

  RxString duration = "".obs;
  RxString distance = "".obs;
  RxString amount = "".obs;

  calculateAmount() async {
    if(selectedInterCityType.value.id == "Kn2VEnPI3ikF58uK8YqY"){
      if(selectedFreightVehicle.value.id == null){
        amount.value = "0.0";
        offerYourRateController.value.text = "0.0";
      }else{
        if (sourceLocationLAtLng.value.latitude != null && destinationLocationLAtLng.value.latitude != null) {
          await Constant.getDurationDistance(
              LatLng(sourceLocationLAtLng.value.latitude!, sourceLocationLAtLng.value.longitude!), LatLng(destinationLocationLAtLng.value.latitude!, destinationLocationLAtLng.value.longitude!))
              .then((value) {
            if (value != null) {
              duration.value = value.rows!.first.elements!.first.duration!.text.toString();
              if (Constant.distanceType == "Km") {
                distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1000).toString();
                amount.value = Constant.amountCalculate(selectedFreightVehicle.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
                offerYourRateController.value.text = Constant.amountCalculate(selectedFreightVehicle.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
              } else {
                distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1609.34).toString();
                amount.value = Constant.amountCalculate(selectedFreightVehicle.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
                offerYourRateController.value.text = Constant.amountCalculate(selectedFreightVehicle.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
              }
            }
          });
        }
      }
    }else{
      amount.value = "0.0";
      offerYourRateController.value.text = "0.0";
      if (sourceLocationLAtLng.value.latitude != null && destinationLocationLAtLng.value.latitude != null) {
        await Constant.getDurationDistance(
            LatLng(sourceLocationLAtLng.value.latitude!, sourceLocationLAtLng.value.longitude!), LatLng(destinationLocationLAtLng.value.latitude!, destinationLocationLAtLng.value.longitude!))
            .then((value) {
          if (value != null) {
            duration.value = value.rows!.first.elements!.first.duration!.text.toString();
            if (Constant.distanceType == "Km") {
              distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1000).toString();
              amount.value = Constant.amountCalculate(selectedInterCityType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
              offerYourRateController.value.text = Constant.amountCalculate(selectedInterCityType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
            } else {
              distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1609.34).toString();
              amount.value = Constant.amountCalculate(selectedInterCityType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
              offerYourRateController.value.text = Constant.amountCalculate(selectedInterCityType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
            }
          }
        });
      }
    }

  }


  RxList<ContactModel> contactList = <ContactModel>[].obs;
  Rx<ContactModel> selectedTakingRide = ContactModel(fullName: "Myself", contactNumber: "").obs;

  setContact() {
    print(jsonEncode(contactList));
    Preferences.setString(Preferences.contactList, json.encode(contactList.map<Map<String, dynamic>>((music) => music.toJson()).toList()));
    getContact();
  }

  getContact() {
    String contactListJson = Preferences.getString(Preferences.contactList);

    if(contactListJson.isNotEmpty){
      print("---->");
      contactList.clear();
      contactList.value = (json.decode(contactListJson) as List<dynamic>).map<ContactModel>((item) => ContactModel.fromJson(item)).toList();
    }
  }




  //Bottom Sheeet Variables


  dynamic uuid ;
  dynamic sessionToken;
  RxList placeList = [].obs;
  RxInt results = 0.obs;
  RxString selectedPlace = 'Tap to Search'.obs;
  TextEditingController locationSearchController = TextEditingController();

  void getSuggestions(
      String input, dynamic sessionToken, InterCityController cont) async {
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String kPLACES_API_KEY = ''
        'AIzaSyCdnrssnmZUvPplGu-jBMIzsj09CUh_6rQ';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$sessionToken';

print("insdie parwpier");
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
        print(jsonDecode(response.body));
        print(response.statusCode);

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
