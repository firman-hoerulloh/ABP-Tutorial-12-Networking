import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Constants.dart';

void main() {
  runApp(const TutorialPage_12());
}

class TutorialPage_12 extends StatelessWidget {
  const TutorialPage_12({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ABP Minggu 12',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const EventsPage(title: "ABP Minggu 12"),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EventsPage extends StatefulWidget {
  const EventsPage({super.key, required this.title});
  final String title;

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  var events = [];

  Future<void> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/event/events'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['message'] == 'success') {
          setState(() {
            events = jsonData['events'];
          });
        } else {
          if (kDebugMode) {
            print('Error fetching events: Unexpected response format');
          }
        }
      } else {
        if (kDebugMode) {
          print('Error fetching events: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching events: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: events.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(event['image']),
                        ),
                      ),
                    ),
                    title: Text(event['name']),
                    subtitle: Row(
                      children: [
                        Text('Rp. ${event['price'].toString()}'),
                        const SizedBox(width: 10),
                        Text('Tickets: ${event['ticketleft'].toString()}'),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
