import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_solved/models/user/tag_ratings.dart';
import 'package:my_solved/models/user/top_100.dart';
import 'package:my_solved/services/network_service.dart';
import 'package:my_solved/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/User.dart';
import '../models/user/badges.dart';
import '../models/user/grass.dart';
import '../views/setting_view.dart';
import '../widgets/ImageShadow.dart';

/// ************************************************
/// User Widget
/// *************************************************
Widget profileHeader(BuildContext context, AsyncSnapshot<User> snapshot) {
  String handle = UserService().name;
  return Stack(
    clipBehavior: Clip.none,
    children: <Widget>[
      backgroundImage(context, snapshot),
      snapshot.data!.handle == handle
          ? Align(
              alignment: Alignment.topRight,
              child: CupertinoButton(
                child: Icon(
                  CupertinoIcons.gear_solid,
                  color: CupertinoColors.white,
                ),
                onPressed: () => Navigator.of(context).push(
                  CupertinoPageRoute(
                    maintainState: false,
                    builder: (BuildContext context) {
                      return SettingView();
                    },
                  ),
                ),
              ),
            )
          : Container(),
      Positioned(
        bottom: -50,
        left: 20,
        child: profileImage(context, snapshot),
      ),
      Positioned(
        bottom: -58,
        right: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            solvedCount(context, snapshot),
            voteCount(context, snapshot),
            reverseRivalCount(context, snapshot)
          ],
        ),
      ),
    ],
  );
}

Widget profileDetail(BuildContext context, AsyncSnapshot<User> snapshot) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.only(top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            handle(context, snapshot),
            Wrap(
              children: [
                badge(context, snapshot),
                classes(context, snapshot),
              ],
            )
          ],
        ),
        snapshot.data!.bio!.isNotEmpty
            ? SizedBox(height: 5)
            : SizedBox.shrink(),
        bio(context, snapshot),
        snapshot.data!.organizations.isNotEmpty
            ? SizedBox(height: 5)
            : SizedBox.shrink(),
        organizations(context, snapshot),
      ],
    ),
  );
}

Widget zandi(BuildContext context, AsyncSnapshot<User> snapshot) {
  return Consumer<UserService>(
    builder: (context, provider, child) {
      int zandiTheme = UserService().streakTheme;
      return Stack(
        children: [
          SvgPicture.asset(
            zandiTheme == 2
                ? 'lib/assets/zandi_dark.svg'
                : 'lib/assets/zandi.svg',
            width: MediaQuery.of(context).size.width,
          ),
          SvgPicture.network(
            zandiUrl(snapshot.data?.handle ?? ''),
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.8 * 0.07,
            bottom: MediaQuery.of(context).size.width * 0.4 * 0.91,
            child: Container(
                color: zandiTheme == 2 ? Color(0xFF3f3f3f) : Color(0xFFfdfdfd),
                width: MediaQuery.of(context).size.width * 0.82,
                height: MediaQuery.of(context).size.width * 0.4 * 0.15,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'lib/assets/icons/streak.svg',
                      width: MediaQuery.of(context).size.width * 0.4 * 0.10,
                      height: MediaQuery.of(context).size.width * 0.4 * 0.10,
                      color: zandiTheme == 2 ? Colors.white : Color(0xff8a8f95),
                    ),
                    SizedBox(width: 5),
                    Text(
                      // 'Rating: ${snapshot.data?.rating}',
                      '스트릭',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        // fontWeight: FontWeight.bold,
                        color:
                            zandiTheme == 2 ? Colors.white : Color(0xff8a8f95),
                      ),
                    ),
                    Spacer(),
                    maxStreak(context, snapshot),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4 * 0.1),
                  ],
                )),
          ),
        ],
      );
    },
  );
}

