//Muhammad Haikal Wijdan (1916771)
import 'dart:html';
import 'dart:convert';

void main() {
  print("Dart script loaded and running.");
  setMinDateForEvent();
  
  var form = querySelector('#scheduleEvent') as FormElement;

  form.onSubmit.listen((Event e) {
    e.preventDefault();

    var formData = {
      'personName': (querySelector('#personName') as InputElement).value ?? '',
      'eventName': (querySelector('#eventName') as InputElement).value ?? '',
      'eventVenue': (querySelector('#eventVenue') as SelectElement).value ?? '',
      'date': (querySelector('#date') as InputElement).value ?? '',
      'time': (querySelector('#time') as InputElement).value ?? ''
    };

    if (isVenueAvailable(formData['eventVenue']!, formData['date']!)) {
      saveEvent(formData);
      displayConfirmation(formData);
      Future.delayed(Duration(seconds: 3), () {
        window.location.assign('index.html');
      });
    } else {
      displayVenueBookedMessage(formData['eventVenue']!, formData['date']!);
    }
  });
}

bool isVenueAvailable(String venue, String date) {
  var storedEvents = window.localStorage['events'];
  if (storedEvents != null) {
    var events = (json.decode(storedEvents) as List<dynamic>)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();

    for (var event in events) {
      if (event['eventVenue'] == venue && event['date'] == date) {
        return false; // Venue is already booked on this date
      }
    }
  }
  return true; // Venue is available
}

void displayConfirmation(Map<String, String> formData) {
  var confirmationMessage = 'Event successfully booked for ${formData['personName']} for the event ${formData['eventName']} at the venue ${formData['eventVenue']} on ${formData['date']} at ${formData['time']}';
  querySelector('#bookingOutput')?.text = confirmationMessage; // Ensure you have an element with id 'bookingOutput'
}

void displayVenueBookedMessage(String venue, String date) {
  var message = 'The venue $venue is already booked on $date.';
  querySelector('#bookingOutput')?.text = message; // Ensure you have an element with id 'bookingOutput'
}

void saveEvent(Map<String, String> event) {
  var storedEvents = window.localStorage['events'];
  List<Map<String, String>> events = storedEvents != null ? (json.decode(storedEvents) as List).map((e) => Map<String, String>.from(e as Map)).toList() : [];
  events.add(event);
  window.localStorage['events'] = json.encode(events);
}

void setMinDateForEvent() {
  var dateInput = querySelector('#date') as InputElement;
  var today = DateTime.now();
  var dateString = "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
  dateInput.setAttribute('min', dateString);
}
