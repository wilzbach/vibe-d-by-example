#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
+/
import vibe.d;

version(unittest) {
void main() {
    assert(requestHTTP("http://localhost:8080/").bodyReader.readAllUTF8 == "Hello, World: /");
}} else
void main()
{
	auto router = new URLRouter;

    // CORS
    router.any("/api/*", delegate void(scope HTTPServerRequest req, scope HTTPServerResponse res) {
        res.headers["Access-Control-Allow-Origin"] = "*";
    });

	router.get("/api", (req, res) {
        res.writeBody("Hello, World: " ~ req.path);
    });

    // serve resources if existent
    router.get("*", serveStaticFiles("frontend/build"));
    // fallback to index.html
    router.get("*", serveStaticFile("frontend/build/index.html"));

    listenHTTP(":8080", router);
    runApplication();
}
