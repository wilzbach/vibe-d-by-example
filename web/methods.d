#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
dependency "vibe-d:tls" version="~>0.8"
subConfiguration "vibe-d:tls" "botan"
+/
import vibe.d;

class UserService {

    // POST /do_this
    @method(HTTPMethod.POST)
    auto doThis(string bar) {
        response.writeBody("bar="~bar);
    }
}

version(unittest) {
void main() {
    requestHTTP("http://localhost:8080/do_this?bar=bar2", (scope req) {
        req.method = HTTPMethod.POST;
    }, (scope res) {
        import std.stdio;
        assert(res.bodyReader.readAllUTF8 == "bar=bar2");
    });
}
} else
void main() {
	auto router = new URLRouter;
    router.registerWebInterface(new UserService);

    listenHTTP(":8080", router);
    runApplication();
}
