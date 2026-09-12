# Contributing

## Local checks

Before opening a pull request, run:

```sh
make test
swift build --configuration release
make app
```

Please state whether the change was tested with a real Logitech mouse and a
full-screen presentation app. The repository does not require hardware for its
configuration tests, but the OpenLogi binding and macOS window-level behavior do.

## Scope

Keep device communication in OpenLogi and keep this repository focused on the
presentation overlay. Do not add telemetry, a login flow, or copied OpenLogi
brand assets.
