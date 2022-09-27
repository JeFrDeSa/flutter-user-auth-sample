# user_auth_sample

A simple user authentication code sample for Flutter.

## App use

The App requests a user login and password.
* The user will be forwarded to the initial page, if the login credentials are valid
* The user will be notified by a hint, if the login credentials are invalid

The App provides a registration feature to add a new user profile.
* The user will be notified by a hint, If the login credentials are already used
* The user will be forwarded to a registration form, if the login credentials not already exist

## Directory structure

### lib/core

Contains global relevant error definitions, features and utilities. 

### lib/features

Contains specific features of the application.

## Feature implementation

A feature contains the presentation, domain and data layer for its scope.

#### .../presentation

The presentation (layer) contains the actual feature representation as well as the different widgets of it.

#### .../domain

The domain (layer) contains entities and use cases of the feature as well as the repository contract for the data (layer).

#### .../data

The data (layer) contains the models and repository implementation with access to external APIs.
