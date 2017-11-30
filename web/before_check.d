#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8.2"
+/
import vibe.d;

struct AuthInfo {
    string username;
}

private AuthInfo checkAuth(HTTPServerRequest req, HTTPServerResponse res)
{
    import std.algorithm : startsWith;
    import std.random : choice;
    if (!req.path.startsWith("/auth")) throw new HTTPStatusException(HTTPStatus.forbidden, "Not authorized to perform this action!");
    AuthInfo auth = {username: ["peter", "parker", "spiderman"].choice};
    return auth;
}

private enum auth = before!checkAuth("_auth");

class UserService {
    // GET /
    @auth
    void get(AuthInfo _auth, HTTPServerResponse res) {
        res.writeBody(_auth.username);
    }

    // GET /auth
    @auth
    void getAuth(AuthInfo _auth, HTTPServerResponse res) {
        res.writeBody(_auth.username);
    }
}

version(unittest) {
void main() {
    import std.algorithm : among;
    import std.stdio;
    auto req = requestHTTP("http://localhost:8080");
    assert(req.statusCode == HTTPStatus.forbidden);
    req.dropBody;

    assert(requestHTTP("http://localhost:8080/auth").bodyReader.readAllUTF8.among("peter", "parker", "spiderman"));
}} else
void main()
{
	auto router = new URLRouter;
    router.registerWebInterface(new UserService());

    listenHTTP(":8080", router);

    runApplication();
}
