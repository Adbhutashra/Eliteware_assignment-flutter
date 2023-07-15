// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class TimerStopwatchScreen extends StatefulWidget {
  const TimerStopwatchScreen({super.key});

  @override
  _TimerStopwatchScreenState createState() => _TimerStopwatchScreenState();
}

class _TimerStopwatchScreenState extends State<TimerStopwatchScreen> {
  bool isTimerMode = false;
  Duration timerDuration = const Duration(seconds: 0);
  Stopwatch stopwatch = Stopwatch();

  void toggleMode() {
    setState(() {
      isTimerMode = !isTimerMode;
    });
  }

  void startTimer() {
    setState(() {
      timerDuration = Duration(seconds: timerDuration.inSeconds - 1);
    });

    if (timerDuration.inSeconds <= 0) {
      // Timer reached 00:00:00
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Timer Finished'),
            content: const Text('The timer has reached 00:00:00.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      Future.delayed(const Duration(seconds: 1), startTimer);
    }
  }

  void resetStopwatch() {
    setState(() {
      stopwatch.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer & Stopwatch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isTimerMode ? 'Timer Mode' : 'Stopwatch Mode',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            isTimerMode
                ? Text(
                    '${timerDuration.inHours.toString().padLeft(2, '0')}:${(timerDuration.inMinutes % 60).toString().padLeft(2, '0')}:${(timerDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 48),
                  )
                : StreamBuilder(
                    stream: Stream.periodic(const Duration(milliseconds: 1000)),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      return Text(
                        '${(stopwatch.elapsed.inHours % 60).toString().padLeft(2, '0')}:${(stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 48),
                      );
                    },
                  ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: Text(isTimerMode ? 'Start Timer' : 'Start Stopwatch'),
              onPressed: () {
                if (isTimerMode) {
                  startTimer();
                } else {
                  stopwatch.start();
                  setState(() {});
                }
              },
            ),
            isTimerMode
                ? const SizedBox()
                : ElevatedButton(
                    child: const Text('Reset Stopwatch'),
                    onPressed: () {
                      stopwatch.stop();
                      stopwatch.reset();
                      setState(() {});
                    },
                  ),
            const SizedBox(height: 16),
            isTimerMode
                ? ElevatedButton(
                    child: const Text('Set Timer'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          int hours = 0;
                          int minutes = 0;
                          int seconds = 0;

                          return AlertDialog(
                            title: const Text('Set Timer'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text('Hours'),
                                NumberPicker(
                                  minValue: 0,
                                  maxValue: 23,
                                  onChanged: (value) => hours = value,
                                ),
                                const SizedBox(height: 8),
                                const Text('Minutes'),
                                NumberPicker(
                                  minValue: 0,
                                  maxValue: 59,
                                  onChanged: (value) => minutes = value,
                                ),
                                const SizedBox(height: 8),
                                const Text('Seconds'),
                                NumberPicker(
                                  minValue: 0,
                                  maxValue: 59,
                                  onChanged: (value) => seconds = value,
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Set'),
                                onPressed: () {
                                  setState(() {
                                    timerDuration = Duration(
                                      hours: hours,
                                      minutes: minutes,
                                      seconds: seconds,
                                    );
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                : const SizedBox(),
            ElevatedButton(
              onPressed: toggleMode,
              child:
                  Text(isTimerMode ? 'Switch to Stopwatch' : 'Switch to Timer'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class NumberPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const NumberPicker(
      {super.key, this.minValue = 0, this.maxValue = 59, required this.onChanged});

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (_value > widget.minValue) {
              setState(() {
                _value--;
                widget.onChanged(_value);
              });
            }
          },
        ),
        const SizedBox(width: 8),
        Text(
          _value.toString(),
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            if (_value < widget.maxValue) {
              setState(() {
                _value++;
                widget.onChanged(_value);
              });
            }
          },
        ),
      ],
    );
  }
}
