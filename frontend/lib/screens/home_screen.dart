import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../common/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String message = "Fetching data...";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final data = await ApiService.getData();
    setState(() {
      message = data ?? "Failed to fetch data";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "HoofHub",
        showBackButton: false,
      ),
      body: Center(child: Text(message)),
      
    );
  }
}