Widget top100(BuildContext context, AsyncSnapshot<User> snapshot,
    Future<Top_100> future) {
  int rating = snapshot.data?.rating ?? 0;
  int tier = snapshot.data?.tier ?? 0;
  int rank = snapshot.data?.rank ?? 0;

  String tierStr(int tier) {
    if (tier == 1) {
      return 'Bronze V';
    } else if (tier == 2) {
      return 'Bronze IV';
    } else if (tier == 3) {
      return 'Bronze III';
    } else if (tier == 4) {
      return 'Bronze II';
    } else if (tier == 5) {
      return 'Bronze I';
    } else if (tier == 6) {
      return 'Silver V';
    } else if (tier == 7) {
      return 'Silver IV';
    } else if (tier == 8) {
      return 'Silver III';
    } else if (tier == 9) {
      return 'Silver II';
    } else if (tier == 10) {
      return 'Silver I';
    } else if (tier == 11) {
      return 'Gold V';
    } else if (tier == 12) {
      return 'Gold IV';
    } else if (tier == 13) {
      return 'Gold III';
    } else if (tier == 14) {
      return 'Gold II';
    } else if (tier == 15) {
      return 'Gold I';
    } else if (tier == 16) {
      return 'Platinum V';
    } else if (tier == 17) {
      return 'Platinum IV';
    } else if (tier == 18) {
      return 'Platinum III';
    } else if (tier == 19) {
      return 'Platinum II';
    } else if (tier == 20) {
      return 'Platinum I';
    } else if (tier == 21) {
      return 'Diamond V';
    } else if (tier == 22) {
      return 'Diamond IV';
    } else if (tier == 23) {
      return 'Diamond III';
    } else if (tier == 24) {
      return 'Diamond II';
    } else if (tier == 25) {
      return 'Diamond I';
    } else if (tier == 26) {
      return 'Ruby V';
    } else if (tier == 27) {
      return 'Ruby IV';
    } else if (tier == 28) {
      return 'Ruby III';
    } else if (tier == 29) {
      return 'Ruby II';
    } else if (tier == 30) {
      return 'Ruby I';
    } else if (tier == 31) {
      return 'Master';
    } else {
      return 'Unrated';
    }
  }

  Widget top100Header(int rating, int tier, int rank, BuildContext context) {
    Color rankBoxColor(int rankNum) {
      if (rankNum == 1) {
        return Color(0xFFFFB028);
      } else if (rankNum < 11) {
        return Color(0xFF435F7A);
      } else if (rankNum < 101) {
        return Color(0xFFAD5600);
      } else {
        return Color(0xFFDDDFE0);
      }
    }

    Widget masterHandle(int rating, BuildContext context) {
      return ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7cf9ff), Color(0xFFb491ff), Color(0xFFff7ca8)],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.srcATop,
        child: Text(
          'Master $rating',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.4 * 0.14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.015,
        top: MediaQuery.of(context).size.width * 0.045,
        right: MediaQuery.of(context).size.width * 0.015,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          rating < 3000
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${tierStr(tier)} ',
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width * 0.4 * 0.14,
                          fontFamily: 'Pretendard',
                          color: ratingColor(rating),
                        )),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width * 0.4 * 0.14,
                        fontFamily: 'Pretendard-ExtraBold',
                        fontWeight: FontWeight.bold,
                        color: ratingColor(rating),
                      ),
                    ),
                  ],
                )
              : masterHandle(rating, context),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: rankBoxColor(rank),
            ),
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Text(
              rank < 1000
                  ? '#$rank'
                  : '#${(rank / 1000).floor()},${(rank % 1000).toString().padLeft(3).replaceAll(' ', '0')}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.4 * 0.11,
                fontFamily: 'Pretendard-Regular',
                fontWeight: FontWeight.bold,
                color: rank == 1 || 100 < rank ? Colors.black : Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget top100Box(BuildContext context, dynamic cur) {
    return CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        color: Colors.transparent,
        onPressed: () {
          launchUrlString('https://www.acmicpc.net/problem/${cur['problemId']}',
              mode: LaunchMode.externalApplication);
        },
        child: Tooltip(
            preferBelow: false,
            message: cur['titleKo'],
            textStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.4 * 0.1,
              fontFamily: 'Pretendard-Regular',
              color: Colors.white,
            ),
            child: SvgPicture.asset('lib/assets/tiers/${cur['level']}.svg',
                width: MediaQuery.of(context).size.width * 0.041)));
  }

  return FutureBuilder<Top_100>(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        int count = snapshot.data?.count ?? 0;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xfff7f8f9),
          ),
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.025,
            right: MediaQuery.of(context).size.width * 0.025,
          ),
          child: Column(
            children: [
              top100Header(rating, tier, rank, context),
              const SizedBox(height: 10),
              GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                    childAspectRatio: 1,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: count,
                  itemBuilder: (BuildContext context, int index) {
                    return top100Box(context, snapshot.data!.items[index]);
                  }),
            ],
          ),
        );
      } else {
        return CupertinoActivityIndicator();
      }
    },
  );
}

