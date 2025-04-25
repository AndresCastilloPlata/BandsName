import 'package:bands_name/models/band.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'AC/DC', votes: 7),
    Band(id: '2', name: 'Queen', votes: 3),
    Band(id: '3', name: 'Krokus', votes: 1),
    Band(id: '4', name: 'Judas Priest', votes: 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bands Names',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder:
            (BuildContext context, int index) => _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  ListTile _bandTile(Band band) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.lightBlueAccent[100],
        child: Text(band.name.substring(0, 2)),
      ),
      title: Text(band.name),
      trailing: Text('${band.votes}'),
      onTap: () {
        print(band.name);
      },
    );
  }
}
