import 'dart:async';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

Firestore fsi = Firestore.instance;

final intlNumber = new NumberFormat.decimalPattern("ja");
final StreamController<String> quantityStream =
    new StreamController.broadcast();
