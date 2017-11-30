#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8.2"
+/
import vibe.d;

version(unittest) {
void main() {
    auto req = requestHTTP("http://localhost:8080");
    assert("Access-Control-Allow-Origin" !in req.headers);
    assert(req.bodyReader.readAllUTF8 == "Hello, World: /");

    auto reqApi = requestHTTP("http://localhost:8080/api/foo");
    assert(reqApi.headers["Access-Control-Allow-Origin"] == "*");
    assert(reqApi.statusCode == HTTPStatus.notFound);
    reqApi.dropBody;
}} else
void main()
{
	auto router = new URLRouter;

    // CORS
    router.any("/api/*", delegate void(scope HTTPServerRequest req, scope HTTPServerResponse res) {
        res.headers["Access-Control-Allow-Origin"] = "*";
    });

	router.get("/", (req, res) {
        res.writeBody("Hello, World: " ~ req.path);
    });

    listenHTTP(":8080", router);
    runApplication();
}
