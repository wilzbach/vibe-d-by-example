#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
dependency "vibe-d:tls" version="~>0.8"
subConfiguration "vibe-d:tls" "botan"
+/
import vibe.d;

@path("/users")
class UserService {

    // POST /dothis
    @method(HTTPMethod.POST)
    void doThis(string _bar) {
    }

    @path("/foo/:bar")
    void getFoo(string _bar) {
    }
}

version(unittest) {
void main() {
    assert(requestHTTP("http://localhost:8080/").bodyReader.readAllUTF8 == "Hello, World: /");
}} else
void main()
{
	auto router = new URLRouter;
    router.registerWebInterface(new UserService());

    listenHTTP(":8080", router);

    import std.algorithm : canFind;
    foreach (route; router.getAllRoutes)
        if ([HTTPMethod.POST, HTTPMethod.GET, HTTPMethod.PUT].canFind(route.method))
            logInfo("%s: %s", route.pattern, route.method);

    runApplication();
}
