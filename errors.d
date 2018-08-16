#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
+/
import vibe.d;

version(unittest) {
void main() {
    auto req = requestHTTP("http://localhost:8080/forbidden");
    scope(exit) req.dropBody;
    assert(req.statusCode == HTTPStatus.forbidden);
}} else
void main()
{
	auto router = new URLRouter;
	with (router) {
	    get("/forbidden", (req, res) {
            enforceHTTP(0 == 1, HTTPStatus.forbidden);
        });
	    get("/badrequest", (req, res) {
            enforceBadRequest(0, "This is a bad request");
        });
	    get("/", (req, res) {
	        throw new HTTPStatusException(HTTPStatus.forbidden, "Foo");
        });
	    get("/custom", (req, res) {
	        throw new Exception("Custom");
        });
    }

    listenHTTP(":8080", router);
    runApplication();
}