Widget badges(BuildContext context, Future<Badges> future) {
  return FutureBuilder<Badges>(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        int count = snapshot.data!.count;

        List<List<dynamic>> temp = [[], [], [], []];
        for (int i = 0; i < count; i++) {
          if (snapshot.data!.items[i]['badgeCategory'] == 'achievement') {
            temp[0].add(snapshot.data!.items[i]);
          } else if (snapshot.data!.items[i]['badgeCategory'] == 'season') {
            temp[1].add(snapshot.data!.items[i]);
          } else if (snapshot.data!.items[i]['badgeCategory'] == 'event') {
            temp[2].add(snapshot.data!.items[i]);
          } else if (snapshot.data!.items[i]['badgeCategory'] == 'contest') {
            temp[3].add(snapshot.data!.items[i]);
          }
        }
        temp[0].sort((a, b) => a['badgeId'].compareTo(b['badgeId']));

        List<dynamic> badges = [];
        for (int i = 0; i < 4; i++) {
          for (int j = 0; j < temp[i].length; j++) {
            badges.add(temp[i][j]);
          }
        }

        Widget badgeTier(BuildContext context, dynamic badge, int idx) {
          String tier = badge['badgeTier'];
          bool isContest = badge['badgeCategory'] == 'contest';
          Color tierColor = Colors.white;
          if (tier == 'bronze') {
            tierColor = Color(0xffad5600);
          } else if (tier == 'silver') {
            tierColor = Color(0xff435f7a);
          } else if (tier == 'gold') {
            tierColor = Color(0xffec9a00);
          } else if (tier == 'master') {
            tierColor = Color(0xffff99d8);
          }
          return badge == null
              ? SizedBox()
              : Tooltip(
                  preferBelow: false,
                  richMessage: TextSpan(children: [
                    TextSpan(
                      text: badge['displayName'],
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontFamily: 'Pretendard-Regular',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '\n',
                    ),
                    TextSpan(
                        text: badge['displayDescription'],
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontFamily: 'Pretendard-Regular',
                          color: Colors.white,
                        ))
                  ]),
                  triggerMode: TooltipTriggerMode.tap,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      ExtendedImage.network(
                        'https://static.solved.ac/profile_badge/120x120/${badge['badgeId']}.png',
                        width: MediaQuery.of(context).size.width * 0.1,
                        fit: BoxFit.cover,
                        cache: true,
                        loadStateChanged: (ExtendedImageState state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            case LoadState.completed:
                              return null;
                            case LoadState.failed:
                              return Center(
                                child: Icon(Icons.error),
                              );
                          }
                        },
                      ),
                      isContest
                          ? SizedBox.shrink()
                          : Positioned(
                              bottom: 15,
                              right: 15,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.02,
                                height:
                                    MediaQuery.of(context).size.width * 0.02,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.014,
                                  height:
                                      MediaQuery.of(context).size.width * 0.014,
                                  decoration: BoxDecoration(
                                    color: tierColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )),
                    ],
                  ),
                );
        }

        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xfff7f8f9),
            ),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 1,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  return badgeTier(context, badges[index], index);
                }));
      } else {
        return CupertinoActivityIndicator();
      }
    },
  );
}

