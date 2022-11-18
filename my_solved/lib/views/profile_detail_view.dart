import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/User.dart';
import '../view_models/profile_detail_view_model.dart';
import '../widgets/user_widget.dart';

class ProfileDetailView extends StatelessWidget {
  const ProfileDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ProfileDetailViewModel>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(viewModel.handle),
      ),
      child: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FutureBuilder<User>(
                  future: viewModel.future,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // 배경 + 프로필
                          profileHeader(context, snapshot),
                          // 패딩
                          SizedBox(height: 70),
                          Container(padding: EdgeInsets.only(left: 30), child:
                            Column(
                              children: [
                                handle(snapshot),
                                organizations(snapshot),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    solvedCount(snapshot),
                                    SizedBox(width: 10),
                                    reverseRivalCount(snapshot),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              zandi(context, snapshot),
                              Spacer(),
                            ],
                          )
                        ],
                      );
                    } else {
                      return Container(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            profileHeader(context, snapshot),
                          ],
                        ),
                      );
                    }
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension ProfileDetailViewExtension on ProfileDetailView {
  Widget profileHeader(BuildContext context, AsyncSnapshot<User> snapshot) {
    return CupertinoPageScaffold(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          backgroundImage(snapshot),
          Positioned(left: 25, bottom: -50, child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                profileImage(snapshot),
                Positioned(left: 38, top: 65, child: tiers(snapshot)),
              ]
          ),
          ),
        ],
      ),
    );
  }
}

