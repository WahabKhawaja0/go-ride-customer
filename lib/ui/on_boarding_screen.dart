
import 'package:customer/ui/auth_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/DarkThemeProvider.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .9,
              width: double.infinity,
              child: Image.asset('assets/bg.jpeg' , fit: BoxFit.fill,),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * .2,
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
                        Get.off(LoginScreen());
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .85,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Center(
                          child: Text('Continue with phone number' , style: TextStyle(
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
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 200,
                    width: 200,
                    child: Image.asset("assets/app_logo.png"),
                  )
              ),
            ),


          ],
        ),
      ),

      // controller.isLoading.value
      //     ? Constant.loader(context)
      //     : Stack(
      //         children: [
      //           controller.selectedPageIndex.value == 0
      //               ? Image.asset("assets/images/onboarding_1.png")
      //               : controller.selectedPageIndex.value == 1
      //                   ? Image.asset("assets/images/onboarding_2.png")
      //                   : Image.asset("assets/images/onboarding_3.png"),
      //           Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Expanded(
      //                 flex: 3,
      //                 child: PageView.builder(
      //                     controller: controller.pageController,
      //                     onPageChanged: controller.selectedPageIndex,
      //                     itemCount: controller.onBoardingList.length,
      //                     itemBuilder: (context, index) {
      //                       return Column(
      //                         children: [
      //                           const SizedBox(
      //                             height: 80,
      //                           ),
      //                           Expanded(
      //                             flex: 2,
      //                             child: Padding(
      //                               padding: const EdgeInsets.all(40),
      //                               child: CachedNetworkImage(
      //                                 imageUrl: controller.onBoardingList[index].image.toString(),
      //                                 fit: BoxFit.cover,
      //                                 placeholder: (context, url) => Constant.loader(context),
      //                                 errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
      //                               ),
      //                             ),
      //                           ),
      //                           const SizedBox(
      //                             height: 10,
      //                           ),
      //                           Expanded(
      //                             child: Column(
      //                               children: [
      //                                 Text(
      //                                   controller.onBoardingList[index].title.toString(),
      //                                   style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1.5,
      //                                       color: themeChange.getThem() ? Colors.white : Colors.black
      //
      //                                   ),
      //                                 ),
      //                                 const SizedBox(
      //                                   height: 10,
      //                                 ),
      //                                 Padding(
      //                                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
      //                                   child: Text(
      //                                     controller.onBoardingList[index].description.toString(),
      //                                     textAlign: TextAlign.center,
      //                                     style: GoogleFonts.poppins(fontWeight: FontWeight.w400, letterSpacing: 1.5,
      //                                         color: themeChange.getThem() ? Colors.white : Colors.black
      //
      //                                     ),
      //                                   ),
      //                                 ),
      //                               ],
      //                             ),
      //                           )
      //                         ],
      //                       );
      //                     }),
      //               ),
      //               Expanded(
      //                   child: Column(
      //                 children: [
      //                   InkWell(
      //                       onTap: () {
      //                         controller.pageController.jumpToPage(2);
      //                       },
      //                       child: Text(
      //                         'skip'.tr,
      //                         style: TextStyle(fontSize: 16, letterSpacing: 1.5, fontWeight: FontWeight.w600,
      //                             color: themeChange.getThem() ? Colors.white : Colors.black
      //
      //                         ),
      //                       )),
      //                   Padding(
      //                     padding: const EdgeInsets.symmetric(vertical: 30),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: List.generate(
      //                         controller.onBoardingList.length,
      //                         (index) => Container(
      //                             margin: const EdgeInsets.symmetric(horizontal: 4),
      //                             width: controller.selectedPageIndex.value == index ? 30 : 10,
      //                             height: 10,
      //                             decoration: BoxDecoration(
      //                               color: controller.selectedPageIndex.value == index ? AppColors.primary : const Color(0xffD4D5E0),
      //                               borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      //                             )),
      //                       ),
      //                     ),
      //                   ),
      //                   ButtonThem.buildButton(
      //                     context,
      //                     title: controller.selectedPageIndex.value == 2 ? 'Get started'.tr : 'Next'.tr,
      //                     btnRadius: 30,
      //                     onPress: () {
      //                       if (controller.selectedPageIndex.value == 2) {
      //                         Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
      //                         Get.offAll(const LoginScreen());
      //                       } else {
      //                         controller.pageController.jumpToPage(controller.selectedPageIndex.value + 1);
      //                       }
      //                     },
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                 ],
      //               ))
      //             ],
      //           ),
      //         ],
      //       ),
    );


    //   GetX<OnBoardingController>(
    //   init: OnBoardingController(),
    //   builder: (controller) {
    //     return
    //   },
    // );
  }
}