Widget backgroundImage(BuildContext context, AsyncSnapshot<User> snapshot) {
  return Consumer<UserService>(builder: (context, provider, child) {
    bool isIllustration = provider.isIllustration;
    return CupertinoPageScaffold(
        child: ExtendedImage.network(
      isIllustration
          ? snapshot.data?.background['backgroundImageUrl'] ?? ''
          : snapshot.data?.background['fallbackBackgroundImageUrl'] ??
              snapshot.data?.background['backgroundImageUrl'] ??
              '',
      cache: true,
      fit: BoxFit.fitWidth,
    ));
  });
}

Widget profileImage(BuildContext context, AsyncSnapshot<User> snapshot) {
  return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ratingColor(snapshot.data?.rating ?? 0).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
              child: ExtendedImage.network(
            snapshot.data?.profileImageUrl ??
                'https://static.solved.ac/misc/360x360/default_profile.png',
            cache: true,
            fit: BoxFit.cover,
          )),
          Positioned(bottom: -20, left: 35, child: tiers(context, snapshot))
        ],
      ));
}

Widget tagChart(BuildContext context, AsyncSnapshot<User> userSnapshot) {
  NetworkService networkService = NetworkService();

  return FutureBuilder<List<TagRatings>>(
    future: networkService.requestTagRatings(userSnapshot.data?.handle ?? ''),
    builder: (context, snapshot) {
      List<TagRatings>? tags = snapshot.data;
      tags?.sort((a, b) => b.rating.compareTo(a.rating));

      List<int> ticks = [];
      List<String> features = [];
      List<List<num>> data = [[]];

      int? length = min(8, snapshot.data?.length ?? 0);
      int maxTick = 0;
      for (var i = 0; i < length; i++) {
        features.add(snapshot.data?[i].tag['key'] ?? '');
        data[0].add(snapshot.data?[i].rating ?? 0);
        maxTick = max(maxTick, data[0][i].toInt());
      }
      maxTick = (maxTick + 500) ~/ 500 * 500;
      while (maxTick > 0) {
        ticks.add(maxTick);
        maxTick -= 500;
      }
      if (snapshot.hasData) {
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xfff7f8f9),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.025,
                vertical: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.6,
                child: RadarChart(
                  ticks: ticks.reversed.toList(),
                  features: features,
                  data: data,
                  outlineColor: Color(0xff8a8f95),
                  featuresTextStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    color: Colors.black,
                  ),
                  graphColors: [ratingColor(userSnapshot.data?.rating ?? 0)],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '태그',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Color(0xff8a8f95),
                    ),
                  ),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  Text(
                    '문제',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Color(0xff8a8f95),
                    ),
                  ),
                  Spacer(),
                  Spacer(),
                  Text(
                    '레이팅',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Color(0xff8a8f95),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: Text(
                            tags?[index].tag['displayNames'][0]['name'] ?? '',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            tags?[index].solvedCount.toString() ?? '',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'lib/assets/tiers/${ratingToTier(tags![index].rating)}.svg',
                              width: MediaQuery.of(context).size.width * 0.035,
                            ),
                            SizedBox(width: 3),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                tags[index].rating.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                  color: ratingColor(tags[index].rating),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemCount: length),
            ]));
      } else {
        return Container();
      }
    },
  );
}

