import 'package:efood_multivendor_restaurant/data/model/response/profile_model.dart';
import 'package:efood_multivendor_restaurant/theme/colors.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';

class OpenTimesView extends StatefulWidget {
  final Restaurant restaurant;
  const OpenTimesView({
    Key key,
    this.restaurant,
  }) : super(key: key);
  @override
  State<OpenTimesView> createState() => _OpenTimesViewState();
}

class _OpenTimesViewState extends State<OpenTimesView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double timeCellWidth = 48;
    print('=== selectedRestaurant.schedules: ${widget.restaurant.schedules}');
    List<WeekModel> openTimes = [];
    for (int i = 0; i < 7; i++) {
      WeekModel weekModel = WeekModel();
      weekModel.id = i;
      weekModel.bgColor = Colors.white;
      weekModel.textColor = Theme.of(context).disabledColor;
      if (i == 0) {
        weekModel.title = 'S';
        weekModel.bgColor = yellowDark;
        weekModel.textColor = Colors.white.withOpacity(0.7);
      } else if (i == 1) {
        weekModel.title = 'M';
      } else if (i == 2) {
        weekModel.title = 'T';
      } else if (i == 3) {
        weekModel.title = 'W';
      } else if (i == 4) {
        weekModel.title = 'T';
      } else if (i == 5) {
        weekModel.title = 'F';
      } else if (i == 6) {
        weekModel.title = 'S';
      }
      openTimes.add(weekModel);
    }
    if (widget.restaurant.schedules.isNotEmpty) {
      widget.restaurant.schedules.forEach((schedule) {
        int index =
            openTimes.indexWhere((openTime) => openTime.id == schedule.day);
        if (index != -1) {
          if (index == 0) {
            openTimes[index].textColor = Colors.white;
          } else {
            openTimes[index].textColor = yellowDark;
          }
          openTimes[index].openTime = schedule.openingTime;
          openTimes[index].closeTime = schedule.closingTime;
        }
      });
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: openTimes.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(
                  horizontal: 3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Container(
                  width: timeCellWidth,
                  height: timeCellWidth,
                  decoration: BoxDecoration(
                    color: openTimes[index].bgColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${openTimes[index].title}',
                      style: robotoMedium.copyWith(
                        color: openTimes[index].textColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${openTimes[index].openTime}',
                      style: robotoMedium.copyWith(
                        color: yellowLight,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      openTimes[index].openTime == '' ? '' : 'To',
                      style: robotoMedium.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${openTimes[index].closeTime}',
                      style: robotoMedium.copyWith(
                        color: greenDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class WeekModel {
  int id;
  String title;
  String openTime;
  String closeTime;
  Color bgColor;
  Color textColor;

  WeekModel({
    this.id,
    this.title,
    this.openTime = '',
    this.closeTime = '',
    this.bgColor,
    this.textColor,
  });
}
