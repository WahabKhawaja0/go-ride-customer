import 'package:customer/themes/app_colors.dart';
import 'package:customer/ui/home_screens/home_screen.dart';
import 'package:customer/ui/interCity/interCity_screen.dart';
import 'package:customer/ui/intercityOrders/intercity_order_screen.dart';
import 'package:customer/ui/orders/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';



class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/images/banner.png",
              ),
            ),
            SizedBox(height: 80,),
            // const SizedBox(height: ),
            Row(
              children: [
                Expanded(child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(.1)
                          ),
                        ),
                        Positioned(
                          top: 2,
                          left:1,
                          child:Lottie.asset('assets/2.json',height: 100)
                        ),

                      ],
                    ),
                  ),
                )),
                Expanded(child: InkWell(onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InterCityScreen(),
                    ),
                  );
                },
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 90,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(.1)
                          ),
                        ),
                        Positioned(
                          top: 2,
                          left:1,
                          child:Lottie.asset('assets/3.json',height: 100) ),

                      ],
                    ),
                  ),
                )),

              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: Center(
                  child: Text('Car',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20),)
                )),
                Expanded(child: Center(
                    child: Text('Premium Car',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20),)
                )),

              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [

                Expanded(child: InkWell(onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const  OrderScreen(),
                    ),
                  );
                },
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 90,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(.1)
                          ),
                        ),
                        Positioned(
                          // top: 1,
                          right: 0.5,
                          child:Lottie.asset('assets/5.json',height: 100) ),

                      ],
                    ),
                  ),
                )),
                Expanded(child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InterCityOrderScreen(),
                      ),
                    );
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 90,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(.1)
                          ),
                        ),
                        Positioned(
                          top: 30,
                          right: 15,

                          child: Icon(Icons.done_all,size: 50,),
                        ),
                        // Positioned(
                        //   top: 1,
                        //   left: 1,
                        //   child:Lottie.asset('assets/6.json',height: 80)),
                      ],
                    ),
                  ),
                )),

              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: Center(
                    child: Text('Active',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20),)
                )),
                Expanded(child: Center(
                    child: Text('Completed',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20),)
                )),

              ],
            ),
            const SizedBox(height: 15),

            // Row(
            //   children: [
            //     Expanded(
            //       child: InkWell(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => const HomeScreen(),
            //             ),
            //           );
            //         },
            //         borderRadius: BorderRadius.circular(20),
            //         child: Container(
            //           padding: const EdgeInsets.all(20),
            //           decoration: BoxDecoration(
            //             color: AppColors.serviceColor1,
            //             borderRadius: BorderRadius.circular(20),
            //           ),
            //           child: Column(
            //             children: [
            //               SvgPicture.asset(
            //                 "assets/icons/ic_city.svg",
            //                 color: const Color.fromARGB(255, 255, 212, 54),
            //                 width: 30,
            //               ),
            //               const SizedBox(height: 5),
            //               Text(
            //                 "City",
            //                 style: GoogleFonts.poppins(
            //                   color: Colors.black,
            //                   fontSize: 16,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 20),
            //     Expanded(
            //       child: InkWell(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => const InterCityScreen(),
            //             ),
            //           );
            //         },
            //         borderRadius: BorderRadius.circular(20),
            //         child: Container(
            //           padding: const EdgeInsets.all(20),
            //           decoration: BoxDecoration(
            //             color: AppColors.serviceColor2,
            //             borderRadius: BorderRadius.circular(20),
            //           ),
            //           child: Column(
            //             children: [
            //               SvgPicture.asset(
            //                 "assets/icons/ic_intercity.svg",
            //                 color: const Color.fromARGB(255, 99, 88, 255),
            //                 width: 30,
            //               ),
            //               const SizedBox(height: 5),
            //               Text(
            //                 "OutStation",
            //                 style: GoogleFonts.poppins(
            //                   color: Colors.black,
            //                   fontSize: 16,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 15),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Expanded(
            //       child: InkWell(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => const OrderScreen(),
            //             ),
            //           );
            //         },
            //         borderRadius: BorderRadius.circular(20),
            //         child: Container(
            //           padding: const EdgeInsets.all(20),
            //           decoration: BoxDecoration(
            //             color: AppColors.serviceColor1,
            //             borderRadius: BorderRadius.circular(20),
            //           ),
            //           child: Column(
            //             children: [
            //               SvgPicture.asset(
            //                 "assets/icons/ic_order.svg",
            //                 color: const Color.fromARGB(255, 255, 212, 54),
            //                 width: 30,
            //               ),
            //               const SizedBox(height: 5),
            //               Text(
            //                 "Rides",
            //                 style: GoogleFonts.poppins(
            //                   color: Colors.black,
            //                   fontSize: 16,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 20),
            //     Expanded(
            //       child: InkWell(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => const InterCityOrderScreen(),
            //             ),
            //           );
            //         },
            //         borderRadius: BorderRadius.circular(20),
            //         child: Container(
            //           padding: const EdgeInsets.all(20),
            //           decoration: BoxDecoration(
            //             color: AppColors.serviceColor2,
            //             borderRadius: BorderRadius.circular(20),
            //           ),
            //           child: Column(
            //             children: [
            //               SvgPicture.asset(
            //                 "assets/icons/ic_order.svg",
            //                 color: const Color.fromARGB(255, 99, 88, 255),
            //                 width: 30,
            //               ),
            //               const SizedBox(height: 5),
            //               Text(
            //                 "OutStation Rides",
            //                 textAlign: TextAlign.center,
            //                 style: GoogleFonts.poppins(
            //                   color: Colors.black,
            //                   fontSize: 16,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