/// ************************************************
/// Simple Widget
/// *************************************************
// 핸들
Widget handle(BuildContext context, AsyncSnapshot<User> snapshot) {
  return Text(
    snapshot.data?.handle ?? '',
    style: TextStyle(
      color: CupertinoColors.black,
      // color: CupertinoTheme.of(context).textTheme.textStyle.color,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  );
}

// 소속
Widget organizations(BuildContext context, AsyncSnapshot<User> snapshot) {
  List<dynamic> companies = [];
  List<dynamic> schools = [];
  List<dynamic> communities = [];
  for (var i = 0; i < snapshot.data!.organizations.length; i++) {
    if (snapshot.data!.organizations[i]['type'] == 'community') {
      communities.add(snapshot.data!.organizations[i]['name']);
    } else if (snapshot.data!.organizations[i]['type'] == 'company') {
      companies.add(snapshot.data!.organizations[i]['name']);
    } else {
      schools.add(snapshot.data!.organizations[i]['name']);
    }
  }

  return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
        companies.isEmpty
            ? SizedBox.shrink()
            : Container(
                margin: EdgeInsets.only(right: 5),
                child: SvgPicture.asset(
                  'lib/assets/icons/company.svg',
                  color: Colors.grey,
                  width: 15,
                  height: 15,
                ),
              ),
        for (var i = 0; i < companies.length; i++)
          RichText(
            text: TextSpan(
              children: [
                (0 < i) ? TextSpan(text: ", ") : TextSpan(),
                TextSpan(
                  text: companies[i],
                ),
              ],
              style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width * 0.035,
              ),
            ),
          ),
        companies.isNotEmpty && (schools.isNotEmpty || communities.isNotEmpty)
            ? SizedBox(
                width: 5,
              )
            : SizedBox.shrink(),
        schools.isEmpty
            ? SizedBox.shrink()
            : Container(
                margin: EdgeInsets.only(right: 5),
                child: SvgPicture.asset(
                  'lib/assets/icons/school.svg',
                  color: Colors.grey,
                  width: 15,
                  height: 15,
                ),
              ),
        for (var i = 0; i < schools.length; i++)
          RichText(
            text: TextSpan(
              children: [
                (0 < i) ? TextSpan(text: ", ") : TextSpan(),
                TextSpan(
                  text: schools[i],
                ),
              ],
              style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width * 0.035,
              ),
            ),
          ),
        (companies.isNotEmpty || schools.isNotEmpty) && communities.isNotEmpty
            ? SizedBox.shrink()
            : SizedBox(
                width: 5,
              ),
        communities.isEmpty
            ? SizedBox.shrink()
            : Container(
                margin: EdgeInsets.only(right: 5),
                child: SvgPicture.asset(
                  'lib/assets/icons/community.svg',
                  color: Colors.grey,
                  width: 15,
                  height: 15,
                ),
              ),
        for (var i = 0; i < communities.length; i++)
          RichText(
            text: TextSpan(
              children: [
                (0 < i) ? TextSpan(text: ", ") : TextSpan(),
                TextSpan(
                  text: communities[i],
                ),
              ],
              style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width * 0.035,
              ),
            ),
          ),
      ]));
}

// 자기소개
Widget bio(BuildContext context, AsyncSnapshot<User> snapshot) {
  return snapshot.data?.bio?.isEmpty ?? true
      ? SizedBox.shrink()
      : Text(
          snapshot.data?.bio ?? '',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        );
}

// 클래스
Widget classes(BuildContext context, AsyncSnapshot<User> snapshot) {
  String userClass = snapshot.data?.userClass.toString() ?? '';
  if (snapshot.data?.classDecoration == "silver") {
    userClass += 's';
  } else if (snapshot.data?.classDecoration == "gold") {
    userClass += 'g';
  }

  return CupertinoButton(
      padding: EdgeInsets.zero,
      color: Colors.transparent,
      onPressed: () {
        launchUrlString('https://solved.ac/class',
            mode: LaunchMode.externalApplication);
      },
      child: SvgPicture.asset(
        'lib/assets/classes/c$userClass.svg',
        width: 50,
        height: 50,
      ));
}

// 티어
Widget tiers(BuildContext context, AsyncSnapshot<User> snapshot) {
  return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: SvgPicture.asset(
          'lib/assets/tiers/${snapshot.data?.tier}.svg',
          width: 40,
          height: 40,
        ),
      ));
}

// 레이팅
Widget rating(BuildContext context, AsyncSnapshot<User> snapshot) {
  return CupertinoPageScaffold(
    backgroundColor: Colors.transparent,
    child: Text(
      snapshot.data?.rating.toString() ?? '',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        color: Colors.grey,
      ),
    ),
  );
}

