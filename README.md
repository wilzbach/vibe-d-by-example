Vibe.d by Example
=================

[![Travis](https://travis-ci.org/wilzbach/vibe-d-by-example.svg?branch=master)](https://travis-ci.org/wilzbach/vibe-d-by-example)

Every example can be directly executed and will start a web server listening on port `8080` if `dub` (D's package manager) is installed. To get `dub`, [refer to the downloads page](https://dlang.org/download.html).

Basic examples
----

- [Hello World](hello.d)
- [Config](config.d)
- [Content type](content_type.d)
- [CORS](cors.d)
- [Custom routes](routes.d)
- [Auth](use_auth.d)
- [HTML5 mode](html5.d)
- [Logging](logging.d)
- [Custom logger](logging_custom.d)
- [Custom middleware](middleware_logger.d)
- [Serve static files](static_files.d)

vibe.web.web
============

- [@before middlewares](web/before_check.d)
- [Error display](web/error_display.d)
- [Methods](web/methods.d)
- [Routes](web/routes.d)
- [Service](web/service.d)
- [Session](web/session.d) - shows how session variables can be used

How to run an example
---------------------

### Start the server for an example

```sh
./hello
```

### Start the client for an example

```sh
dub --single -b unittest hello.d
```

Alternatively, you can also use:

```sh
make bin/hello.client
```

### Start both the server and client for an example

```sh
make bin/hello.test
```

How to run all examples?
------------------------

```
make all
```

TODO
----

- Sessions
- Error stack traces
- Cookies
- Mongo Collections
- REST
- OAuth
- Files
- JSON
  - common manipulation methods (iterate objects, arrays, …)
  - to/from string
- Serializing
- Custom Requests
- Async
- Load balancing
- Statically link all libraries with ldc
- Redis
- Postgres
- Bootstrap / scaffold
- vibe.web.web
  - Auto parameter injection
  - Common aliases
  - Path -> params
  - Query -> params
- Use Botan
- Use vibe-core
- Diet + Caching
- dlang-requests
- CLI, environment & configs (e.g. port)
- overwrite config
  - TLS
  - vibe-core
  - libasync
- TODO: Look at Koa + Express examples

Common problems
===============

### SSL

Vibe.d uses OpenSSL 1.0 by default. This often causes problems.
However, it's easy to use `openssl-1.1` or `botan`.

#### CLI

```
--override-config vibe-d:tls/openssl-1.1
```

#### `dub.sdl`

```
dependency "vibe-d:tls" version="~>0.8.2"
subConfiguration "vibe-d:tls" "openssl-1.1"
```

#### `dub.json`

```json
{
    ...
    "dependencies": {
        ...
        "vibe-d:tls": "*"
    },
    "subConfigurations": {
        ...
        "vibe-d:tls": "openssl-1.1"
    }
}
```
