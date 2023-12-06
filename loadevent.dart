//Afnan Iman bin Azman (1920311)
import 'dart:html';
import 'dart:convert';

void main() {
  loadEvents();
}

void loadEvents() {
  var storedEvents = window.localStorage['events'];
  var table = querySelector('.centered-table') as TableElement;

  if (storedEvents != null) {
    var events = json.decode(storedEvents) as List;
    List<Map<String, String>> parsedEvents =
        events.map((e) => Map<String, String>.from(e as Map)).toList();

    // Sort the events based on the date
    parsedEvents.sort((a, b) =>
        DateTime.parse(a['date']!).compareTo(DateTime.parse(b['date']!)));

    for (var event in parsedEvents) {
      var row = table.addRow();
      row.addCell().text = event['personName'] ?? '';
      row.addCell().text = event['eventName'] ?? '';
      row.addCell().text = event['eventVenue'] ?? '';
      row.addCell().text = event['date'] ?? '';
      row.addCell().text = event['time'] ?? '';
    }
  }
}
