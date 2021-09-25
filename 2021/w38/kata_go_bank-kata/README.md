# goal of this exercise

this is a personal experiment.

the goal was practicing a mindset:

> instead of considering mocks as a test tool for verifying behaviour - through verifying collaboration - consider them as a test tool for _verifying (outgoing) state (more accurately, the state of the outgoing command) at the boundaries_.

keeping this in mind, naturally leads to the third item in [Sandi Metz's list](https://www.youtube.com/watch?v=URSWYvyc42M) for unit testing. which is to only verify the interaction command to be sent - and do not verify anything on the response, because there is nothing there to verify (it's not real object).

this mindset helps avoiding writing tautological tests. we do not verify anything other than the actual state (the content) of the outgoing command, which is being passed over a boundary.

# setup

- setup Go
    - brew is the easiest way on mac
    - put `go` command be in $PATH, to check:
    ```
    ❯ go version
    go version go1.17.1 darwin/amd64
    ```
    - Go bin dir be in $PATH (`Users/<user-name>/go/bin`)
    - depending on the machine, other Go env vars (`$ go env`) might need tweaking

- setup VSCode Go Extension
    - the linter used here is `"go.lintTool": "golangci-lint",` - open vscode settings as JSON and add this
    - bunch of other vscode settings:
    ```json
    "go.useLanguageServer": true,
    "go.formatTool": "goimports",
    "go.lintFlags": [
        "--fast",
        "--exclude=\".*xstep/test/support.Step composite literal uses unkeyed fields.*\""
    ],
    "go.lintTool": "golangci-lint",
    "gopls": {
        "analyses": {
        "composites": false
        },
        "build.buildFlags": ["-tags=wireinject"]
    },
    "go.coverageDecorator": {
        "type": "gutter",
        "coveredHighlightColor": "rgba(64,128,128,0.5)",
        "uncoveredHighlightColor": "rgba(128,64,64,0.25)",
        "coveredGutterStyle": "blockgreen",
        "uncoveredGutterStyle": "blockred"
    },
    "go.coverOnSingleTest": true,
    "go.toolsManagement.autoUpdate": true,
    "files.trimTrailingWhitespace": true,
    "telemetry.enableTelemetry": false,
    "redhat.telemetry.enabled": false
    ```

# run tests

- fetch module dependencies

```
❯ go mod tidy
```

- run unit tests

```
❯ make cover
```

- run integration tests

```
❯ make cover-intg
```

- run acceptance tests

```
❯ make cover-accp
```

- run all tests

```
❯ make cover-all
```

# refrences

[source 1](https://katalyst.codurance.com/bank)
[source 2](https://github.com/sandromancuso/Bank-kata)
