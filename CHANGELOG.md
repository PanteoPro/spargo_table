## 0.0.23

- Added header text alignment configuration and the ability to change the mainAxisAlignment of the widget

## 0.0.22

- Fix previous version

## 0.0.21

- Added maxWidth inn selectedRowSubWidgetBuilder

## 0.0.20

- Added functionality for dynamic column count changes

## 0.0.19

- Add override Overflow for Text And RichText widgets

## 0.0.18

- Added new builder emptyFilterBuilder

## 0.0.17

- Added Prevented default browser behavior on init table

## 0.0.16

### Added

- Web: Prevented default browser behavior (scrolling/page drag) when resizing columns by calling preventDefault() on touch/mouse events.

### Fixed

- Flutter Web: No longer conflicts with browser's native touch-scrolling while adjusting column widths.

## 0.0.15

- Fixed an issue where the table's maxHeight would incorrectly increase during resize. It now properly respects the defined maximum height limit.

## 0.0.14

- Remove SelectionArea

## 0.0.13

### Breaking Changes

- Remove `child` parameter in SpargoTableCellConfig
- Add `builder: (bool isSelected)` parameter in SpargoTableCellConfig
- Fix Bug with selectedRow

## 0.0.12

- Added new property selectedRowColor

## 0.0.11

- Fix property maxHeightSubWidget

## 0.0.10

- Added new property maxHeightSubWidget

## 0.0.9

#### Changed

- Replaced ListView with CustomScrollView using SliverFixedExtentList and SliverToBoxAdapter.

#### Added

- The size of the selectedRowSubWidgetBuilder now influences the overall size of the table. This ensures that the table dynamically adjusts its dimensions based on the content provided by the selectedRowSubWidgetBuilder

## 0.0.8

- Resolved an issue in the web version where dragging the scrollbar with the mouse caused text selection, making scrolling impossible. This fix ensures smooth and uninterrupted scrolling behavior when interacting with the scrollbar.

## 0.0.7

- Updated the logic for determining the presence of a horizontal scrollbar. The sequence of checks has been modified to improve accuracy and ensure consistent behavior when detecting whether a horizontal scrollbar should be displayed.

## 0.0.6

- Adjusted row height behavior to ensure consistent height for rows when a horizontal scrollbar is present.

## 0.0.5

- Introduced new properties to the `SpargoTableDecorationConfig` class:
  - `borderRow`: Allows customization of the border for table rows.
  - `tableBorderRadius`: Enables setting the border radius for the entire table.
  - `headerBorderRadius`: Provides the ability to define the border radius specifically for the table header.

## 0.0.4

- Fixed an issue where the last row of the table was not rendering correctly. This ensures that all rows, including the last one, are displayed properly, maintaining the integrity of the table's layout and content.

## 0.0.3

- Optimized and upgraded logic for changing column width.
- Improved scrolling performance for the table.

## 0.0.2

- Added Example: A new example has been included to demonstrate the usage of the library.
- Enhanced Scrollbar Configuration: Added the ability to configure the padding and size for the bottom scrollbar.
- Improved Header Text Interaction: Header text is now non-selectable to enhance user experience.
- Flexible Column Resizing: Added support for resizing the last column dynamically.

## 0.0.1

- Init Project.
