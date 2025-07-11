## 0.0.1
- Initial release.
- 
## 0.0.2
- Documentation updated.
- Theme support added.

## 0.0.3
- Added more examples.

## 0.0.4
- Merged examples into a single file because multiple example files can't be published.

## 0.0.5
- Documentation typos corrected.

## 0.0.6
- `App` has new static methods such as `goBack()`, `message(...)`, `alert(...)` etc. See the usages in the example.
- New class: `Field` - represents a data entry field.
- New class: `DataScreen` - for data entry. Contains helper methods for creating text field and date field. (More field types will be added in the future). See the usages in the example.

## 0.0.7
- New types of `Field` added - Fields to accept `double` and `int` values. Check the new `DataScreen` methods.

## 0.1.0
- Breaking change: Appropriate type-specific validators and related arguments are added for type-specific `Fields` such as numeric fields and date fields.
- Because of the signature changes, your code needs to be re-complied if any such functionalities were already used.
- Updated example code with the addition of validators in the data entry screen.

## 0.2.0
- Added new `Field` types in the `DataScreen`. See `selections(...)` and `selection(...)` methods.

## 0.3.0
- Breaking change: Renamed `DataScreen` methods `selections(...)` and `selection(...)` to `selectionsField(...)` and `selectionField(...)` respectively for consistency.
- Added new `Field` types in the `DataScreen` for accepting `bool` values. See `checkboxField(...)` and `switchField(...)` methods.

## 0.3.1
- New types of `Field` added. Check the new `DataScreen` methods: `comboField(...)`, `choiceField(...)`.
- Code refactored into multiple part files.
- Minor bug fixes.

## 0.3.2
- A new type of field added to handle monetary values. Check the new `DataScreen` method `moneyField(...)`.
- More formatting support is added for numeric fields.

## 0.3.3
- The money field now supports a selection of currencies.
- New field added - `Roller`. Supports inline rolling of items.

## 0.3.4
- Unwanted parameter is removed from an internal class. No public classes are affected.

## 0.3.5
- Dart version restriction, upper limit increased.

## 0.3.6
- Dart version restriction, upper limit increased to 3.2.3

## 0.3.7
- Environment and dependencies updated to the latest available versions.

## 0.3.8
- Environment and dependencies updated to the latest available versions.
- Replaced deprecated 'MaterialStateProperty' with 'WidgetStateProperty' in data_screen.dart and field_bool.dart files.

## 0.3.9
- Environment and dependencies updated to the latest available versions.

## 0.3.10
- Environment and dependencies updated to the latest available versions.

## 0.3.11
- Environment and dependencies updated to the latest available versions.

## 0.3.12
- Environment and dependencies updated to the latest available versions.

## 0.3.13
- Environment and dependencies updated to the latest available versions.

## 0.3.14
- Environment and dependencies updated to the latest available versions.
