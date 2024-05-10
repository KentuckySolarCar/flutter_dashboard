# flutter_dashboard
[![unit-tests](https://github.com/KentuckySolarCar/flutter_dashboard/actions/workflows/unit-tests.yaml/badge.svg?branch=main)](https://github.com/KentuckySolarCar/flutter_dashboard/actions/workflows/unit-tests.yaml)

Next-gen dashboard built in Flutter for UK solar car as a part of Project C.O.L.E.

Uses https://github.com/sony/flutter-elinux as engine.

This uses the provider state management scheme (probably)
https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple


example: 
- https://github.com/flutter/samples/tree/main/provider_shopper/lib
- https://github.com/nuwan94/provider-example/tree/master/lib/theme

## Architecture
This app has particular requirements, which existing setups don't exactly cater to. I chose to build a hybrid provider 
setup which allows for a TON of flexibility and prevents underlying widgets from having to concern themselves with state.

Hopefully this works out.
