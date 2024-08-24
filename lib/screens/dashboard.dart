import 'package:attendo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime currentMonth = DateTime.now();
  @override
  Widget build(BuildContext context) {
    int present = 0, absent = 0;
    final attendance =
        Provider.of<UserProvider>(context, listen: false).getAttendaceRecords();
    final today = DateTime.now();
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final firstDayOfWeek = firstDayOfMonth.weekday;
    List<List<int?>> weeks = [];
    List<int?> week = List.generate(7, (index) => null);

    void setAttendance() {
      if (DateTime.now().weekday == DateTime.friday) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Notice',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                'Today is vacation!',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        bool exist = Provider.of<UserProvider>(context, listen: false)
            .attendanceExist(DateTime.now());
        if (exist) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Notice',
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  'You already marked attendace today, want to cancel it?',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        Provider.of<UserProvider>(context, listen: false)
                            .removeAttendace(DateTime.now());
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          setState(() {
            Provider.of<UserProvider>(context, listen: false)
                .addAttendance(DateTime.now());
          });
        }
      }
    }

    void updateCounts() {
      final endOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
      final today = DateTime.now();

      final filteredAttendance = attendance.where((date) {
        return date.year == currentMonth.year &&
            date.month == currentMonth.month &&
            date.weekday != 5 &&
            date.isBefore(today);
      }).toList();
      present = filteredAttendance.length;

      final totalDaysInMonth = endOfMonth.day;
      final daysInMonth = List.generate(totalDaysInMonth, (index) => index + 1);
      final totalDaysExcludingFridays = daysInMonth.where((day) {
        final date = DateTime(currentMonth.year, currentMonth.month, day);
        return date.weekday != 6 && date.isBefore(today);
      }).length;

      absent = totalDaysExcludingFridays - present;

      setState(() {});
    }

    void previousMonth() {
      setState(() {
        currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
      });
    }

    void nextMonth() {
      setState(() {
        currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      });
    }

    Widget buildWeekDays() {
      final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return Row(
        children: weekDays
            .map((day) => Expanded(
                  child: Center(
                      child: Text(day,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 162, 162, 162)))),
                ))
            .toList(),
      );
    }

    bool beforeToday(DateTime date, int? day) {
      final today = DateTime.now();
      if (date.year <= today.year && date.month <= today.month) {
        if (date.month == today.month) {
          return day! <= today.day;
        } else {
          return true;
        }
      }
      return false;
    }

    Widget buildDays(
      List<List<int?>> weeks,
      DateTime today,
      List<DateTime> attendance,
    ) {
      return Column(
        children: weeks.asMap().entries.map((entry) {
          int index = entry.key;
          List<int?> week = entry.value;

          return Column(
            children: [
              Row(
                children: week.map((day) {
                  bool isToday = day != null &&
                      today.day == day &&
                      currentMonth.month == today.month &&
                      currentMonth.year == today.year;
                  bool isFriday = day != null &&
                      DateTime(currentMonth.year, currentMonth.month, day)
                              .weekday ==
                          5;
                  Color backgroundColor =
                      isToday ? const Color(0xFF5f4bce) : Colors.transparent;
                  Color dotColor = (day != null &&
                          beforeToday(currentMonth, day) &&
                          !isFriday)
                      ? attendance.any((date) =>
                              currentMonth.year == date.year &&
                              currentMonth.month == date.month &&
                              day == date.day)
                          ? Colors.green
                          : Colors.red
                      : Colors.transparent;

                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            shape: BoxShape.circle,
                          ),
                          width: 30,
                          height: 30,
                          child: Center(
                            child: day != null
                                ? Text(
                                    day.toString(),
                                    style: TextStyle(
                                      color: isFriday
                                          ? const Color.fromARGB(
                                              255, 167, 167, 167)
                                          : isToday
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: isToday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (day != null)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              if (index < weeks.length - 1) const SizedBox(height: 10),
            ],
          );
        }).toList(),
      );
    }

    for (int i = firstDayOfWeek - 1; i >= 0; i--) {
      week[i] = null;
    }
    for (int i = 1; i <= 7 - firstDayOfWeek + 1; i++) {
      week[firstDayOfWeek - 1 + i - 1] = i;
    }
    weeks.add(week);
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      final dayOfWeek =
          DateTime(currentMonth.year, currentMonth.month, i).weekday - 1;
      if (dayOfWeek == 0 && i != 1) {
        week = List.generate(7, (index) => null);
        weeks.add(week);
      }
      week[dayOfWeek] = i;
    }

    updateCounts();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 22,
                          ),
                          onPressed: previousMonth,
                        ),
                        Text(
                          DateFormat('MMMM yyyy').format(currentMonth),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color:
                                      const Color.fromARGB(255, 127, 127, 127),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 22,
                          ),
                          onPressed: nextMonth,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    buildWeekDays(),
                    const SizedBox(height: 10),
                    buildDays(weeks, today, attendance),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  shadowColor: const Color.fromARGB(190, 0, 0, 0),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 1),
                  ),
                ),
                onPressed: () {
                  setAttendance();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check),
                    SizedBox(
                      width: 16,
                    ),
                    Text("Mark Attendance")
                  ],
                )),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 230,
                  width: MediaQuery.of(context).size.width / 2.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      const Color(0xFFCB250F),
                      const Color(0xFFCB250F).withOpacity(0.6)
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromARGB(152, 0, 0, 0).withOpacity(0.3),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 80),
                        child: Text(
                          "Total Absent",
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(absent.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                      fontSize: 90,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 230,
                  width: MediaQuery.of(context).size.width / 2.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.6)
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromARGB(152, 0, 0, 0).withOpacity(0.3),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 80),
                        child: Text(
                          "Total Present",
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(present.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                      fontSize: 90,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
