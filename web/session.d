#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
dependency "requests" version="~>0.6.0"
subConfiguration "requests" "vibed"
+/
import vibe.d;

// Open this example in your browser and reload/refresh the page multiple times
// http://localhost:8080
class UserService {

    private {
        SessionVar!(int, "visits") m_visits;
    }
    // GET /
    void get(HTTPServerRequest req, HTTPServerResponse res) {
        res.writeBody(m_visits.to!string);
        m_visits = m_visits + 1;
    }
}


version(unittest) {
import requests;
void main() {
    // Cookies are saved in the request object
    auto rq = Request();
    foreach (i; 0 .. 3)
    {
        import std.conv : to;
        auto rs = rq.get("http://localhost:8080");
        assert(rs.responseBody == i.to!string);
    }
}} else
void main()
{
	auto router = new URLRouter;
    router.registerWebInterface(new UserService());

    auto settings = new HTTPServerSettings(":8080");
    settings.sessionStore = new MemorySessionStore;
    listenHTTP(settings, router);
    runApplication();
}
