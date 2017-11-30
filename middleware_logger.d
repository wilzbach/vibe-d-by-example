#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8.2"
+/
import vibe.d;

auto addLogger(scope HTTPServerRequestHandler handler)
{
    return (scope HTTPServerRequest req, scope HTTPServerResponse res) {
        logInfo("Start handling request %s", req.requestURL);
        handler.handleRequest(req, res);
        logInfo("Finished handling request.");
    };
}

void main()
{
	auto router = new URLRouter;
	router.get("/", (req, res) {
        res.writeBody("Hello, World: " ~ req.path);
    });

	// start with the router request handler
	HTTPServerRequestHandler handler = router;

	// Add middleware
    listenHTTP(":8080", addLogger(handler));
    runApplication();
}
