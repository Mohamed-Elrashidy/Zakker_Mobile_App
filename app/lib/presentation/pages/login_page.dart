import 'package:app/presentation/widgets/main_button.dart';
import 'package:app/utils/dimension_scale.dart';
import 'package:app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../widgets/big_text.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/small_text.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  Dimension scaleDimension = GetIt.instance.get<Dimension>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: "Login"),
              SizedBox(
                height: scaleDimension.scaleHeight(100),
              ),
              _bodyBuilder(context),
            ],
          ),
        )),
      ),
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    return Column(
      children: [
        _textFieldBuilder("Email", "Enter your email", emailController, true),
        SizedBox(
          height: scaleDimension.scaleHeight(30),
        ),
        _textFieldBuilder(
            "Password", "Enter your password", passwordController, true),
        SizedBox(
          height: scaleDimension.scaleHeight(70),
        ),
        SizedBox(
            width: scaleDimension.scaleHeight(100),
            child: MainButton(
                title: "Login",
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                })),
        SizedBox(
          height: scaleDimension.scaleHeight(70),
        ),
        GestureDetector(
          onTap: (){
            Navigator.of(context).pushReplacementNamed(Routes.singUpPage);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmallText(text: "Do you don’t have one ? "),
              SmallText(
                text: "create.",
                isBold: true,
                color: Colors.black,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _textFieldBuilder(String title, String hint,
      TextEditingController controller, bool isFullWidth) {
    return Container(
      width: isFullWidth
          ? scaleDimension.screenWidth
          : scaleDimension.screenWidth / 2 - scaleDimension.scaleWidth(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigText(text: title, size: scaleDimension.scaleWidth(18)),
          SizedBox(
            height: scaleDimension.scaleHeight(10),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: scaleDimension.scaleWidth(10)),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(scaleDimension.scaleWidth(16)),
                border: Border.all(color: Colors.grey[400]!, width: 1.5)),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                    fontSize: scaleDimension.scaleWidth(14),
                    color: Colors.grey[400]),
                border: InputBorder.none,
                suffixIcon: (title == 'Password')
                    ? IconButton(
                        onPressed: () {}, icon: Icon(Icons.visibility_off))
                    : Container(width: 0,),


              ),
            ),
          )
        ],
      ),
    );
  }
}
