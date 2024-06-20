import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:intl/intl.dart';

class DateSelection extends StatelessWidget {
  const DateSelection({super.key, this.pageController});

  final PageController? pageController;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 40,
        child: PageView.builder(
          controller: pageController,
          onPageChanged: updateCurrentDate,
          itemBuilder: (context, index) {
            DateTime adjustedDate = calculateDate(index);
            String monthName = DateFormat.MMMM('pt_BR').format(adjustedDate);
            monthName =
                '${monthName[0].toUpperCase()}${monthName.substring(1)} de ${adjustedDate.year}';
            // Month and year swipe setup
            return Center(
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    pageController?.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  } else if (details.delta.dx < 0) {
                    pageController?.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
                child: Text(
                  monthName,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        ),
      )
    ]);
  }
}
