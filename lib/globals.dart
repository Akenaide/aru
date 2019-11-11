import 'dart:async';
import 'package:intl/intl.dart';

final intlNumber = new NumberFormat.decimalPattern("ja");
final StreamController<String> quantityStream =
    new StreamController.broadcast();
