import 'package:mirelle_kay/widgets/app_bar.dart';
import 'package:mirelle_kay/widgets/balance_card.dart';
import 'package:mirelle_kay/widgets/date_selection.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:flutter/material.dart';
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
  List<dynamic> _filteredData = [];
  @override
  void initState() {
    super.initState();
    updatePageTitle("Fluxo de caixa");
    loadEventsFromHive();
    _refreshItems();
  }

  //This function updartes the UI
  Future<void> _refreshItems() async {
    final data = await refreshItems();
    setState(() {
      print("Updated the UI");
      _filteredData = data;
    });
  }

  void createNewItem(Map<String, dynamic> newEvent) {
    createItem(newEvent, _refreshItems);
  }

  @override
  Widget build(BuildContext context) {
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
          EventsList(events: _filteredData),
        ],
      ),
      floatingActionButton: const AddEventButton(),
    );
  }
}
