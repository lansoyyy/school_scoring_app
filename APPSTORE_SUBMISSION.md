# App Store Submission Prep

This project has been prepared for first iOS App Store submission with the following identifiers.

## Apple Identifiers

- App Name: School Scoring App
- Bundle ID (App ID): com.dsi.schoolscoringapp
- Suggested SKU: SSA-IOS-2026-001

## What Was Prepared In Project

- iOS bundle identifier updated from placeholder to production bundle id.
- iOS test target bundle id updated accordingly.
- iOS version/build incremented to `1.0.0+2` for first upload.
- App Transport Security updated from full arbitrary loads to a scoped exception for `93.127.140.225`.
- Added iOS notifications usage description.
- Added export compliance key (`ITSAppUsesNonExemptEncryption=false`).

## App Store Connect Setup Checklist

1. Create app in App Store Connect with:
   - Platform: iOS
   - Name: School Scoring App
   - Primary Language: English (or your preferred language)
   - Bundle ID: com.dsi.schoolscoringapp
   - SKU: SSA-IOS-2026-001
2. In Apple Developer, create explicit App ID `com.dsi.schoolscoringapp` if not already present.
3. Enable capabilities as needed (Push Notifications only if you will send remote pushes).
4. Create iOS Distribution certificate and App Store provisioning profile for this bundle id.
5. Build and archive from Xcode (or flutter build ipa) using Release configuration.
6. Upload build to App Store Connect and complete:
   - App Privacy nutrition labels
   - Content Rights
   - Age Rating
   - Screenshots (6.7", 6.5", and any required iPad sizes if iPad supported)
   - App description, keywords, support URL, privacy policy URL
7. Submit for review.

## Important Note

The app currently uses HTTP for backend (`http://93.127.140.225:8082/DSI`).
A scoped ATS exception is configured for this host to allow review/testing.
For long-term compliance and better review confidence, migrate backend to HTTPS.