// 푼 문제 수
Widget solvedCount(BuildContext context, AsyncSnapshot<User> snapshot) {
  return Container(
    width: MediaQuery.of(context).size.width / 5,
    clipBehavior: Clip.none,
    child: Column(
      children: [
        Text(
          snapshot.data?.solvedCount.toString() ?? '',
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '해결',
          style: TextStyle(
            color: Colors.grey,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ],
    ),
  );
}

// 기여 수
Widget voteCount(BuildContext context, AsyncSnapshot<User> snapshot) {
  return Container(
    width: MediaQuery.of(context).size.width / 5,
    clipBehavior: Clip.none,
    child: Column(
      children: [
        Text(
          snapshot.data?.voteCount.toString() ?? '',
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '기여',
          style: TextStyle(
            color: Colors.grey,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ],
    ),
  );
}

// 라이벌 수
Widget reverseRivalCount(BuildContext context, AsyncSnapshot<User> snapshot) {
  return Container(
    width: MediaQuery.of(context).size.width / 5,
    clipBehavior: Clip.none,
    child: Column(
      children: [
        Text(
          snapshot.data?.reverseRivalCount.toString() ?? '',
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '라이벌',
          style: TextStyle(
            color: Colors.grey,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ],
    ),
  );
}

// 랭크
Widget rank(BuildContext context, AsyncSnapshot<User> snapshot) {
  return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          snapshot.data?.rank.toString() ?? '',
        ),
      ));
}

// 잔디 테마
String zandiUrl(String handle) {
  int zandiTheme = UserService().streakTheme;
  String theme = '';
  if (zandiTheme == 0) {
    theme = 'warm';
  } else if (zandiTheme == 1) {
    theme = 'cold';
  } else if (zandiTheme == 2) {
    theme = 'dark';
  }
  return 'http://mazandi.herokuapp.com/api?handle=$handle&theme=$theme';
}

// 최대 연속 문제 해결일 수
Widget maxStreak(BuildContext context, AsyncSnapshot<User> snapshot) {
  int zandiTheme = UserService().streakTheme;
  return Text(
    '최장 ${snapshot.data?.maxStreak.toString()}일',
    style: TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.4 * 0.1,
      // fontWeight: FontWeight.bold,
      color: zandiTheme == 2 ? Colors.white : Color(0xff8a8f95),
    ),
  );
}

// 현재 연속 문제 해결일 수
Widget currentStreak(BuildContext context, AsyncSnapshot<Grass> snapshot) {
  int zandiTheme = UserService().streakTheme;
  return Text(
    '현재 ${snapshot.data?.currentStreak}일',
    style: TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.4 * 0.1,
      // fontWeight: FontWeight.bold,
      color: zandiTheme == 2 ? Colors.white : Color(0xff8a8f95),
    ),
  );
}

// 경험치
Widget exp(BuildContext context, AsyncSnapshot<User> snapshot) {
  return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          snapshot.data?.exp.toString() ?? '',
        ),
      ));
}

// 배지
Widget badge(BuildContext context, AsyncSnapshot<User> snapshot) {
  if (snapshot.data?.badge == null) {
    return SizedBox();
  }

  String tier = snapshot.data!.badge['badgeTier'];
  bool isContest = snapshot.data!.badge['badgeCategory'] == 'contest';
  Color tierColor = Colors.white;
  if (tier == 'bronze') {
    tierColor = Color(0xffad5600);
  } else if (tier == 'silver') {
    tierColor = Color(0xff435f7a);
  } else if (tier == 'gold') {
    tierColor = Color(0xffec9a00);
  } else if (tier == 'master') {
    tierColor = Color(0xffff99d8);
  }
  return snapshot.data?.badge == null
      ? SizedBox()
      : ImageShadow(
          opacity: 0.2,
          child: Tooltip(
            preferBelow: false,
            triggerMode: TooltipTriggerMode.tap,
            richMessage: TextSpan(
              children: [
                TextSpan(
                  text: snapshot.data!.badge['displayName'],
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.4 * 0.1,
                    fontFamily: 'Pretendard-Regular',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(text: '\n'),
                TextSpan(
                  text: snapshot.data!.badge['displayDescription'],
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.4 * 0.1,
                    fontFamily: 'Pretendard-Regular',
                    color: Colors.white,
                  ),
                )
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ImageShadow(
                    opacity: 0.2,
                    child: ExtendedImage.network(
                      'https://static.solved.ac/profile_badge/120x120/${snapshot.data!.badge['badgeId']}.png',
                      width: MediaQuery.of(context).size.width * 0.11,
                      fit: BoxFit.cover,
                      cache: true,
                      loadStateChanged: (ExtendedImageState state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          case LoadState.completed:
                            return null;
                          case LoadState.failed:
                            return Center(
                              child: Icon(Icons.error),
                            );
                        }
                      },
                    )),
                isContest
                    ? SizedBox.shrink()
                    : Positioned(
                        bottom: -5,
                        right: -1,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.02,
                            height: MediaQuery.of(context).size.width * 0.02,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.014,
                              height: MediaQuery.of(context).size.width * 0.014,
                              decoration: BoxDecoration(
                                color: tierColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        )),
              ],
            ),
          ));
}

