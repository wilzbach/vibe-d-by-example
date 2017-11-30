#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8.2"
+/
import vibe.d;

class UserService {

    // POST /do_this
    @method(HTTPMethod.POST)
    auto doThis(string _bar) {
        response.writeBody("Foo");
    }
}

version(unittest) {
void main() {
    requestHTTP("http://localhost:8080/do_this?bar=foo", (scope req) {
        req.method = HTTPMethod.POST;
        req.bodyWriter.write("...");
    }, (scope res) {
        import std.stdio;
        res.bodyReader.readAllUTF8.writeln;
        //assert(res.bodyReader.readAllUTF8 == "Foo");
    });
}
} else
void main() {
	auto router = new URLRouter;
    router.registerWebInterface(new UserService);

    listenHTTP(":8080", router);
    runApplication();
}
