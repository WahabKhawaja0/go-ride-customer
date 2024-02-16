import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/information_controller.dart';
import 'package:customer/model/referral_model.dart';
import 'package:customer/model/user_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/themes/text_field_them.dart';
import 'package:customer/ui/dashboard_screen.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<InformationController>(
        init: InformationController(),
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image.asset("assets/images/login_image.png",
                  //     width: Responsive.width(100, context)),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Text(
                            "Sign up".tr,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Create your account to start using Go-Ride".tr,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              color: AppColors.subTitleColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        TextFieldThem.buildTextFiled(
                          context,
                          hintText: 'Full name'.tr,
                          controller: controller.fullNameController.value,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) =>
                              value != null && value.isNotEmpty
                                  ? null
                                  : 'Required',
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                          controller: controller.phoneNumberController.value,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.start,
                          enabled: controller.loginType.value ==
                                  Constant.phoneLoginType
                              ? false
                              : true,
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    color: themeChange.getThem()
                                        ? AppColors.darkTextFieldBorder
                                        : AppColors.textFieldBorder,
                                    width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    color: themeChange.getThem()
                                        ? AppColors.darkTextFieldBorder
                                        : AppColors.textFieldBorder,
                                    width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    color: themeChange.getThem()
                                        ? AppColors.darkTextFieldBorder
                                        : AppColors.textFieldBorder,
                                    width: 1),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    color: themeChange.getThem()
                                        ? AppColors.darkTextFieldBorder
                                        : AppColors.textFieldBorder,
                                    width: 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    color: themeChange.getThem()
                                        ? AppColors.darkTextFieldBorder
                                        : AppColors.textFieldBorder,
                                    width: 1),
                              ),
                              hintText: "Phone number".tr),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldThem.buildTextFiled(context,
                            hintText: 'Email'.tr,
                            controller: controller.emailController.value,
                            enable: controller.loginType.value ==
                                    Constant.googleLoginType
                                ? false
                                : true),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldThem.buildTextFiled(context,
                            hintText: 'Coupon Code (Optional)'.tr,
                            controller: controller.referralCodeController.value,
                            enable: controller.loginType.value ==
                                    Constant.googleLoginType
                                ? false
                                : true),

                        const SizedBox(
                          height: 200,
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
                                  onTap: () async {
                                    if (controller
                                        .fullNameController.value.text.isEmpty) {
                                      ShowToastDialog.showToast(
                                          "Please enter full name".tr);
                                    } else if (controller
                                        .emailController.value.text.isEmpty) {
                                      ShowToastDialog.showToast(
                                          "Please enter email".tr);
                                    } else if (controller
                                        .phoneNumberController.value.text.isEmpty) {
                                      ShowToastDialog.showToast(
                                          "Please enter phone".tr);
                                    } else if (Constant.validateEmail(
                                        controller.emailController.value.text) ==
                                        false) {
                                      ShowToastDialog.showToast(
                                          "Please enter valid email".tr);
                                    } else {
                                      if (controller.referralCodeController.value.text
                                          .isNotEmpty) {
                                        FireStoreUtils.checkReferralCodeValidOrNot(
                                            controller
                                                .referralCodeController.value.text)
                                            .then((value) async {
                                          if (value == true) {
                                            ShowToastDialog.showLoader(
                                                "Please wait".tr);
                                            UserModel userModel =
                                                controller.userModel.value;
                                            userModel.fullName = controller
                                                .fullNameController.value.text;
                                            userModel.email =
                                                controller.emailController.value.text;
                                            userModel.countryCode =
                                                controller.countryCode.value;
                                            userModel.phoneNumber = controller
                                                .phoneNumberController.value.text;
                                            userModel.isActive = true;
                                            userModel.createdAt = Timestamp.now();

                                            await FireStoreUtils.getReferralUserByCode(
                                                controller.referralCodeController
                                                    .value.text)
                                                .then((value) async {
                                              if (value != null) {
                                                ReferralModel ownReferralModel =
                                                ReferralModel(
                                                    id: FireStoreUtils
                                                        .getCurrentUid(),
                                                    referralBy: value.id,
                                                    referralCode:
                                                    Constant.getReferralCode());
                                                await FireStoreUtils.referralAdd(
                                                    ownReferralModel);
                                              } else {
                                                ReferralModel referralModel =
                                                ReferralModel(
                                                    id: FireStoreUtils
                                                        .getCurrentUid(),
                                                    referralBy: "",
                                                    referralCode:
                                                    Constant.getReferralCode());
                                                await FireStoreUtils.referralAdd(
                                                    referralModel);
                                              }
                                            });

                                            await FireStoreUtils.updateUser(userModel)
                                                .then((value) {
                                              ShowToastDialog.closeLoader();
                                              print("------>$value");
                                              if (value == true) {
                                                Get.offAll(const DashBoardScreen());
                                              }
                                            });
                                          } else {
                                            ShowToastDialog.showToast(
                                                "Referral code Invalid".tr);
                                          }
                                        });
                                      } else {
                                        ShowToastDialog.showLoader("Please wait".tr);
                                        UserModel userModel =
                                            controller.userModel.value;
                                        userModel.fullName =
                                            controller.fullNameController.value.text;
                                        userModel.email =
                                            controller.emailController.value.text;
                                        userModel.countryCode =
                                            controller.countryCode.value;
                                        userModel.phoneNumber =
                                            controller.phoneNumberController.value.text;
                                        userModel.isActive = true;
                                        userModel.createdAt = Timestamp.now();

                                        ReferralModel referralModel = ReferralModel(
                                            id: FireStoreUtils.getCurrentUid(),
                                            referralBy: "",
                                            referralCode: Constant.getReferralCode());
                                        await FireStoreUtils.referralAdd(referralModel);

                                        await FireStoreUtils.updateUser(userModel)
                                            .then((value) {
                                          ShowToastDialog.closeLoader();
                                          print("------>$value");
                                          if (value == true) {
                                            Get.offAll(const DashBoardScreen());
                                          }
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width * .85,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: Center(
                                      child: Text("CREATE ACCOUNT".tr, style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
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
                        const SizedBox(
                          height: 40,
                        ),


                        // ButtonThem.buildButton(
                        //   context,
                        //   title: "Create account".tr,
                        //   onPress: () async {
                        //     if (controller
                        //         .fullNameController.value.text.isEmpty) {
                        //       ShowToastDialog.showToast(
                        //           "Please enter full name".tr);
                        //     } else if (controller
                        //         .emailController.value.text.isEmpty) {
                        //       ShowToastDialog.showToast(
                        //           "Please enter email".tr);
                        //     } else if (controller
                        //         .phoneNumberController.value.text.isEmpty) {
                        //       ShowToastDialog.showToast(
                        //           "Please enter phone".tr);
                        //     } else if (Constant.validateEmail(
                        //             controller.emailController.value.text) ==
                        //         false) {
                        //       ShowToastDialog.showToast(
                        //           "Please enter valid email".tr);
                        //     } else {
                        //       if (controller.referralCodeController.value.text
                        //           .isNotEmpty) {
                        //         FireStoreUtils.checkReferralCodeValidOrNot(
                        //                 controller
                        //                     .referralCodeController.value.text)
                        //             .then((value) async {
                        //           if (value == true) {
                        //             ShowToastDialog.showLoader(
                        //                 "Please wait".tr);
                        //             UserModel userModel =
                        //                 controller.userModel.value;
                        //             userModel.fullName = controller
                        //                 .fullNameController.value.text;
                        //             userModel.email =
                        //                 controller.emailController.value.text;
                        //             userModel.countryCode =
                        //                 controller.countryCode.value;
                        //             userModel.phoneNumber = controller
                        //                 .phoneNumberController.value.text;
                        //             userModel.isActive = true;
                        //             userModel.createdAt = Timestamp.now();
                        //
                        //             await FireStoreUtils.getReferralUserByCode(
                        //                     controller.referralCodeController
                        //                         .value.text)
                        //                 .then((value) async {
                        //               if (value != null) {
                        //                 ReferralModel ownReferralModel =
                        //                     ReferralModel(
                        //                         id: FireStoreUtils
                        //                             .getCurrentUid(),
                        //                         referralBy: value.id,
                        //                         referralCode:
                        //                             Constant.getReferralCode());
                        //                 await FireStoreUtils.referralAdd(
                        //                     ownReferralModel);
                        //               } else {
                        //                 ReferralModel referralModel =
                        //                     ReferralModel(
                        //                         id: FireStoreUtils
                        //                             .getCurrentUid(),
                        //                         referralBy: "",
                        //                         referralCode:
                        //                             Constant.getReferralCode());
                        //                 await FireStoreUtils.referralAdd(
                        //                     referralModel);
                        //               }
                        //             });
                        //
                        //             await FireStoreUtils.updateUser(userModel)
                        //                 .then((value) {
                        //               ShowToastDialog.closeLoader();
                        //               print("------>$value");
                        //               if (value == true) {
                        //                 Get.offAll(const DashBoardScreen());
                        //               }
                        //             });
                        //           } else {
                        //             ShowToastDialog.showToast(
                        //                 "Referral code Invalid".tr);
                        //           }
                        //         });
                        //       } else {
                        //         ShowToastDialog.showLoader("Please wait".tr);
                        //         UserModel userModel =
                        //             controller.userModel.value;
                        //         userModel.fullName =
                        //             controller.fullNameController.value.text;
                        //         userModel.email =
                        //             controller.emailController.value.text;
                        //         userModel.countryCode =
                        //             controller.countryCode.value;
                        //         userModel.phoneNumber =
                        //             controller.phoneNumberController.value.text;
                        //         userModel.isActive = true;
                        //         userModel.createdAt = Timestamp.now();
                        //
                        //         ReferralModel referralModel = ReferralModel(
                        //             id: FireStoreUtils.getCurrentUid(),
                        //             referralBy: "",
                        //             referralCode: Constant.getReferralCode());
                        //         await FireStoreUtils.referralAdd(referralModel);
                        //
                        //         await FireStoreUtils.updateUser(userModel)
                        //             .then((value) {
                        //           ShowToastDialog.closeLoader();
                        //           print("------>$value");
                        //           if (value == true) {
                        //             Get.offAll(const DashBoardScreen());
                        //           }
                        //         });
                        //       }
                        //     }
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
