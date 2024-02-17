import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/otp_controller.dart';
import 'package:customer/model/user_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/ui/auth_screen/information_screen.dart';
import 'package:customer/ui/dashboard_screen.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OtpController>(
        init: OtpController(),
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image.asset("assets/images/login_image.png"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: Text(
                            "Verify Phone Number".tr,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "We just send a verification code to \n${controller.countryCode.value + controller.phoneNumber.value}"
                                .tr,
                            style: GoogleFonts.poppins(
                              color: AppColors.subTitleColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: PinCodeTextField(
                            textStyle: TextStyle(
                              color: Colors.black,
                            ),
                            length: 6,
                            appContext: context,
                            keyboardType: TextInputType.phone,
                            pinTheme: PinTheme(
                              fieldHeight: 50,
                              fieldWidth: 50,
                              activeColor: Colors.white,
                              selectedColor: Colors.white,
                              inactiveColor: Colors.green,
                              activeFillColor: Colors.green,
                              inactiveFillColor: Colors.white,
                              selectedFillColor: Colors.green,
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enableActiveFill: true,
                            cursorColor: AppColors.primary,
                            controller: controller.otpController.value,
                            onCompleted: (v) async {},
                            onChanged: (value) {},
                          ),
                        ),
                        const SizedBox(
                          height: 380,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: MediaQuery.of(context).size.height * .07,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                )),
                            child:InkWell(
                              onTap: () async {
                                if (controller
                                    .otpController.value.text.length ==
                                    6) {
                                  ShowToastDialog.showLoader(
                                      "Verify OTP".tr);

                                  PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: controller
                                          .verificationId.value,
                                      smsCode: controller
                                          .otpController.value.text);
                                  await FirebaseAuth.instance
                                      .signInWithCredential(credential)
                                      .then((value) async {
                                    if (value
                                        .additionalUserInfo!.isNewUser) {
                                      print("----->new user");
                                      UserModel userModel = UserModel();
                                      userModel.id = value.user!.uid;
                                      userModel.countryCode =
                                          controller.countryCode.value;
                                      userModel.phoneNumber =
                                          controller.phoneNumber.value;
                                      userModel.loginType =
                                          Constant.phoneLoginType;

                                      ShowToastDialog.closeLoader();
                                      Get.to(const InformationScreen(),
                                          arguments: {
                                            "userModel": userModel,
                                          });
                                    } else {
                                      print("----->old user");
                                      FireStoreUtils.userExitOrNot(
                                          value.user!.uid)
                                          .then((userExit) async {
                                        ShowToastDialog.closeLoader();
                                        if (userExit == true) {
                                          UserModel? userModel =
                                          await FireStoreUtils
                                              .getUserProfile(
                                              value.user!.uid);
                                          if (userModel != null) {
                                            if (userModel.isActive ==
                                                true) {
                                              Get.offAll(
                                                  const DashBoardScreen());
                                            } else {
                                              await FirebaseAuth.instance
                                                  .signOut();
                                              ShowToastDialog.showToast(
                                                  "This user is disable please contact administrator"
                                                      .tr);
                                            }
                                          }
                                        } else {
                                          UserModel userModel = UserModel();
                                          userModel.id = value.user!.uid;
                                          userModel.countryCode =
                                              controller.countryCode.value;
                                          userModel.phoneNumber =
                                              controller.phoneNumber.value;
                                          userModel.loginType =
                                              Constant.phoneLoginType;

                                          Get.to(const InformationScreen(),
                                              arguments: {
                                                "userModel": userModel,
                                              });
                                        }
                                      });
                                    }
                                  }).catchError((error) {
                                    ShowToastDialog.closeLoader();
                                    ShowToastDialog.showToast(
                                        "Code is Invalid".tr);
                                  });
                                } else {
                                  ShowToastDialog.showToast(
                                      "Please Enter Valid OTP".tr);
                                }

                                // print(controller.countryCode.value);
                                // print(controller.phoneNumberController.value.text);
                              },
                              child: Container(
                                height: 60,
                                width:
                                MediaQuery.of(context).size.width * .85,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Center(
                                  child: Text(
                                    "Verify".tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),

                        // ButtonThem.buildButton(
                        //   context,
                        //   title: "Verify".tr,
                        //   onPress: () async {
                        //     if (controller.otpController.value.text.length ==
                        //         6) {
                        //       ShowToastDialog.showLoader("Verify OTP".tr);
                        //
                        //       PhoneAuthCredential credential =
                        //           PhoneAuthProvider.credential(
                        //               verificationId:
                        //                   controller.verificationId.value,
                        //               smsCode:
                        //                   controller.otpController.value.text);
                        //       await FirebaseAuth.instance
                        //           .signInWithCredential(credential)
                        //           .then((value) async {
                        //         if (value.additionalUserInfo!.isNewUser) {
                        //           print("----->new user");
                        //           UserModel userModel = UserModel();
                        //           userModel.id = value.user!.uid;
                        //           userModel.countryCode =
                        //               controller.countryCode.value;
                        //           userModel.phoneNumber =
                        //               controller.phoneNumber.value;
                        //           userModel.loginType = Constant.phoneLoginType;
                        //
                        //           ShowToastDialog.closeLoader();
                        //           Get.to(const InformationScreen(), arguments: {
                        //             "userModel": userModel,
                        //           });
                        //         } else {
                        //           print("----->old user");
                        //           FireStoreUtils.userExitOrNot(value.user!.uid)
                        //               .then((userExit) async {
                        //             ShowToastDialog.closeLoader();
                        //             if (userExit == true) {
                        //               UserModel? userModel =
                        //                   await FireStoreUtils.getUserProfile(
                        //                       value.user!.uid);
                        //               if (userModel != null) {
                        //                 if (userModel.isActive == true) {
                        //                   Get.offAll(const DashBoardScreen());
                        //                 } else {
                        //                   await FirebaseAuth.instance.signOut();
                        //                   ShowToastDialog.showToast(
                        //                       "This user is disable please contact administrator"
                        //                           .tr);
                        //                 }
                        //               }
                        //             } else {
                        //               UserModel userModel = UserModel();
                        //               userModel.id = value.user!.uid;
                        //               userModel.countryCode =
                        //                   controller.countryCode.value;
                        //               userModel.phoneNumber =
                        //                   controller.phoneNumber.value;
                        //               userModel.loginType =
                        //                   Constant.phoneLoginType;
                        //
                        //               Get.to(const InformationScreen(),
                        //                   arguments: {
                        //                     "userModel": userModel,
                        //                   });
                        //             }
                        //           });
                        //         }
                        //       }).catchError((error) {
                        //         ShowToastDialog.closeLoader();
                        //         ShowToastDialog.showToast("Code is Invalid".tr);
                        //       });
                        //     } else {
                        //       ShowToastDialog.showToast(
                        //           "Please Enter Valid OTP".tr);
                        //     }
                        //
                        //     // print(controller.countryCode.value);
                        //     // print(controller.phoneNumberController.value.text);
                        //   },
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
