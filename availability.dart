import 'dart:html';
import 'dart:convert';

void main() {
  var form = querySelector('#availabilityForm') as FormElement;
  form.onSubmit.listen((Event e) {
    e.preventDefault();

    var selectedVenue = (querySelector('#venue') as SelectElement).value ?? '';
    var selectedDate = (querySelector('#date') as InputElement).value ?? '';

    checkAvailability(selectedVenue, selectedDate);
  });
}

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

  // Display the availability status
  var outputElement = querySelector('#availabilityOutput') as DivElement;
  if (isAvailable) {
    outputElement.text = 'The venue $venue is available on $date.';
  } else {
    outputElement.text = 'The venue $venue is booked on $date.';
  }
}
