import 'package:flutter/material.dart';
import 'package:spargo_table/spargo_table.dart';

void main() {
  runApp(const MyApp());
}

class DemoModel {
  const DemoModel(this.id, this.name, this.value1, this.value2, this.value3,
      this.value4, this.value5, this.value6);
  final int id;
  final String name;
  final String value1;
  final String value2;
  final String value3;
  final String value4;
  final String value5;
  final String value6;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spargo Table DEMO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpargoTable<DemoModel>(
              maxHeight: 472,
              data: List.generate(
                10000,
                (index) => DemoModel(
                  index,
                  'name_$index',
                  'value_1_$index',
                  'value_2_$index',
                  'value_3_$index',
                  'value_4_$index',
                  'value_5_$index',
                  'value_6_$index',
                ),
              ),
              configuration: SpargoTableConfig(
                columns: [
                  SpargoTableColumnConfig(name: 'Id'),
                  SpargoTableColumnConfig(name: 'Name'),
                  SpargoTableColumnConfig(name: 'Value1'),
                  SpargoTableColumnConfig(name: 'Value2'),
                  SpargoTableColumnConfig(name: 'Value3'),
                  SpargoTableColumnConfig(name: 'Value4'),
                  SpargoTableColumnConfig(name: 'Value5'),
                  SpargoTableColumnConfig(name: 'Value6'),
                ],
                buildRow: (model) => [
                  SpargoTableCellConfig(
                      child: Column(
                    children: [
                      Text(model.id.toString()),
                      Text(model.id.toString()),
                    ],
                  )),
                  SpargoTableCellConfig(child: Text(model.name.toString())),
                  SpargoTableCellConfig(child: Text(model.value1.toString())),
                  SpargoTableCellConfig(child: Text(model.value2.toString())),
                  SpargoTableCellConfig(child: Text(model.value3.toString())),
                  SpargoTableCellConfig(child: Text(model.value4.toString())),
                  SpargoTableCellConfig(child: Text(model.value5.toString())),
                  SpargoTableCellConfig(child: Text(model.value6.toString())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
