# Graphql_issue

This repository is made due to this [issue](https://github.com/zino-hofmann/graphql-flutter/issues/1117)

## Problem
1. Fetch all todos -> (Empty list at start)
2. Create one todo by clicking "+1" symbol -> (Empty list still)
3. Fetch all todos again by clicking refresh icon -> (Todo gets added)

## Getting Started

Download go if needed [tutorial](https://www.freecodecamp.org/news/setting-up-go-programming-language-on-windows-f02c8c14e2f/)

Run go server
```
cd server
go run server.go
```

Open flutter application
```
flutter run
```

Note: Remember to change the lib/injection/register_module.dart http link to match yours

If there are auto-generated files that cause conflicts please run script below: 
```
flutter pub run build_runner watch --delete-conflicting-outputs
```