Color levelColor(int level) {
  if (level == 0) {
    return Color(0xFF2D2D2D);
  } else if (level < 6) {
    // bronze
    return Color(0xffad5600);
  } else if (level < 11) {
    // silver
    return Color(0xFF425E79);
  } else if (level < 16) {
    // gold
    return Color(0xffec9a00);
  } else if (level < 21) {
    // platinum
    return Color(0xff00c78b);
  } else if (level < 26) {
    // diamond
    return Color(0xff00b4fc);
  } else if (level < 31) {
    // ruby
    return Color(0xffff0062);
  } else {
    // master
    return Color(0xffb300e0);
  }
}

Color ratingColor(int rating) {
  if (rating < 30) {
    return Color(0xFF2D2D2D);
  } else if (rating < 200) {
    // bronze
    return Color(0xffad5600);
  } else if (rating < 800) {
    // silver
    return Color(0xFF425E79);
  } else if (rating < 1600) {
    // gold
    return Color(0xffec9a00);
  } else if (rating < 2200) {
    // platinum
    return Color(0xff00c78b);
  } else if (rating < 2700) {
    // diamond
    return Color(0xff00b4fc);
  } else if (rating < 3000) {
    // ruby
    return Color(0xffff0062);
  } else {
    // master
    return Color(0xffb300e0);
  }
}

int ratingToTier(int rating) {
  if (3000 <= rating) {
    return 31;
  } else if (2950 <= rating) {
    return 30;
  } else if (2900 <= rating) {
    return 29;
  } else if (2850 <= rating) {
    return 28;
  } else if (2800 <= rating) {
    return 27;
  } else if (2700 <= rating) {
    return 26;
  } else if (2600 <= rating) {
    return 25;
  } else if (2500 <= rating) {
    return 24;
  } else if (2400 <= rating) {
    return 23;
  } else if (2300 <= rating) {
    return 22;
  } else if (2200 <= rating) {
    return 21;
  } else if (2100 <= rating) {
    return 20;
  } else if (2000 <= rating) {
    return 19;
  } else if (1900 <= rating) {
    return 18;
  } else if (1750 <= rating) {
    return 17;
  } else if (1600 <= rating) {
    return 16;
  } else if (1400 <= rating) {
    return 15;
  } else if (1250 <= rating) {
    return 14;
  } else if (1100 <= rating) {
    return 13;
  } else if (950 <= rating) {
    return 12;
  } else if (800 <= rating) {
    return 11;
  } else if (650 <= rating) {
    return 10;
  } else if (500 <= rating) {
    return 9;
  } else if (400 <= rating) {
    return 8;
  } else if (300 <= rating) {
    return 7;
  } else if (200 <= rating) {
    return 6;
  } else if (150 <= rating) {
    return 5;
  } else if (120 <= rating) {
    return 4;
  } else if (90 <= rating) {
    return 3;
  } else if (60 <= rating) {
    return 2;
  } else if (30 <= rating) {
    return 1;
  } else {
    return 0;
  }
}
