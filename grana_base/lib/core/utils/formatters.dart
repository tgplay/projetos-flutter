import 'package:intl/intl.dart';

final _brl = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$ ', decimalDigits: 2);

String formatCurrency(double value) => _brl.format(value);
