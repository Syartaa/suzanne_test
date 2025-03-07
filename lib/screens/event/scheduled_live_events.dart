import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/screens/event/widget/event_details_page.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:suzanne_podcast_app/provider/events_provider.dart';

class ScheduledLiveEvents extends ConsumerStatefulWidget {
  const ScheduledLiveEvents({super.key});

  @override
  _ScheduledLiveEventsState createState() => _ScheduledLiveEventsState();
}

class _ScheduledLiveEventsState extends ConsumerState<ScheduledLiveEvents> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _eventDates = {};

  @override
  Widget build(BuildContext context) {
    final eventsAsyncValue = ref.watch(eventNotifierProvider);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        title: Center(
          child: Text(
            loc.scheduled_events,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Color(0xFFFFF8F0),
              shadows: [
                Shadow(
                  color: Color(0xFFFFF1F1),
                  offset: Offset(1.0, 1.0),
                  blurRadius: 3.0,
                ),
              ],
            ),
          ),
        ),
      ),
      body: eventsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (events) {
          _eventDates =
              events.map((event) => DateTime.parse(event.eventDate)).toSet();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: DateTime.utc(2025, 1, 1),
                      lastDay: DateTime.utc(2030, 1, 1),
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        outsideDaysVisible: false,
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          if (_eventDates
                              .any((eventDate) => isSameDay(eventDate, day))) {
                            return Container(
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.secondaryColor, width: 2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${day.day}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  if (_selectedDay == null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        loc.choose_events,
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (_selectedDay != null)
                    Builder(
                      builder: (context) {
                        final filteredEvents = events.where((event) {
                          final eventDate = DateTime.parse(event.eventDate);
                          return isSameDay(eventDate, _selectedDay);
                        }).toList();

                        if (filteredEvents.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              loc.no_events,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            return Column(
                              children: [
                                Card(
                                  color: const Color.fromARGB(234, 218, 29, 29),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    leading: Image.network(event.image),
                                    title: Text(event.title,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                    subtitle: Text(
                                      event.description,
                                      style: TextStyle(color: Colors.white70),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => EventDetailsPage(
                                                  event: event)));
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
