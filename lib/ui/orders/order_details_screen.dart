import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constant/collection_name.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/send_notification.dart';
import 'package:customer/controller/order_details_controller.dart';
import 'package:customer/model/driver_rules_model.dart';
import 'package:customer/model/driver_user_model.dart';
import 'package:customer/model/order/driverId_accept_reject.dart';
import 'package:customer/model/order_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/widget/location_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../widget/driver_view.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetBuilder<OrderDetailsController>(
        init: OrderDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.green,
              title:  Text("Ride Details".tr),
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: Responsive.width(6, context),
                  width: Responsive.width(100, context),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                        color: themeChange.getThem() ? Colors.white : Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection(CollectionName.orders).doc(controller.orderModel.value.id).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return  Center(child: Text('Something went wrong'.tr));
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Constant.loader();
                          }

                          OrderModel orderModel = OrderModel.fromJson(snapshot.data!.data()!);
                          return SingleChildScrollView(
                            child: Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.black54),
                              //   borderRadius: BorderRadius.circular(20),
                              // ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                orderModel.status.toString(),
                                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.black),
                                              ),
                                            ),
                                            Text(
                                              orderModel.status == Constant.ridePlaced
                                                  ? Constant.amountShow(amount: orderModel.offerRate.toString())
                                                  : Constant.amountShow(amount: orderModel.finalRate == null?"0.0":orderModel.finalRate.toString()),
                                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: Colors.green,fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        LocationView(
                                          sourceLocation: orderModel.sourceLocationName.toString(),
                                          destinationLocation: orderModel.destinationLocationName.toString(),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration:
                                          BoxDecoration(color: themeChange.getThem() ? AppColors.darkContainerBorder : AppColors.darkContainerBorder, borderRadius: const BorderRadius.all(Radius.circular(10))),
                                          child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text("OTP".tr, style: GoogleFonts.poppins()),
                                                        Text(" : ${orderModel.otp}", style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.white)),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(Constant().formatTimestamp(orderModel.createdDate), style: GoogleFonts.poppins(color: Colors.white)),
                                                ],
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ButtonThem.buildButton(
                                          context,
                                          title: "Cancel".tr,
                                          btnHeight: 44,

                                          onPress: () async {
                                            List<dynamic> acceptDriverId = [];

                                            orderModel.status = Constant.rideCanceled;
                                            orderModel.acceptedDriverId = acceptDriverId;
                                            await FireStoreUtils.setOrder(orderModel).then((value) {
                                              Get.back();
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  orderModel.acceptedDriverId == null || orderModel.acceptedDriverId!.isEmpty
                                      ?  Center(
                                    child: Text("No driver Found".tr,style: TextStyle(color: Colors.black),),
                                  )
                                      : Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: orderModel.acceptedDriverId!.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return FutureBuilder<DriverUserModel?>(
                                            future: FireStoreUtils.getDriver(orderModel.acceptedDriverId![index]),
                                            builder: (context, snapshot) {
                                              switch (snapshot.connectionState) {
                                                case ConnectionState.waiting:
                                                  return Constant.loader();
                                                case ConnectionState.done:
                                                  if (snapshot.hasError) {
                                                    return Text(snapshot.error.toString());
                                                  } else {
                                                    DriverUserModel driverModel = snapshot.data!;
                                                    return FutureBuilder<DriverIdAcceptReject?>(
                                                        future: FireStoreUtils.getAcceptedOrders(orderModel.id.toString(), driverModel.id.toString()),
                                                        builder: (context, snapshot) {
                                                          switch (snapshot.connectionState) {
                                                            case ConnectionState.waiting:
                                                              return Constant.loader();
                                                            case ConnectionState.done:
                                                              if (snapshot.hasError) {
                                                                return Text(snapshot.error.toString());
                                                              } else {
                                                                DriverIdAcceptReject driverIdAcceptReject = snapshot.data!;
                                                                return Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 10),
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: themeChange.getThem() ? AppColors.containerBackground : AppColors.containerBackground,
                                                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                                      border: Border.all(color: themeChange.getThem() ? AppColors.darkContainerBorder : AppColors.darkContainerBorder, width: 0.5),
                                                                      boxShadow: themeChange.getThem()
                                                                          ? null
                                                                          : null,
                                                                    ),
                                                                    child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: DriverView(driverId: driverModel.id.toString(), amount: driverIdAcceptReject.offerAmount.toString()),
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        const Divider(color: Colors.black,),
                                                                        Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Container(
                                                                           decoration : BoxDecoration(
                                                                             color: themeChange.getThem() ? AppColors.darkContainerBorder : AppColors.darkContainerBorder,
                                                                             borderRadius: BorderRadius.circular(10),

                                                                           ),
                                                                            child: Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        SvgPicture.asset(
                                                                                          'assets/icons/ic_car.svg',
                                                                                          width: 18,
                                                                                          color: themeChange.getThem() ? Colors.white : Colors.white,
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        Text(
                                                                                          driverModel.vehicleInformation!.vehicleType.toString(),
                                                                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.white),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        SvgPicture.asset(
                                                                                          'assets/icons/ic_color.svg',
                                                                                          width: 18,
                                                                                          color: themeChange.getThem() ? Colors.white : Colors.white,
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        Text(
                                                                                          driverModel.vehicleInformation!.vehicleColor.toString(),
                                                                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.white),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Image.asset(
                                                                                          'assets/icons/ic_number.png',
                                                                                          width: 18,
                                                                                          color: themeChange.getThem() ? Colors.white : Colors.white,
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        Text(
                                                                                          driverModel.vehicleInformation!.vehicleNumber.toString(),
                                                                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.white),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                          ),
                                                                        ),
                                                                        const Divider(color: Colors.black,),
                                                                        const SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        driverModel.vehicleInformation!.driverRules == null
                                                                            ? const SizedBox()
                                                                            : ListView.builder(
                                                                          shrinkWrap: true,
                                                                          itemCount: driverModel.vehicleInformation!.driverRules!.length,
                                                                          itemBuilder: (context, index) {
                                                                            DriverRulesModel driverRules = driverModel.vehicleInformation!.driverRules![index];
                                                                            return Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                              child: Row(
                                                                                children: [
                                                                                  CachedNetworkImage(
                                                                                    imageUrl: driverRules.image.toString(),
                                                                                    fit: BoxFit.fill,
                                                                                    color: themeChange.getThem() ? Colors.green : Colors.green,
                                                                                    height: Responsive.width(4, context),
                                                                                    width: Responsive.width(4, context),
                                                                                    placeholder: (context, url) => Constant.loader(),
                                                                                    errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Text(driverRules.name.toString(),style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                        const SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: ButtonThem.buildBorderButton(
                                                                                  context,
                                                                                  title: "Reject".tr,
                                                                                  btnHeight: 45,
                                                                                  iconVisibility: false,
                                                                                  onPress: () async {
                                                                                    List<dynamic> rejectDriverId = [];
                                                                                    if (controller.orderModel.value.rejectedDriverId != null) {
                                                                                      rejectDriverId = controller.orderModel.value.rejectedDriverId!;
                                                                                    } else {
                                                                                      rejectDriverId = [];
                                                                                    }
                                                                                    rejectDriverId.add(driverModel.id);

                                                                                    List<dynamic> acceptDriverId = [];
                                                                                    if (controller.orderModel.value.acceptedDriverId != null) {
                                                                                      acceptDriverId = controller.orderModel.value.acceptedDriverId!;
                                                                                    } else {
                                                                                      acceptDriverId = [];
                                                                                    }

                                                                                    print("===>");
                                                                                    print(acceptDriverId);
                                                                                    acceptDriverId.remove(driverModel.id);

                                                                                    controller.orderModel.value.rejectedDriverId = rejectDriverId;
                                                                                    controller.orderModel.value.acceptedDriverId = acceptDriverId;

                                                                                    await SendNotification.sendOneNotification(
                                                                                        token: driverModel.fcmToken.toString(),
                                                                                        title: 'Ride Canceled'.tr,
                                                                                        body: 'The passenger has canceled the ride. No action is required from your end.'.tr,
                                                                                        payload: {});
                                                                                    await FireStoreUtils.setOrder(controller.orderModel.value);
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Expanded(
                                                                                child: ButtonThem.buildButton(
                                                                                  context,
                                                                                  title: "Accept".tr,
                                                                                  btnHeight: 45,
                                                                                  onPress: () async {
                                                                                    orderModel.acceptedDriverId = [];
                                                                                    orderModel.driverId = driverIdAcceptReject.driverId.toString();
                                                                                    orderModel.status = Constant.rideActive;
                                                                                    orderModel.finalRate = driverIdAcceptReject.offerAmount;
                                                                                    FireStoreUtils.setOrder(orderModel);

                                                                                    await SendNotification.sendOneNotification(
                                                                                        token: driverModel.fcmToken.toString(),
                                                                                        title: 'Ride Confirmed'.tr,
                                                                                        body: 'Your ride request has been accepted by the passenger. Please proceed to the pickup location.'.tr,
                                                                                        payload: {});
                                                                                    Get.back();
                                                                                  },
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            default:
                                                              return  Text('Error'.tr);
                                                          }
                                                        });
                                                  }
                                                default:
                                                  return  Text('Error'.tr);
                                              }
                                            });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}