import 'dart:async';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pastillero/api/notification_api.dart';
import 'package:pastillero/db/alarm_helper.dart';
import 'package:pastillero/presentation/pages/my_home/my_home.dart';
import 'package:pastillero/presentation/themes/theme_data.dart';
import 'models/alarm_info.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  final titulo = TextEditingController();
  final dias = TextEditingController();
  final horas = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();
  final formkey3 = GlobalKey<FormState>();
  DateTime? _alarmTime;
  String? _alarmTimeString;
  final AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
    });
    NotificationApi.init(initScheduled: true);
    listenNotifications();
    NotificationApi.init(initScheduled: true);
    super.initState();
  }

  void listenNotifications() =>
      NotificationApi.onNotification.stream.listen((onClickedNotification));
  void onClickedNotification(String payload) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const MyHome()));

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    late String formattedTime;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: Colors.blueGrey.shade900,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Pastillero",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'avenir',
              fontSize: 24,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: FutureBuilder<List<AlarmInfo>>(
                  future: _alarms,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _currentAlarms = snapshot.data;
                      return ListView(
                        children: snapshot.data!.map<Widget>((alarm) {
                          var alarmTime = DateFormat('hh:mm aa')
                              .format(alarm.alarmDateTime!);
                          var gradientColor = GradientTemplate
                              .gradientTemplate[alarm.gradientColorIndex!]
                              .colors;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 32),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColor,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: gradientColor.last.withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  offset: const Offset(4, 4),
                                ),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        const Icon(
                                          Icons.label,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          alarm.title!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'avenir'),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.heartbeat,
                                      size: 30,
                                      color: Colors.redAccent,
                                    ),
                                  ],
                                ),
                                Text(
                                  'Mg del medicamento: ' +
                                      alarm.dias.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'avenir'),
                                ),
                                Text(
                                  'Dosis del tratamiento: ' +
                                      alarm.horas.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'avenir'),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      alarmTime,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'avenir',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.white,
                                        onPressed: () {
                                          deleteAlarm(alarm.id!);
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).followedBy([
                          if (_currentAlarms!.length < 5)
                            DottedBorder(
                              strokeWidth: 2,
                              color: CustomColors.clockOutline,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(24),
                              dashPattern: const [5, 4],
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: CustomColors.clockBG,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24)),
                                ),
                                child: FlatButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  onPressed: () {
                                    _alarmTimeString = DateFormat('HH:mm')
                                        .format(DateTime.now());
                                    showModalBottomSheet(
                                      useRootNavigator: true,
                                      context: context,
                                      clipBehavior: Clip.antiAlias,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(24),
                                        ),
                                      ),
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setModalState) {
                                            return ListView(
                                              children: [
                                                SingleChildScrollView(
                                                  child: Container(
                                                    height: 800,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            32),
                                                    child: Column(
                                                      children: <Widget>[
                                                        TextButton(
                                                          onPressed: () async {
                                                            var selectedTime =
                                                                await showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  TimeOfDay
                                                                      .now(),
                                                            );
                                                            if (selectedTime !=
                                                                null) {
                                                              final now =
                                                                  DateTime
                                                                      .now();
                                                              var selectedDateTime =
                                                                  DateTime(
                                                                      now.year,
                                                                      now.month,
                                                                      now.day,
                                                                      selectedTime
                                                                          .hour,
                                                                      selectedTime
                                                                          .minute);

                                                              formattedTime =
                                                                  DateFormat
                                                                          .Hm()
                                                                      .format(
                                                                          selectedDateTime);
                                                              print(
                                                                  formattedTime);
                                                              _alarmTime =
                                                                  selectedDateTime;
                                                              setModalState(() {
                                                                _alarmTimeString =
                                                                    DateFormat(
                                                                            'HH:mm')
                                                                        .format(
                                                                            selectedDateTime);
                                                              });
                                                            }
                                                          },
                                                          child: Text(
                                                            _alarmTimeString!,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        32),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        ListTile(
                                                          title: const Text(
                                                              '¿De cuantos Mg es el medicamento?'),
                                                          trailing: IconButton(
                                                              onPressed: () {
                                                                if (formkey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  final snackBar =
                                                                      SnackBar(
                                                                    content: Text(
                                                                        "Mg del medicamento: " +
                                                                            dias.text),
                                                                  );
                                                                  _scaffoldKey
                                                                      .currentState!
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                }
                                                              },
                                                              icon: const Icon(Icons
                                                                  .arrow_forward_ios)),
                                                          subtitle: Column(
                                                            children: <Widget>[
                                                              Form(
                                                                key: formkey,
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      dias,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Ejemplo: 500',
                                                                    labelText:
                                                                        'Ingresa los Mg del medicamento',
                                                                  ),
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                            .isEmpty ||
                                                                        !RegExp(r'^\d+$')
                                                                            .hasMatch(value)) {
                                                                      return "Ingresa un Mg valido, recuerda no usa letras";
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        ListTile(
                                                          title: const Text(
                                                              '¿Cuantas dosis dura el tratamiento?'),
                                                          trailing: IconButton(
                                                              onPressed: () {
                                                                if (formkey3
                                                                    .currentState!
                                                                    .validate()) {
                                                                  final snackBar =
                                                                      SnackBar(
                                                                    content: Text(
                                                                        "Numero de dosis: " +
                                                                            dias.text),
                                                                  );
                                                                  _scaffoldKey
                                                                      .currentState!
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                }
                                                              },
                                                              icon: const Icon(Icons
                                                                  .arrow_forward_ios)),
                                                          subtitle: Column(
                                                            children: <Widget>[
                                                              Form(
                                                                key: formkey3,
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      horas,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Ejemplo: 4',
                                                                    labelText:
                                                                        'Ingresa una dosis',
                                                                  ),
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                            .isEmpty ||
                                                                        !RegExp(r'^\d+$')
                                                                            .hasMatch(value)) {
                                                                      return "Ingresa una dosis adecuada";
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        ListTile(
                                                          title: const Text(
                                                              'Nombre del medicamento'),
                                                          trailing: IconButton(
                                                              onPressed: () {
                                                                if (formkey2
                                                                    .currentState!
                                                                    .validate()) {
                                                                  final snackBar =
                                                                      SnackBar(
                                                                    content: Text(
                                                                        "Medicamento a tomar: " +
                                                                            dias.text),
                                                                  );
                                                                  _scaffoldKey
                                                                      .currentState!
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                }
                                                              },
                                                              icon: const Icon(Icons
                                                                  .arrow_forward_ios)),
                                                          subtitle: Column(
                                                            children: <Widget>[
                                                              Form(
                                                                key: formkey2,
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      titulo,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Ejemplo: Paracetamol',
                                                                    labelText:
                                                                        'Ingresa el nombre del medicamento',
                                                                  ),
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                            .isEmpty ||
                                                                        !RegExp(r'^[a-zA-Z]+$')
                                                                            .hasMatch(value)) {
                                                                      return "Ingresa un medicamento valido";
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        FloatingActionButton
                                                            .extended(
                                                          onPressed: () {
                                                            onSaveAlarm(
                                                                formattedTime);
                                                          },
                                                          icon: const Icon(
                                                              Icons.alarm),
                                                          label: const Text(
                                                              'Guardar'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/add_alarm.png',
                                        scale: 1.5,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Añadir medicamento',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'avenir'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          else
                            const Center(
                                child: Text(
                              'Solo se recomiendan 5 tratamientos por persona!',
                              style: TextStyle(color: Colors.white),
                            )),
                        ]).toList(),
                      );
                    }
                    return const Center(
                      child: Text(
                        'Cargando..',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  void scheduleAlarm(DateTime scheduledNotificationDateTime,
      AlarmInfo alarmInfo, String horas, String minutos) async {
    var bodyy = "Toma tu medicamento " +
        alarmInfo.title.toString() +
        " de una dosis de " +
        alarmInfo.horas.toString();
    NotificationApi.scheduleDaily9AMNotification(
        body: bodyy,
        hora: int.parse(horas),
        title: titulo.text,
        minuto: int.parse(minutos));
  }

  onSaveAlarm(String formattedTime) {
    print(int.parse(dias.text));
    print("horas: " + int.parse(horas.text).toString());
    DateTime scheduleAlarmDateTime;
    var days = int.parse(dias.text);
    var hours = int.parse(horas.text);
    if (_alarmTime!.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = _alarmTime!;
    } else {
      scheduleAlarmDateTime = _alarmTime!.add(const Duration(days: 1));
    }

    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarms!.length,
      title: titulo.text,
      dias: days,
      horas: hours,
    );
    var parts = formattedTime.split(':');
    var horaas = parts[0].trim();
    var min = parts.sublist(1).join(':').trim();
    _alarmHelper.insertAlarm(alarmInfo);
    scheduleAlarm(scheduleAlarmDateTime, alarmInfo, horaas, min);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyHome()));
    loadAlarms();
  }

  void deleteAlarm(int id) {
    _alarmHelper.delete(id);
    NotificationApi().cancelNotification(id);
    //unsubscribe for notification
    loadAlarms();
  }
}
