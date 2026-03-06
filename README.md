# Places (iOS)

## Scope

Minimal app that:
- shows a list of places,
- supports adding custom coordinates,
- persists custom locations locally,
- opens Wikipedia Places deep link only from explicit list tap.

No sync/back-end layer by design.

## Architecture

- **Pattern**: MVVM + Coordinator + Router (feature-first).
- **Navigation ownership**: coordinator only.
  - `PlacesCoordinator` owns `NavigationPath` and modal route state.
  - Feature view models emit route intent via router protocols.
  - Views do not mutate navigation state directly.
- **View dependencies**:
  - Feature screens receive only view models.
  - Root container (`PlacesRootView`) receives coordinator and composes navigation.
- **Flow composition**:
  - `PlacesCoordinator` creates/owns `CustomLocationCoordinator` as child flow.
  - `CustomLocationCoordinator` creates `CustomLocationViewModel` and handles dismiss route.

## Feature boundaries

- `Features/PlacesList`
  - list rendering, loading state UI, opening Wikipedia route intent.
- `Features/CustomLocation`
  - coordinate entry, validation, save/cancel intents.
- `Services`
  - persistence and location source composition.
- `Core`
  - app-level composition/dependencies/coordinators.

No cross-feature direct coupling; interaction goes through contracts.

## Persistence model

- `Location` has stable `id`:
  - bundled locations: deterministic from `lat/lon`,
  - custom locations: `customId` (UUID-backed) for collision-safe persistence/update.
- `LocationService`:
  - `loadAllLocations()` = bundled `locations.json` + persisted custom locations.
  - `saveCustomLocation(_:)` merges by `id` (replace semantics for same custom id).
  - storage backend: `UserDefaults` (injectable in tests).

## Routing contracts

- Places list routes: `PlacesListRouteTrigger`
  - `.showCustomLocation`
  - `.openWikipediaPlaces(lat:lon:name:)`
- Custom location routes: `CustomLocationRouteTrigger`
  - `.dismiss`

Routers forward route intents; coordinators decide presentation state.

## Test strategy

Current unit test coverage focuses on behavior-critical seams:

- `PlacesListViewModelTests`
  - async loading state transitions (`loading/success/empty/failure`)
  - route intents (`showCustomLocation`, `openWikipediaPlaces`)
  - `addCustomLocation` behavior (append, fallback naming, persistence side effects)
- `PlacesCoordinatorTests`
  - presenting custom flow from route
  - dismissing custom flow on cancel
  - save path updates list and closes modal
- `CustomLocationViewModelTests`
  - validation errors
  - save success path
  - cancel path
- `LocationServiceTests`
  - persistence/readback
  - merge-by-id semantics
