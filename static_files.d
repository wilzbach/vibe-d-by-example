#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
+/
import vibe.d;

version(unittest) {
void main() {
    import std.algorithm : startsWith;
    auto req = requestHTTP("http://localhost:8080/README.md");
    assert(req.bodyReader.readAllUTF8.startsWith("Vibe.d by Example"));
}} else
void main()
{
    auto router = new URLRouter;
    router.get("*", serveStaticFiles("./",));
    listenHTTP(":8080", router);
    runApplication();
}
