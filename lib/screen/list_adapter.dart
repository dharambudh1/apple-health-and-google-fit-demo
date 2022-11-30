import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:health_demo/screen/health_screen.dart';

class ListAdapter extends StatelessWidget {
  final List<HealthDataType> list;
  final int indexOfLoop;
  final HealthDataPoint healthDataPoint;

  const ListAdapter({
    Key? key,
    required this.list,
    required this.indexOfLoop,
    required this.healthDataPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (list[indexOfLoop].name == healthDataPoint.typeString) {
      if (healthDataPoint.value is AudiogramHealthValue) {
        return audioGramWidget();
      } else if (healthDataPoint.value is WorkoutHealthValue) {
        return workoutWidget();
      } else {
        return elseWidget();
      }
    } else {
      return Container();
    }
  }

  Widget audioGramWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            richText(
              title: 'Type: ',
              body: healthDataPoint.typeString.capitalize(),
            ),
            richText(
              title: 'Unit: ',
              body: healthDataPoint.unitString.capitalize(),
            ),
            richText(
              title: 'Value: ',
              body: healthDataPoint.value.toString(),
            ),
            richText(
              title: 'From: ',
              body: healthDataPoint.dateFrom.toString(),
            ),
            richText(
              title: 'To: ',
              body: healthDataPoint.dateTo.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget workoutWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            richText(
              title: 'Workout activity type: ',
              body: (healthDataPoint.value as WorkoutHealthValue)
                  .workoutActivityType
                  .typeToString()
                  .capitalize(),
            ),
            richText(
              title: 'Total energy burned: ',
              body: (healthDataPoint.value as WorkoutHealthValue)
                  .totalEnergyBurned
                  .toString(),
            ),
            richText(
              title: 'Total energy burned unit: ',
              body: (healthDataPoint.value as WorkoutHealthValue)
                      .totalEnergyBurnedUnit
                      ?.typeToString()
                      .capitalize() ??
                  '',
            ),
            richText(
              title: 'Type: ',
              body: healthDataPoint.typeString.capitalize(),
            ),
            richText(
              title: 'Unit: ',
              body: healthDataPoint.unitString.capitalize(),
            ),
            richText(
              title: 'Value: ',
              body: healthDataPoint.value.toString(),
            ),
            richText(
              title: 'From: ',
              body: healthDataPoint.dateFrom.toString(),
            ),
            richText(
              title: 'To: ',
              body: healthDataPoint.dateTo.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget elseWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            richText(
              title: 'Type: ',
              body: healthDataPoint.typeString.capitalize(),
            ),
            richText(
              title: 'Unit: ',
              body: healthDataPoint.unitString.capitalize(),
            ),
            richText(
              title: 'Value: ',
              body: healthDataPoint.value.toString(),
            ),
            richText(
              title: 'From: ',
              body: healthDataPoint.dateFrom.toString(),
            ),
            richText(
              title: 'To: ',
              body: healthDataPoint.dateTo.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget richText({
    required String title,
    required String body,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: title,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            TextSpan(
              text: body,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
