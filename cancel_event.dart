//Afnan Iman bin Azman (1920311)
import 'dart:html';
import 'dart:convert';

void main() {
  var form = querySelector('#cancelEventForm') as FormElement;
  form.onSubmit.listen((Event e) {
    e.preventDefault();

    var personName = (querySelector('#personName') as InputElement).value ?? '';
    var date = (querySelector('#date') as InputElement).value ?? '';

    cancelEvent(personName, date);
  });
}

void cancelEvent(String personName, String date) {
  var storedEvents = window.localStorage['events'];
  if (storedEvents != null) {
    var events = (json.decode(storedEvents) as List<dynamic>)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();

    // Remove the event that matches the person name and event name
    events.removeWhere(
        (event) => event['personName'] == personName && event['date'] == date);

    // Update the local storage with the modified list of events
    window.localStorage['events'] = json.encode(events);

    // Optionally, redirect to index.html or show a confirmation message
    window.location.assign('index.html');
  }
}
