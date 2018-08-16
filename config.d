#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
+/
import vibe.d;

version(unittest) {
void main() {
    HTTPClient.setUserAgentString("Awesome D");

    auto req = requestHTTP("http://localhost:8080/");
    assert(req.headers["Server"] == "Amazing D server");
    assert(req.bodyReader.readAllUTF8 == "Hello, World: Awesome D");
}} else
void main()
{
    auto settings = new HTTPServerSettings;
    settings.serverString = "Amazing D server";
    settings.port = 8080;
    listenHTTP(settings, (req, res) {
        res.writeBody("Hello, World: " ~ req.headers["User-Agent"]);
    });
    runApplication();
}
