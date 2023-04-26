import 'package:app/data/services/notification_services.dart';
import 'package:app/presentation/widgets/big_text.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../utils/dimension_scale.dart';

class HomePage extends StatelessWidget {
  late Dimension scaleDimension;
  @override
  Widget build(BuildContext context) {
    dimensionInit(context);
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          _appBarBuilder(),
          SizedBox(
            height: scaleDimension.scaleHeight(100),
          ),
          pdfReaderWidget(),
          SizedBox(
            height: scaleDimension.scaleHeight(30),
          ),
          TodaysSession()
        ],
      ),
    ));
  }

  Widget _appBarBuilder() {
    return Column(
      children: [
        SizedBox(
          height: scaleDimension.scaleHeight(5),
        ),
        BigText(text: "Home Page"),
        SizedBox(
          height: scaleDimension.scaleHeight(10),
        ),
        Container(
          width: scaleDimension.screenWidth,
          height: 2,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget pdfReaderWidget() {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(scaleDimension.scaleWidth(16)),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/images/pdf_icon.svg",
                height: scaleDimension.scaleWidth(110),
              ),
              SizedBox(
                height: scaleDimension.scaleHeight(10),
              ),
              NormalText(
                text: "Open Pdf",
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget TodaysSession() {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(scaleDimension.scaleWidth(16)),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/images/todays_session_icon.svg",
                height: scaleDimension.scaleWidth(110),
              ),
              SizedBox(
                height: scaleDimension.scaleHeight(10),
              ),
              NormalText(
                text: "Today's session",
                color: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }

  dimensionInit(BuildContext context) {
    try {
      // Get the intialized instance of Dimension class to make ui scalable

      Dimension scaleDimension = GetIt.instance.get<Dimension>();
      this.scaleDimension = scaleDimension;
    } catch (e) {
      GetIt locator = GetIt.instance;
      locator.registerSingleton<Dimension>(Dimension(context: context));

      // Get the initialized instance of Dimension class to make ui scalable
      Dimension scaleDimension = GetIt.instance.get<Dimension>();
      this.scaleDimension = scaleDimension;
    }
  }
}
