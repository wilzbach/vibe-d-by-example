#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
dependency "vibe-d:tls" version="~>0.8"
subConfiguration "vibe-d:tls" "botan"
+/
import vibe.d;

struct TestStruct
{
    int value;
}

class UserService {

    // GET /do_this
    @method(HTTPMethod.GET)
    auto doThis(string bar) {
        response.writeBody("bar="~bar);
    }

    // POST /do_that
    @method(HTTPMethod.POST)
    auto doThat() {
        import std.conv : text;
        auto test = request.json.deserializeJson!TestStruct;
        response.writeBody(text("test=", test.value));
    }
}

version(unittest) {
void main() {
    import std.stdio;
    requestHTTP("http://localhost:8080/do_this?bar=bar2", (scope req) {},
    (scope res) {
        assert(res.bodyReader.readAllUTF8 == "bar=bar2");
    });
    requestHTTP("http://localhost:8080/do_that", (scope req) {
        req.method = HTTPMethod.POST;
        TestStruct(42).serializeToJsonString.writeln;
        req.writeJsonBody(TestStruct(42).serializeToJson);
    }, (scope res) {
        assert(res.bodyReader.readAllUTF8 == "test=42");
    });
}
} else
void main() {
	auto router = new URLRouter;
    router.registerWebInterface(new UserService);

    listenHTTP(":8080", router);
    runApplication();
}
