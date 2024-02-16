import 'dart:developer';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/login_controller.dart';
import 'package:customer/model/user_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/ui/auth_screen/information_screen.dart';
import 'package:customer/ui/dashboard_screen.dart';
import 'package:customer/ui/terms_and_condition/terms_and_condition_screen.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image.asset("assets/images/login_image.png",
                  //     width: Responsive.width(100, context)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: Text(
                            "Enter Your Phone Number".tr,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "Enter your phone number, to create an account or log in".tr,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            validator: (value) =>
                                value != null && value.isNotEmpty
                                    ? null
                                    : 'Required',
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.sentences,
                            controller: controller.phoneNumberController.value,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                                color: themeChange.getThem()
                                    ? Colors.white
                                    : Colors.black),
                            decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: themeChange.getThem()
                                    ? AppColors.darkTextField
                                    : AppColors.textField,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                prefixIcon: CountryCodePicker(

                                  onChanged: (value) {
                                    controller.countryCode.value = value.dialCode.toString();
                                  },
                                  searchStyle: TextStyle(
                                      color: Colors.black
                                  ),


                                  searchDecoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search , color: Colors.green),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(color: Colors.green, width: 1),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                                        borderSide: BorderSide()
                                    ),
                                    border: UnderlineInputBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(),
                                    ),
                                  ),

                                  dialogBackgroundColor: Colors.white,
                                  dialogTextStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  initialSelection: controller.countryCode.value,
                                  comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                                  flagDecoration:  BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(Radius.circular(2)),

                                  ),
                                  textStyle: TextStyle(
                                    color:  Colors.black,
                                  ),
                                  // barrierColor: Colors.red,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear,color:Colors.black54),
                                  onPressed: () {
                                    controller.phoneNumberController.value.clear();
                                  },
                                ),


                                disabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide: BorderSide(
                                      color: themeChange.getThem()
                                          ? AppColors.darkTextFieldBorder
                                          : AppColors.textFieldBorder,
                                      width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide: BorderSide(
                                      color: themeChange.getThem()
                                          ? AppColors.darkTextFieldBorder
                                          : AppColors.textFieldBorder,
                                      width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide: BorderSide(
                                      color: themeChange.getThem()
                                          ? AppColors.darkTextFieldBorder
                                          : AppColors.textFieldBorder,
                                      width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide: BorderSide(
                                      color: themeChange.getThem()
                                          ? AppColors.darkTextFieldBorder
                                          : AppColors.textFieldBorder,
                                      width: 1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide: BorderSide(
                                      color: themeChange.getThem()
                                          ? AppColors.darkTextFieldBorder
                                          : AppColors.textFieldBorder,
                                      width: 1),
                                ),
                                hintText: "Phone number".tr)),
                        const SizedBox(
                          height: 380,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: MediaQuery.of(context).size.height * .18,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                )

                            ),
                            child: Column(
                              children: [
                                Spacer(),
                                InkWell(
                                  onTap: (){
                                    controller.sendCode();
                                  },
                                  child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width * .85,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: Center(
                                      child: Text("Next".tr, style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),),
                                    ),
                                  ),
                                ),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),

                        // ButtonThem.buildButton(
                        //   context,
                        //   title: "Next".tr,
                        //   onPress: () {
                        //     controller.sendCode();
                        //   },
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 10, vertical: 40),
                        //   child: Row(
                        //     children: [
                        //       const Expanded(
                        //           child: Divider(
                        //         height: 1,
                        //       )),
                        //       Padding(
                        //         padding:
                        //             const EdgeInsets.symmetric(horizontal: 20),
                        //         child: Text(
                        //           "OR".tr,
                        //           style: GoogleFonts.poppins(
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.w600),
                        //         ),
                        //       ),
                        //       const Expanded(
                        //           child: Divider(
                        //         height: 1,
                        //       )),
                        //     ],
                        //   ),
                        // ),
                        // ButtonThem.buildBorderButton(
                        //   context,
                        //   title: "Login with google".tr,
                        //   iconVisibility: true,
                        //   iconAssetImage: 'assets/icons/ic_google.png',
                        //   onPress: () async {
                        //     ShowToastDialog.showLoader("Please wait".tr);
                        //     await controller.signInWithGoogle().then((value) {
                        //       ShowToastDialog.closeLoader();
                        //       if (value != null) {
                        //         if (value.additionalUserInfo!.isNewUser) {
                        //           print("----->new user");
                        //           UserModel userModel = UserModel();
                        //           userModel.id = value.user!.uid;
                        //           userModel.email = value.user!.email;
                        //           userModel.fullName = value.user!.displayName;
                        //           userModel.profilePic = value.user!.photoURL;
                        //           userModel.loginType = Constant.googleLoginType;

                        //           ShowToastDialog.closeLoader();
                        //           Get.to(const InformationScreen(), arguments: {
                        //             "userModel": userModel,
                        //           });
                        //         } else {
                        //           print("----->old user");
                        //           FireStoreUtils.userExitOrNot(value.user!.uid).then((userExit) async {
                        //             ShowToastDialog.closeLoader();
                        //             if (userExit == true) {
                        //               UserModel? userModel = await FireStoreUtils.getUserProfile(value.user!.uid);
                        //               if (userModel != null) {
                        //                 if (userModel.isActive == true) {
                        //                   Get.offAll(const DashBoardScreen());
                        //                 } else {
                        //                   await FirebaseAuth.instance.signOut();
                        //                   ShowToastDialog.showToast("This user is disable please contact administrator".tr);
                        //                 }
                        //               }
                        //             } else {
                        //               UserModel userModel = UserModel();
                        //               userModel.id = value.user!.uid;
                        //               userModel.email = value.user!.email;
                        //               userModel.fullName = value.user!.displayName;
                        //               userModel.profilePic = value.user!.photoURL;
                        //               userModel.loginType = Constant.googleLoginType;

                        //               Get.to(const InformationScreen(), arguments: {
                        //                 "userModel": userModel,
                        //               });
                        //             }
                        //           });
                        //         }
                        //       }
                        //     });
                        //   },
                        // ),
                        // const SizedBox(
                        //   height: 16,
                        // ),
                        // Visibility(
                        //     visible: Platform.isIOS,
                        //     child: ButtonThem.buildBorderButton(
                        //       context,
                        //       title: "Login with apple".tr,
                        //       iconVisibility: true,
                        //       iconAssetImage: 'assets/icons/ic_apple.png',
                        //       onPress: () async {
                        //         ShowToastDialog.showLoader("Please wait".tr);
                        //         await controller.signInWithApple().then((value) {
                        //           ShowToastDialog.closeLoader();
                        //           if (value != null) {
                        //             if (value.additionalUserInfo!.isNewUser) {
                        //               log("----->new user");
                        //               UserModel userModel = UserModel();
                        //               userModel.id = value.user!.uid;
                        //               userModel.email = value.user!.email;
                        //               userModel.profilePic = value.user!.photoURL;
                        //               userModel.loginType = Constant.appleLoginType;

                        //               ShowToastDialog.closeLoader();
                        //               Get.to(const InformationScreen(), arguments: {
                        //                 "userModel": userModel,
                        //               });
                        //             } else {
                        //               print("----->old user");
                        //               FireStoreUtils.userExitOrNot(value.user!.uid).then((userExit) async {
                        //                 ShowToastDialog.closeLoader();

                        //                 if (userExit == true) {
                        //                   UserModel? userModel = await FireStoreUtils.getUserProfile(value.user!.uid);
                        //                   if (userModel != null) {
                        //                     if (userModel.isActive == true) {
                        //                       Get.offAll(const DashBoardScreen());
                        //                     } else {
                        //                       await FirebaseAuth.instance.signOut();
                        //                       ShowToastDialog.showToast("This user is disable please contact administrator".tr);
                        //                     }
                        //                   }
                        //                 } else {
                        //                   UserModel userModel = UserModel();
                        //                   userModel.id = value.user!.uid;
                        //                   userModel.email = value.user!.email;
                        //                   userModel.profilePic = value.user!.photoURL;
                        //                   userModel.loginType = Constant.googleLoginType;

                        //                   Get.to(const InformationScreen(), arguments: {
                        //                     "userModel": userModel,
                        //                   });
                        //                 }
                        //               });
                        //             }
                        //           }
                        //         });
                        //       },
                        //     )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'By tapping "Next" you agree to '.tr,
                    style: GoogleFonts.poppins(),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const TermsAndConditionScreen(
                                type: "terms",
                              ));
                            },
                          text: 'Terms and conditions'.tr,
                          style: GoogleFonts.poppins(
                              decoration: TextDecoration.underline)),
                      TextSpan(text: ' and ', style: GoogleFonts.poppins()),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const TermsAndConditionScreen(
                                type: "privacy",
                              ));
                            },
                          text: 'privacy policy'.tr,
                          style: GoogleFonts.poppins(
                              decoration: TextDecoration.underline)),
                      // can add more TextSpans here...
                    ],
                  ),
                )),
          );
        });
  }
}
