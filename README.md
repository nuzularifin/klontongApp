# flutter_klontong

This Project for Flutter CRUD with management state handling with FlutterBloc.

The module of project consist of several sample like below : 
- Folder data ==> for api hit and repository handling 
- Folder utils ==> for settings and configuration app;
- Folder Screen ==> presentation layer for screen or view;
- Folder model ==> object;
- Folder bloc == for management state, event and businesslogic handling;

all library i am used : 
- mockito for testing 
- Flutter bloc for bloc management handling;
- Dio for HTTP Request handling 
- Dio Interceptor for logging Http Request;
- Equatable for handling state management;
- flutter_dotenv for handling key want to make it different build dev, stag, or production;

if you want to learn it, you can try 
- pub get first 
- and then dart run build_runner build for generate mock testing
- and then you can go 

This app simple CRUD for implementation Bloc State management handling, i am didnt use Usecase because it can make more complex for explaining.

Thank you..

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
