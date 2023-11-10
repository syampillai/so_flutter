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
- New type of field added to handle monetary values. Check the new `DataScreen` method `moneyField(...)`.
- More formatting support added for numeric fields.

## 0.3.3
- Money field now supports selection of currencies.
- New field added - `Roller`. Supports inline rolling of items.
