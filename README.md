# SpargoTable Library

A highly customizable and flexible table widget for Flutter applications. Easily display and manage tabular data with sorting, filtering, and custom styling.

## Features

- **Customizable Rows and Columns**: Define your own row and column layouts.
- **Sorting**: Sort data by any column in ascending or descending order.
- **Filtering**: Filter rows based on user input.
- **Styling**: Fully customizable table appearance, including headers, rows, and borders.

## Installation

Add the library to your `pubspec.yaml`:

```yaml
dependencies:
  spargo_table: ^0.0.7
```

Then run:
```bash
flutter pub get
```

## Configuration Options
- **data**: The list of items to display in the table.
- **decorationConfiguration**: Customize the table’s appearance (colors, borders, etc.).
- **configuration**: Define columns, rows, sorting, and filtering behavior.

## Example
Here’s a minimal example:

```dart
SpargoTable<MyModel>(
  data: myDataList,
  decorationConfiguration: SpargoTableDecorationConfig(
    headerBackground: Colors.blue,
    borderTable: Border.all(color: Colors.black),
  ),
  configuration: SpargoTableConfig(
    buildRow: (model) => [
      SpargoTableCellConfig(child: Text(model.name)),
      SpargoTableCellConfig(child: Text(model.value.toString())),
    ],
    columns: [
      SpargoTableColumnConfig(name: "Name", width: 100),
      SpargoTableColumnConfig(name: "Value", width: 100),
    ],
  ),
);
```
## Contributing
Contributions are welcome! Please open an issue or submit a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for details.