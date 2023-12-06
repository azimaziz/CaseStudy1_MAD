import 'dart:html';
import 'dart:convert';

//Azim Aziz 2014781
void main() {
  var form1 = querySelector('#availabilityForm') as FormElement;
  form1.onSubmit.listen((Event e) {
    e.preventDefault();

    var selectedVenue = (querySelector('#venue') as SelectElement).value ?? '';
    var selectedDate = (querySelector('#date') as InputElement).value ?? '';

    clearTable();//clear table each submission
    checkAvailability(selectedVenue, selectedDate);
  });
}

//Taken from main.dart (haikal's)
void checkAvailability(String venue, String date) {
  var storedEvents = window.localStorage['events'];
  bool isAvailable = true;

  if (storedEvents != null) {
    var events = (json.decode(storedEvents) as List<dynamic>)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();

    for (var event in events) {
      if (event['eventVenue'] == venue && event['date'] == date) {
        isAvailable = false;
        break;
      }
    }
  }

  // Display the availability text
  var outputElement = querySelector('#availabilityOutput') as DivElement;
  if (isAvailable) {
    outputElement.text = 'The venue $venue is available on $date.';
  } else {
    outputElement.text = 'The venue $venue is booked on $date.';
    loadEvents(venue, date); // display suggestion table
  }
}

//clear table each submission
void clearTable() {
  var table = querySelector('.centered-table') as TableElement;
  var rows = table.rows;
  for (var i = rows.length - 1; i >= 1; i--) {
    rows[i].remove();
  }

  var outputElement = querySelector('#suggestText') as DivElement;
  outputElement.text = '';
}

//calculate the 3 days before & after selected date
void loadEvents(venue, date) {
  var outputElement = querySelector('#suggestText') as DivElement;
  outputElement.text = 'These are the schedule for venue $venue 3 days before & after $date.';

  for (int i = 3; i >= 1; i--) {
    var previousDate = DateTime.parse(date).subtract(Duration(days: i)).toString();
    buildTable(venue, previousDate);
  }//3 days before

  for (int i = 1; i <= 3; i++) {
    var nextDate = DateTime.parse(date).add(Duration(days: i)).toString();
    buildTable(venue, nextDate);
  }
}//3 days after

//create suggestion table 3 day before & after selected date
void buildTable(venue, newDate) {
  var storedEvents = window.localStorage['events'];
  var table = querySelector('.centered-table') as TableElement;
  bool isAvailable = false;

  if (storedEvents != null) {
    var events = (json.decode(storedEvents) as List<dynamic>)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();

    for (var event in events) {
      print(event['date']);
      print(newDate);

      if (event['eventVenue'] == venue) {
        if (DateTime.parse(event['date']!) == DateTime.parse(newDate)) {
          var row = table.addRow();
          row.addCell().text = event['personName'] ?? '';
          row.addCell().text = event['eventName'] ?? '';
          row.addCell().text = event['eventVenue'] ?? '';
          row.addCell().text = event['date'] ?? '';
          row.addCell().text = event['time'] ?? '';
          isAvailable = true;
        } else {}
      } else {}
    }
    if (isAvailable == false) {
      var row = table.addRow();
      row.addCell().text = '  -  ';
      row.addCell().text = 'Date Available';
      row.addCell().text = venue ?? '';
      row.addCell().text = abbrevBad(newDate);
      row.addCell().text = '  -  ';
    } else {}
  }
}

String abbrevBad(String input) {
  if (input.length <= 10) return input;
  return input.substring(0, 10);
}
