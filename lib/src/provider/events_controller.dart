import 'dart:collection';

import 'package:chem_organizer/src/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsController {
  CollectionReference users = FirebaseFirestore.instance.collection('usuarios');

  getDate(Timestamp time) {
    DateTime fecha = time.toDate();
    String formattedDate = DateFormat.yMd().add_jm().format(fecha);
    return formattedDate;
    //return "Fecha:${fecha.year}-${fecha.month}-${fecha.day}  Hora: ${fecha.hour}: ${fecha.minute}";
  }

  getDateFromDateTime(DateTime date) {
    String formattedDate = DateFormat.yMd().add_jm().format(date);
    return formattedDate;
  }

  Future<void> deleteEvent(String id, String username) {
    return users
        .doc(username)
        .collection('eventos')
        .doc(id)
        .delete()
        .then((value) => print("Event Deleted"))
        .catchError((error) => print("Failed to delete event: $error"));
  }

  DateTime getJustDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<LinkedHashMap<DateTime, List<dynamic>>> getEvents(
      String username) async {
    Map<DateTime, List<dynamic>> auxEvents = Map();
    Timestamp t;
    DateTime date;
    await users
        .doc(username)
        .collection('eventos')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        t = doc['fecha'];
        date = t.toDate();
        if (auxEvents.containsKey(getJustDate(date))) {
          auxEvents[getJustDate(date)]!.add(Event(doc.id, doc['nombre'], date,
              doc['categoria'], doc['id'], doc['tiempoNotificacion']));
        } else {
          auxEvents[getJustDate(date)] = [
            Event(doc.id, doc['nombre'], date, doc['categoria'], doc['id'],
                doc['tiempoNotificacion'])
          ];
        }
      });
    });

    final kEvents = LinkedHashMap<DateTime, List<dynamic>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(auxEvents);

    return kEvents;
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
}
