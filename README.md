# COMP4977 Assignment 2 – AI iOS App + ASP.NET WebAPI

## Overview
This project is part of BCIT COMP4977.
It consists of:
- An **ASP.NET WebAPI** backend that securely communicates with GitHub Models (LLM).
- An **iOS SwiftUI app** that allows users to send prompts to the LLM via the WebAPI.

## Features
- User registration & login (FirstName, LastName, Email, Password, account creation date, last login date).
- AI tab: send prompts and display responses.
- Profile tab: show user info.
- About tab: team member names and BCIT IDs.
- Secure token handling (no secrets in source control).
- Custom color scheme, unique app icon, and modular SwiftUI subviews.

## Tech Stack
- **Backend:** ASP.NET Core WebAPI, Azure deployment
- **Frontend:** SwiftUI (iOS 17 emulator target)
- **LLM:** GitHub Models API

## Setup
1. Clone the repo
2. Open `COMP4977AIApp.xcodeproj` in Xcode
3. Run on iPhone 17 simulator
4. Backend requires `appsettings.Development.json` (not included in repo)

## Team Members
- [Name 1] – [BCIT ID]
- [Name 2] – [BCIT ID]
- [Name 3] – [BCIT ID]

## Notes
- `appsettings.Development.json` is excluded from source control.
- Backend secrets are stored in Azure environment variables.
