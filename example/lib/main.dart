// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  @override
  String toString() {
    return 'DemoModel(id: $id)';
  }

  @override
  bool operator ==(covariant DemoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.value1 == value1 &&
        other.value2 == value2 &&
        other.value3 == value3 &&
        other.value4 == value4 &&
        other.value5 == value5 &&
        other.value6 == value6;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        value1.hashCode ^
        value2.hashCode ^
        value3.hashCode ^
        value4.hashCode ^
        value5.hashCode ^
        value6.hashCode;
  }
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
  DemoModel? selectedRow2;

  @override
  Widget build(BuildContext context) {
    final data1 = List.generate(
      2,
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
    );
    final data2 = List.generate(
      30,
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
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SelectionArea(child: Text('dfgko,adpsfldsaopfladsopfdls')),
              SpargoTable<DemoModel>(
                maxHeight: 472,
                data: data2,
                onRowTap: (model) => setState(() => selectedRow2 == model
                    ? selectedRow2 = null
                    : selectedRow2 = model),
                selectedRow: selectedRow2,
                // maxHeightSubWidget: 150,
                // selectedRowSubWidgetBuilder: (model) => SpargoTable<DemoModel>(
                //   maxHeight: 472,
                //   decorationConfiguration: SpargoTableDecorationConfig(
                //       colorRowsBetweenRows: true, colorEvenItems: Colors.red, colorOddItems: Colors.green),
                //   selectedRowSubWidgetBuilder: (model) => Container(
                //     color: Colors.red,
                //     child: Column(
                //       children: [
                //         Text('test'),
                //         Text('test'),
                //         Text('test'),
                //       ],
                //     ),
                //   ),
                //   // selectedRow: data1[27],
                //   data: data1,
                //   configuration: SpargoTableConfig(
                //     columns: [
                //       SpargoTableColumnConfig(name: 'Id'),
                //       SpargoTableColumnConfig(name: 'Name'),
                //       SpargoTableColumnConfig(name: 'Value1'),
                //       SpargoTableColumnConfig(name: 'Value2'),
                //       SpargoTableColumnConfig(name: 'Value3'),
                //       SpargoTableColumnConfig(name: 'Value4'),
                //       SpargoTableColumnConfig(name: 'Value5'),
                //       SpargoTableColumnConfig(name: 'Value6'),
                //     ],
                //     buildRow: (model) => [
                //       SpargoTableCellConfig(
                //           child: Column(
                //         children: [
                //           Text(model.id.toString()),
                //           Text(model.id.toString()),
                //         ],
                //       )),
                //       SpargoTableCellConfig(child: Text(model.name.toString())),
                //       SpargoTableCellConfig(child: Text(model.value1.toString())),
                //       SpargoTableCellConfig(child: Text(model.value2.toString())),
                //       SpargoTableCellConfig(child: Text(model.value3.toString())),
                //       SpargoTableCellConfig(child: Text(model.value4.toString())),
                //       SpargoTableCellConfig(child: Text(model.value5.toString())),
                //       SpargoTableCellConfig(child: Text(model.value6.toString())),
                //     ],
                //   ),
                // ),
                decorationConfiguration: SpargoTableDecorationConfig(
                  colorRowsBetweenRows: true,
                  colorEvenItems: const Color(0xFFDDE8FF),
                  headerBackground: Colors.blue,
                  borderTable: Border.all(width: 1, color: Colors.blue),
                  iconHeaderColor: Colors.white54,
                  activeIconHeaderColor: Colors.white,
                  focusBorderTextFieldColor: Colors.white,
                  cursorColor: Colors.white,
                  textStyleTextField: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white),
                  tableBorderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  headerBorderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                ),
                configuration: SpargoTableConfig(
                  columns: [
                    SpargoTableColumnConfig(
                      name: 'Id',
                      queryFilter: (query, model) =>
                          model.id.toString().contains(query),
                    ),
                    SpargoTableColumnConfig(
                        name: 'Name', sortBy: (_, __, ___) => 1),
                    SpargoTableColumnConfig(
                      name:
                          'Value1 fadsf adsf adsf adsf dsaf adsf dsaf adsf ads fdsa fadsf adsf adsf ',
                      queryFilter: (query, model) => true,
                    ),
                    SpargoTableColumnConfig(
                      name: 'Value2',
                      queryFilter: (query, model) => true,
                    ),
                    SpargoTableColumnConfig(name: 'Value3'),
                    SpargoTableColumnConfig(name: 'Value4'),
                    SpargoTableColumnConfig(name: 'Value5'),
                    SpargoTableColumnConfig(name: 'Value6'),
                  ],
                  buildRow: (model) => [
                    SpargoTableCellConfig(
                        builder: (isSelected) => Text(
                              model.id.toString(),
                              style: !isSelected
                                  ? null
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.red),
                            )),
                    SpargoTableCellConfig(
                        builder: (isSelected) => Text(model.name.toString())),
                    SpargoTableCellConfig(
                        builder: (isSelected) => Text(model.value1.toString())),
                    SpargoTableCellConfig(
                        builder: (isSelected) => Text(model.value2.toString())),
                    SpargoTableCellConfig(
                        builder: (isSelected) => Text(model.value3.toString())),
                    SpargoTableCellConfig(
                        builder: (isSelected) => Text(model.value4.toString())),
                    SpargoTableCellConfig(
                        builder: (isSelected) => Text(model.value5.toString())),
                    SpargoTableCellConfig(
                        builder: (isSelected) => Text(model.value6.toString())),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
