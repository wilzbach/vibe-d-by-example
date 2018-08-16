#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
+/
import vibe.d;

version(unittest) {
void main() {
    auto req = requestHTTP("http://localhost:8080");
    assert(req.bodyReader.readAllUTF8 == "Hello, World: /");
}} else
void main()
{
    listenHTTP(":8080", (req, res) {
        res.writeBody("Hello, World: " ~ req.path);
    });
    runApplication();
}
