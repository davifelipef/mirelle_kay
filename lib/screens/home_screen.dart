import 'package:mirelle_kay/widgets/app_bar.dart';
import 'package:mirelle_kay/widgets/balance_card.dart';
import 'package:mirelle_kay/widgets/date_selection.dart';
import 'package:mirelle_kay/providers/filtered_events.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirelle_kay/widgets/drawer.dart';
import 'package:mirelle_kay/widgets/add_event_button.dart';
import 'package:mirelle_kay/widgets/events_list.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FilteredEventsProvider filteredEventsProvider;

  @override
  void initState() {
    super.initState();
    updatePageTitle("Fluxo de caixa");
    filteredEventsProvider =
        Provider.of<FilteredEventsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadEventsFromHive(filteredEventsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredEventsProvider = Provider.of<FilteredEventsProvider>(context);
    return Scaffold(
      appBar: const AppBarDesign(),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 10.0),
            child: DateSelection(pageController: calcPageController()),
          ),
          const BalanceCard(),
          const Divider(),
          EventsList(events: filteredEventsProvider.filteredData),
        ],
      ),
      floatingActionButton: AddEventButton(
        filteredEventsProvider: filteredEventsProvider,
      ),
    );
  }
}
