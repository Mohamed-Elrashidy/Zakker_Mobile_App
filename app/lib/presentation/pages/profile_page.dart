import 'package:app/presentation/controllers/user_controller/user_cubit.dart';
import 'package:app/presentation/widgets/big_text.dart';
import 'package:app/presentation/widgets/main_button.dart';
import 'package:app/presentation/widgets/normal_text.dart';
import 'package:app/services/sync_service.dart';
import 'package:app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/user.dart';
import '../../utils/dimension_scale.dart';

class ProfilePage extends StatelessWidget {
  Dimension scaleDimension = GetIt.instance.get<Dimension>();
  User? user;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UserCubit>(context).getUserInfo();

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_appBarBuilder(), _bodyBuilder(context),
          ],
        ),
      ),
    );
  }

  Widget _appBarBuilder() {
    return Column(
      children: [
        SizedBox(
          height: scaleDimension.scaleHeight(20),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigText(text: "Profile"),
          ],
        ),
        SizedBox(
          height: scaleDimension.scaleHeight(20),
        ),
      ],
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    bool isLogin = false;
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserInfoLoaded) {
        isLogin = true;
        user = state.user;
      }
      return isLogin ? loggedPage() : unLoggedPage(context);
    });
  }

  Widget loggedPage() {
    return Padding(
      padding: EdgeInsets.all(scaleDimension.scaleWidth(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: scaleDimension.scaleHeight(50),
          ),
          loggedPageItem("Name", user!.name),
          loggedPageItem("Email", user!.email),
          SizedBox(height: scaleDimension.scaleHeight(250),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MainButton(title: "Sync data", onTap: (){
                GetIt.instance.get<SyncService>().syncData();
              })
            ],)
        ],
      ),
    );
  }

  Widget unLoggedPage(BuildContext context) {
    return SizedBox(
      height: scaleDimension.screenHeight - scaleDimension.scaleHeight(150),
      child: Center(
        child: InkWell(
          onTap: (){
            Navigator.of(context,rootNavigator: true).pushNamed(Routes.loginPage);
          },
          child: Container(
            width: scaleDimension.screenWidth - scaleDimension.scaleWidth(30),
            height: scaleDimension.scaleHeight(100),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius:
                    BorderRadius.circular(scaleDimension.scaleWidth(20))),
            child: Center(
                child: BigText(text: "Sign In", size: 40, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget loggedPageItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          text: title,
          color: Colors.grey,
        ),
        SizedBox(
          height: scaleDimension.scaleHeight(10),
        ),
        NormalText(text: value),
        SizedBox(
          height: scaleDimension.scaleHeight(20),
        )
      ],
    );
  }


}
