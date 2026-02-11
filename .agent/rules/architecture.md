# Architecture Rules

This project follows a feature-driven, clean architecture pattern optimized for Flutter. All new features and refactors must adhere to the following structure.

## 1. Feature Folder Structure
Each feature must be contained within `lib/feature/[feature_name]/` and maintain two primary subdirectories:

### A. View Layer (`/view`)
Contains the UI and view-specific logic.
- **`[feature_name]_view.dart`**: The main `StatefulWidget` or `StatelessWidget`.
- **`mixin/`**: Contains `[feature_name]_view_mixin.dart`. All lifecycle methods (`initState`, `dispose`) and functional logic of the view must reside here.
    - Template: `mixin [FeatureName]ViewMixin on State<[FeatureName]View> { ... }`
- **`widget/`**: Contains modular, atomic widgets used specifically within this view. 
    - These widgets must use the `part` and `part of` directives to be tightly coupled with the main view.
    - Widgets in this folder should typically be private (start with `_`) to ensure they are not used outside the feature scope.

### B. View Model Layer (`/view_model`)
Contains the business logic and state management (e.g., BLoC, MobX, or Provider-based ViewModels).
- **`[feature_name]_view_model.dart`**: The logic handler.
- **`state/`**: Contains `[feature_name]_state.dart`. Defines the immutable state classes used by the ViewModel.

## 2. Component Organization Rules

### Functional Logic (Mixins)
Never put business logic or heavy functional code directly inside `[feature_name]_view.dart`. Move it to the `mixin/` folder. This separates the "What" (UI) from the "How" (Logic).

### Atomic Weights (Part Files)
View-specific child widgets should be moved to the `widget/` folder as `part` files.
- In `[feature_name]_view.dart`: `part 'widget/my_sub_widget.dart';`
- In `widget/my_sub_widget.dart`: `part of '../[feature_name]_view.dart';`

## 3. Product Layer
Global utilities, constants, shared widgets, and core services must reside in `lib/product/`. 
- `lib/product/widget/`: Project-wide shared widgets.
- `lib/product/utility/`: Mixins, constants, and extensions.
- `lib/product/state/`: Global state management items.

## 4. Localization Standards
All UI-visible strings must be handled through the `easy_localization` system to maintain multi-language support.

### A. Adding New Strings
Any string constant visible to the user must be added to:
- `assets/translations/en.json` (English)
- `assets/translations/tr.json` (Turkish)
Keys must be descriptive (e.g., `feature_name_button_text`).

### B. Generating Keys
The `LocaleKeys` class must be regenerated after any translation change:
```bash
dart run easy_localization:generate -O lib/product/init/language -f keys -o locale_keys.g.dart --source-dir assets/translations
```

### C. Usage
Always use `LocaleKeys.key.tr()` in the UI. Never hardcode strings.

## 5. Route Management
The project uses `auto_route` for strongly-typed routing and simplified navigation.

### A. Initialization
- The router is defined in `lib/product/navigation/app_router.dart`.
- The `AppRouter` class must extend `RootStackRouter` and use the `@AutoRouterConfig` annotation.
- In `main.dart`, `MaterialApp.router` is used with the router's config:
    ```dart
    routerConfig: _appRouter.config(),
    ```

### B. Adding a New Route
1. Annotate your View class with `@RoutePage()`:
    ```dart
    @RoutePage()
    class HomeView extends StatefulWidget { ... }
    ```
2. Add the route to the `routes` list in `app_router.dart`:
    ```dart
    AutoRoute(page: HomeRoute.page),
    ```
3. Regenerate the routes using `build_runner`:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

### C. Navigation
- Use `context.router` for navigation:
    ```dart
    context.router.push(HomeDetailRoute(title: 'Detail'));
    ```
- For replacing the current stack (e.g., login to home):
    ```dart
    context.router.replaceAll([const HomeRoute()]);
    ```

## 6. Asset and Environment Management (Common Module)
Global resources and configurations are managed within the `module/common` package.

### A. Asset Management
- **Images & Icons**: Add files to `module/common/assets/images/` or `module/common/assets/icons/`.
- **Lottie**: Add JSON files to `module/common/assets/lottie/`.
- **Colors**: Define hex values in `module/common/assets/color/colors.xml`. Use the `<color name="name">#HEX</color>` format.

### B. Environment Management
- The project uses `envied` for secure environment variable handling.
- **Variables**: Define them in `module/common/lib/src/environment/env_dev.dart` (for development) or `env_prod.dart` (for production).
- **Binding**: Ensure variables are mapped correctly to the `.env` files located in `module/common/assets/env/`.

### C. Resource Generation
After adding/modifying any asset or environment variable, you **MUST** regenerate the corresponding Dart files.
1. Navigate to the common module directory:
   ```bash
   cd module/common
   ```
2. Run the build runner:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
   This updates `assets.gen.dart`, `colors.gen.dart`, and environment config files.

## 7. Cache Management
The project uses a structured, abstraction-driven cache system located in `module/core` and integrated in `lib/product/cache/`.

### A. Core Abstractions (`module/core`)
Any cache implementation must follow the base classes in `lib/src/cache/core/`:
- **`CacheManager`**: Interface for the storage engine lifecycle (e.g., `HiveCacheManager`).
- **`CacheModel`**: A mixin that all data models intended for caching must implement.
- **`CacheOperation`**: Interface for CRUD operations on specific data types.

### B. Adding a New Cache Library
To add a new storage engine (e.g., Isar, SQLite):
1. Create a new folder in `module/core/lib/src/cache/`.
2. Implement your library-specific `CacheManager` and `CacheOperation` classes.
3. Export them through `index.dart`.

### C. Caching New Data
1. Create a cache model in the feature or core library by implementing the `CacheModel` mixin.
2. Register the model in `lib/product/cache/product_cache.dart` within the `initialize()` method.
3. Access the cache through a `CacheOperation` instance provided by the `CacheManager`.

### D. Application Integration
- Initialize project-specific cache settings in `lib/product/cache/product_cache.dart`.
- The main entry point for the application's cache orchestration is `ProductCache`.
