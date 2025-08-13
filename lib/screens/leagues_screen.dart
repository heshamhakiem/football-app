import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'matches_screen.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  List<dynamic> leagues = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeagues();
  }

  Future<void> fetchLeagues() async {
    const url = "https://api-football-v1.p.rapidapi.com/v3/leagues"; // Example API
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-RapidAPI-Key': '8ab7b1569dmsh0f394f109ece890p182075jsnf19e252c9fc4',
        'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        leagues = data["response"];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception("Failed to load leagues");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select League")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: leagues.length,
              itemBuilder: (context, index) {
                final league = leagues[index]["league"];
                return ListTile(
                  leading: Image.network(league["logo"], width: 40),
                  title: Text(league["name"]),
                  subtitle: Text("Country: ${leagues[index]['country']['name']}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MatchesScreen(
                          league: league["name"], leagueId: league["id"],
                        
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
