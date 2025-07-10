// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final DateTime currentDate;
  final Function(DateTime) onTap;
  const DateSelector({
    super.key,
    required this.currentDate,
    required this.onTap,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int weekOffset = 0;

  @override
  Widget build(BuildContext context) {
    final weekDates = generateWeekDates(weekOffset);
    final monthName = DateFormat('MMMM').format(weekDates.first);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    weekOffset--;
                  });
                },
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              Text(
                monthName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    weekOffset++;
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
        _buildDatePicker(context, weekDates),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, List<DateTime> weekDates) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          itemCount: weekDates.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final date = weekDates[index];
            final selecedDate = DateFormat('d').format(widget.currentDate) ==
                    DateFormat('d').format(date) &&
                widget.currentDate.month == date.month &&
                widget.currentDate.year == date.year;
            return GestureDetector(
              onTap: () => widget.onTap(date),
              child: Container(
                width: 70,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: selecedDate ? Colors.deepOrangeAccent : null,
                  borderRadius: BorderRadius.circular(12),
                  border: !selecedDate
                      ? Border.all(
                          color: Colors.black45,
                          width: 0.6,
                        )
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('d').format(date),
                      style: TextStyle(
                        color: selecedDate ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat('E').format(date),
                      style: TextStyle(
                        color: selecedDate ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
