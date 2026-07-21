# Third-Party Notices

Fitareeaee's project-level MIT license covers repository code authored
for this project. Third-party software and data remain under their respective
licenses. The Android APK also embeds Flutter's generated dependency notices at
`assets/flutter_assets/NOTICES.Z`.

## Direct Flutter dependencies

| Package | Resolved version | License family |
|---|---:|---|
| `cupertino_icons` | 1.0.8 | MIT |
| `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `cloud_functions`, `firebase_messaging` | 3.15.2 / 5.7.0 / 5.6.12 / 12.4.10 / 5.6.2 / 15.2.10 | BSD-style |
| `flutter_riverpod`, `riverpod_annotation` | 2.6.1 / 2.6.1 | MIT |
| `go_router` | 14.8.1 | BSD-style |
| `location` | 6.0.2 | MIT |
| `flutter_map` | 8.3.1 | BSD-style |
| `latlong2` | 0.10.1 | Apache-2.0 |
| `speech_to_text` | 7.4.0 | BSD-style |
| `json_annotation`, `freezed_annotation` | 4.9.0 / 2.4.4 | BSD-style / MIT |
| `shared_preferences`, `intl`, `google_fonts`, `url_launcher` | 2.5.3 / 0.19.0 / 6.3.3 / 6.3.2 | BSD-style |
| `country_picker`, `cached_network_image`, `uuid`, `dartz` | 2.0.27 / 3.4.0 / 4.5.2 / 0.10.1 | MIT |
| `image_picker` | 0.8.9 | Apache-2.0 |

## Direct Firebase Functions dependencies

| Package | Resolved version | License |
|---|---:|---|
| `firebase-admin` | 14.2.0 | Apache-2.0 |
| `firebase-functions` | 7.3.0 | MIT |
| `openai` | 6.48.0 | Apache-2.0 |
| `@firebase/rules-unit-testing`, `firebase`, `typescript` | 5.0.1 / 12.16.0 / 5.9.3 | Apache-2.0 |

The tables list direct dependencies used by this submission; the generated APK
notice bundle is authoritative for packaged transitive components.

## OpenStreetMap

The interactive trip pin picker uses map data and standard raster tiles from
OpenStreetMap:

- Map data: © OpenStreetMap contributors, available under the
  [Open Data Commons Open Database License](https://www.openstreetmap.org/copyright).
- Tile service: subject to the
  [OpenStreetMap Foundation Tile Usage Policy](https://operations.osmfoundation.org/policies/tiles/).
- The map permanently displays a clickable `© OpenStreetMap contributors`
  attribution. It uses the required HTTPS tile URL, identifies the Android app
  with `com.fitareeaee.app`, honors HTTP caching through `flutter_map`'s built-in
  native cache, and requests only tiles for the user-visible viewport.
- The app provides no tile prefetch, bulk download, or offline-map feature.

The community tile service is best-effort and has no availability guarantee. A
commercial launch or material traffic increase should move to a provider whose
capacity, privacy terms, and service agreement fit the production workload.

## Submission media and app assets

No music is bundled in the app. Before final Devpost submission, the owner must
confirm authorization for the launcher artwork, screenshots, recorded video,
and any media added outside this repository. Credentials, private user data, and
real identity documents must not appear in submission media.
