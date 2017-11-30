#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8.2"
+/
import vibe.d;

class UserService {

    // _error parameter is accepted (see postLogin)
    void getLogin(HTTPServerResponse res, string _error = null)
    {
        string error = _error;
        res.writeBody("ERROR");
    }

    @errorDisplay!getLogin:

    // GET /
    auto get() {
        enforce(0 == 1, "Invalid state");
    }
}

version(unittest) {
void main() {
    assert(requestHTTP("http://localhost:8080/").bodyReader.readAllUTF8 == "ERROR");
}} else
void main()
{
	auto router = new URLRouter;
    router.registerWebInterface(new UserService());

    listenHTTP(":8080", router);
    runApplication();
}
