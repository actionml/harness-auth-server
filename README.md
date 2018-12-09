# Harness Auth Server Overview

## Common Module Usage
harness-auth-common module contains auth server protocol case classes which can be used via dependency:
```
"com.actionml" %% "harness-auth-common" % <version>
```

## Build

**Requirements**:

- **OpenJDK 8**
- **Maven 3**

To build auth server you can install the given prerequisites into your system and run `make build` or use pre-configured SDK container. We recommend to use [actionml/harness-sdk](https://hub.docker.com/r/actionml/harness-sdk/) docker container image to perform build.

### Using local build

If you want to build Harness with a locally built `harness-auth-server`, which is the typical case since there is no tar published yet, do the following.

```bash
make build
make publish-local
```

This will put harness dependencies in the local .ivy2 cache so when you build harness you will not get missing dependencies.
