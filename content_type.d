/+ dub.sdl:
dependency "vibe-d" version="~>0.8.2"
+/
import vibe.d;

class UserService {

    // GET /
    @contentType("image/svg+xml")
    void get(HTTPServerResponse res) {
        res.writeBody(`<svg><circle fill="blue" /></svg>`);
    }

    // GET /foo
    @contentType("image/svg+xml")
    void getFoo(HTTPServerResponse res) {
        res.writeBody(`<svg><circle fill="red" /></svg>`);
    }
}

version(unittest) {
void main() {
    requestHTTP("http://localhost:8080/", (scope req) {}, (scope res) {
        //assert(res.headers["Content-Type"] == "image/svg+xml");
        assert(res.bodyReader.readAllUTF8 == `<svg><circle fill="blue" /></svg>`);
    });
}} else
void main()
{
	auto router = new URLRouter;
    router.registerWebInterface(new UserService());

    listenHTTP(":8080", router);
    runApplication();
}
