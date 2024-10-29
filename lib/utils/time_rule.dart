import 'package:intl/intl.dart';

class TimeRues {}

extension TimeSetRule on TimeRues {
  String convetDateTime(String utc) {
    final dateUS = DateTime.parse(utc).toLocal();
    var date = DateFormat.yMMMMd().format(dateUS);
    print("date..time.. "+date.toString());
    return date;
  }

  String timeConvet(String utc) {
    final dateUS = DateTime.parse(utc).toLocal();
    var date = DateFormat("hh:mm:a").format(dateUS);
    return date;
  }

  String margedDateTime(String utc) {
    final dateUS = DateTime.parse(utc).toLocal();
    var date = DateFormat.yMMMMd().format(dateUS);
    var time = DateFormat("hh:mm:a").format(dateUS);
    return "$date, $time";
  }
}
