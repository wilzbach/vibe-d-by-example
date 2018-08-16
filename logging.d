#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
+/
import vibe.d;

void main()
{
    import vibe.core.log;
    setLogLevel(LogLevel.info);

    listenHTTP(":8080", (req, res) {
        res.writeBody("Hello, World: " ~ req.path);
    });
    runApplication();
}
