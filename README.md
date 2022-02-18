# Graphql_issue

This repository is made due to this [issue](https://github.com/zino-hofmann/graphql-flutter/issues/1046)

## Problem
1. Fetch all todos
2. Create one todo by clicking "+1" symbol
3. Fetch all todos again by clicking refresh icon
4. Created todo do not appear (THE ISSUE)
5. Fetch all todos second time
6. Created todo appears now

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
