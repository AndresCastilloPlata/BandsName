import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:bands_name/models/band.dart';
import 'package:bands_name/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: 'AC/DC', votes: 7),
    // Band(id: '2', name: 'Queen', votes: 3),
    // Band(id: '3', name: 'Krokus', votes: 1),
    // Band(id: '4', name: 'Judas Priest', votes: 6),
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('bandas-actuales', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('bandas-actuales');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketServiceConnection =
        Provider.of<SocketService>(context).serverStatus;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bands Names',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child:
                (socketServiceConnection == ServerStatus.online)
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.check_circle, color: Colors.red),
          ),
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder:
                  (BuildContext context, int index) => _bandTile(bands[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.emit('delete-band', {'id': band.id}),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: const Text(
              'Delete Band',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.lightBlueAccent[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}'),
        onTap: () => socketService.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  addNewBand() {
    // Create a controller to get the text from the TextField
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('New Band name: '),
              content: TextField(controller: textController),
              actions: [
                MaterialButton(
                  elevation: 5,
                  textColor: Colors.blueAccent[100],
                  child: const Text('Add'),
                  onPressed: () => addBandToList(textController.text),
                ),
              ],
            ),
      );
    }

    showCupertinoDialog(
      context: context,
      builder:
          (_) => CupertinoAlertDialog(
            title: const Text('New Band name: '),
            content: CupertinoTextField(controller: textController),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Add'),
                onPressed: () => addBandToList(textController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void addBandToList(String name) {
    // Add band to the list
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);

      //emitir: add-band
      socketService.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  //mostrar grafica

  Widget _showGraph() {
    // Map<String, double> dataMap = {
    //   "Flutter": 5,
    //   "React": 3,
    //   "Xamarin": 2,
    //   "Ionic": 2,
    // };

    if (bands.isEmpty) {
      return const Center(child: Text('No data available'));
    }
    Map<String, double> dataMap = {};
    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }

    final List<Color> colorList = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      width: double.infinity,
      height: 270,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        // chartLegendSpacing: 32,
        // chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 25,
        // centerText: "HYBRID",
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          // legendShape: _BoxShape.circle,
          legendTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 0,
          chartValueStyle: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
