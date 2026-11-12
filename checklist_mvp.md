# FreshTrack - MVP Completion Checklist

## 1. Project Overview

FreshTrack is a mobile application for managing stored food items and monitoring their expiration dates.

The MVP focuses on food inventory management, expiration tracking, and reducing food waste.

## 2. MVP User Stories and Acceptance Criteria

### User Story 1 - Add Food

**As a user, I want to add food items so that I can record my stored food inventory.**

Acceptance Criteria:

- [x] User can enter a food name.
- [x] User can select a food category.
- [x] User can enter a quantity.
- [x] User can select a stored date and use-by date.
- [x] User can select a storage location.
- [x] The application validates required fields.
- [x] The application rejects invalid quantities.
- [x] The application rejects a use-by date earlier than the stored date.
- [x] Food data is submitted to the backend API.

**Unit Test Status:** PASSED

Related test file: `food_validation_test.dart`

### User Story 2 - View Food List

**As a user, I want to view my food inventory so that I can monitor stored food items.**

Acceptance Criteria:

- [x] User can view the food list.
- [x] Food data is retrieved from the backend API.
- [x] User can search food by name.
- [x] User can filter food by category.
- [x] User can filter food by storage location.
- [x] User can sort food by expiration date.
- [x] The application supports an empty food list state.

**Unit Test Status:** PASSED

Related test files:
- `food_model_test.dart`
- `food_filter_test.dart`
- `food_sort_test.dart`

### User Story 3 - Edit Food

**As a user, I want to edit food information so that I can update my inventory.**

Acceptance Criteria:

- [x] User can open food details.
- [x] User can access the edit food form.
- [x] User can update food information.
- [x] The application validates food name and quantity.
- [x] The application validates stored and use-by dates.
- [x] Updated food data is submitted to the backend API.

**Unit Test Status:** PASSED

Related test file: `food_validation_test.dart`

### User Story 4 - Delete Food

**As a user, I want to delete food items so that I can remove items that are no longer in my inventory.**

Acceptance Criteria:

- [x] User can access food details.
- [x] User can delete a food item.
- [x] The application sends a delete request to the backend API.
- [x] The deleted item is removed from the food list.

**Unit Test Status:** PASSED

The API integration is included in the application. The current automated tests do not independently test the complete delete API flow.

### User Story 5 - Monitor Food Expiration Status

**As a user, I want to see food expiration statuses so that I know which food items should be used soon.**

Acceptance Criteria:

- [x] Food is marked as Past Due when its use-by date has passed.
- [x] Food is marked as Use Soon when its use-by date is today or within two days.
- [x] Food is marked as Fresh when its use-by date is more than two days away.
- [x] Expiration status is calculated using the use-by date.

**Unit Test Status:** PASSED

Related test file: `food_status_test.dart`

## 3. Unit Test Results

The following test files are included in the Flutter project:

| No. | Test File | Status |
|---|---|---|
| 1 | food_validation_test.dart | PASSED |
| 2 | food_model_test.dart | PASSED |
| 3 | food_status_test.dart | PASSED |
| 4 | food_filter_test.dart | PASSED |
| 5 | food_sort_test.dart | PASSED |
| 6 | widget_test.dart | PASSED |

**Total Test Results:**

- Total tests: 34
- Passed: 34
- Failed: 0

Command:

```powershell
flutter test
```

Result:

```text
00:05 +34: All tests passed!
```

## 4. Static Code Analysis

Command:

```powershell
flutter analyze
```

Result:

```text
No issues found!
```

Status: PASSED

## 5. Application Integration

- [x] Flutter frontend integrated with Laravel backend.
- [x] MySQL database configured.
- [x] Authentication API integrated.
- [x] Food CRUD API integrated.
- [x] Android Emulator successfully runs the application.
- [x] Login successfully connects to the backend.

## 6. Final MVP Status

**MVP implementation:** COMPLETED

**Automated Unit Tests:** PASSED (34/34)

**Static Code Analysis:** PASSED

**Final regression testing:** To be completed before final demonstration.
