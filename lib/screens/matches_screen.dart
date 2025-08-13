import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MatchesScreen extends StatefulWidget {
  final String league;
  final int leagueId;

  const MatchesScreen({
    super.key,
    required this.league,
    required this.leagueId,
  });

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<dynamic> matches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    final url =
        "https://api-football-v1.p.rapidapi.com/v3/fixtures?league=${widget.leagueId}&season=2024"; // You can adjust season

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
        matches = data["response"];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception("Failed to load matches");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.league} Matches")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final fixture = matches[index]["fixture"];
                final teams = matches[index]["teams"];
                final goals = matches[index]["goals"];

                return ListTile(
                  leading: Image.network(teams["home"]["logo"], width: 30),
                  title: Text(
                      "${teams["home"]["name"]} vs ${teams["away"]["name"]}"),
                  subtitle: Text(
                      "Score: ${goals["home"] ?? '-'} - ${goals["away"] ?? '-'}"),
                  trailing: Text(fixture["date"].toString().substring(0, 10)),
                );
              },
            ),
    );
  }
}
