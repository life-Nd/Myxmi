// import 'package:flutter/cupertino.dart';

// class Shift extends ChangeNotifier {
//   Map name;
//   String uid;
//   String shiftStart;
//   String userType;
//   String shiftEnd;
//   Map<String, dynamic> dailyShiftData;
//   List allShiftsData;
//   Shift({
//     this.name,
//     this.uid,
//     this.userType,
//     this.shiftStart,
//     this.shiftEnd,
//   },);
//   Map<String, dynamic> toMap() {
//     dailyShiftData = <String, dynamic>{
//       'uid': uid,
//       'name': name,
//       'type': userType,
//       'start': shiftStart,
//       'end': shiftEnd,
//     };
//     notifyListeners();
//     return dailyShiftData;
//   }

//   fromMap({Map<String, dynamic> map}) {
//     uid = map["UserUid"] as String;
//     userType = map["UserType"] as String;
//     shiftStart = map["PrefStart"] as String;
//     shiftEnd = map["PrefEnd"] as String;
//     name = map["Name"] as Map;
//   }
// }

// class PeriodProvider extends ChangeNotifier {
//   Map dailyData = {};
//   // DatePeriod selected = DatePeriod(
//   //   DateTime.now().add(Duration(hours: 20)),
//   //   DateTime.now().add(Duration(days: 6)),
//   // );

//   // void changeSelected({DateTimeRange newSelected}) {
//   //   selected = DateTimeRange(
//   //       newSelected.start.add(
//   //         Duration(
//   //           hours: 2,
//   //         ),
//   //       ),
//   //       newSelected.end);
//   //   notifyListeners();
//   // }

//   void addShift({Map newShift, String dayMonthYear}) {
//     List _userDailyShifts = [];
//     dailyData.update(dayMonthYear, (value) {
//       print("value: $value");
//       value.add(newShift);
//       return value;
//     }, ifAbsent: () {
//       List _newList = [];
//       _newList.add(newShift);
//       print("Absent: $_userDailyShifts");
//       return _newList;
//     },);
//   }
// }
