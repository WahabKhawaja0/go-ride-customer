import 'package:customer/constant/constant.dart';
import 'package:customer/model/faq_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeChange.getThem()
          ? AppColors.background
          : AppColors.background,
      body: Column(
        children: [
          SizedBox(
            height: Responsive.width(8, context),
            width: Responsive.width(100, context),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("FAQs".tr,
                          style: GoogleFonts.poppins(
                              color: themeChange.getThem()
                                  ? Colors.black
                                  : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                      Text("Read FAQs solution".tr,
                          style: GoogleFonts.poppins(
                            color: themeChange.getThem()
                                ? Colors.black
                                :  Colors.black,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: FutureBuilder<List<FaqModel>?>(
                            future: FireStoreUtils.getFaq(),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Constant.loader();
                                case ConnectionState.done:
                                  if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  } else {
                                    List<FaqModel> faqList = snapshot.data!;
                                    return ListView.builder(
                                      itemCount: faqList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        FaqModel faqModel = faqList[index];
                                        return InkWell(
                                          onTap: () {
                                            faqModel.isShow = true;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: themeChange.getThem()
                                                      ? AppColors
                                                      .containerBackground
                                                      : AppColors
                                                      .containerBackground,
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                                  border: Border.all(
                                                      color: themeChange.getThem()
                                                          ? AppColors
                                                          .darkContainerBorder
                                                          : AppColors
                                                          .darkContainerBorder,
                                                      width: 0.5),
                                                  boxShadow: themeChange.getThem()
                                                      ? null
                                                      : null
                                              ),
                                              child: ExpansionTile(
                                                collapsedIconColor:
                                                themeChange.getThem()
                                                    ? Colors.black
                                                    : Colors.black,
                                                title: Text(
                                                    faqModel.title.toString(),
                                                    style: GoogleFonts.poppins(
                                                      color:
                                                      themeChange.getThem()
                                                          ? Colors.black
                                                          : Colors.black,
                                                    )),
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Text(
                                                        faqModel.description
                                                            .toString(),
                                                        style:
                                                        GoogleFonts.poppins(
                                                          color: themeChange
                                                              .getThem()
                                                              ? Colors.black
                                                              : Colors.black,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                default:
                                  return Text('Error'.tr);
                              }
                            },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}