#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
dependency "vibe-d:tls" version="~>0.8"
subConfiguration "vibe-d:tls" "botan"
+/
import vibe.d;

version(unittest) {
void main() {
    assert(requestHTTP("http://localhost:8080/").bodyReader.readAllUTF8 == "Hello, World: /");
}} else
void main()
{
	auto router = new URLRouter;
	with(router) {
        // CORS
        any("/api/*", delegate void(scope HTTPServerRequest req, scope HTTPServerResponse res) {
            res.headers["Access-Control-Allow-Origin"] = "*";
        });

	    get("/", (req, res) {
            res.writeBody("Hello, World: " ~ req.path);
        });
	}

    listenHTTP(":8080", router);
    import std.algorithm : canFind;
    // List all registered routes
    foreach (route; router.getAllRoutes)
        if ([HTTPMethod.POST, HTTPMethod.GET, HTTPMethod.PUT].canFind(route.method))
            logInfo("%s: %s", route.pattern, route.method);

    runApplication();
}
