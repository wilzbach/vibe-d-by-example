#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8"
+/
import vibe.d;
import vibe.web.auth;

struct AuthInfo {
    bool premium;
    bool admin;
    string userId;
    bool isAdmin() { return this.admin; }
    bool isPremiumUser() { return this.premium; }
}

struct Offer {
    string id;
}

@requiresAuth
class Offers {

    @noRoute
    AuthInfo authenticate(HTTPServerRequest req, HTTPServerResponse res)
    {
		if (!req.session || !req.session.isKeySet("auth"))
            throw new HTTPStatusException(HTTPStatus.forbidden, "Not authorized to perform this action!");

		return req.session.get!AuthInfo("auth");
    }

    @anyAuth
    auto getA(string offerId)
    {
        return "A";
    }

    @noAuth
    // TODO: inject AuthInfo with Nullable
    auto getB(string _offerId)
    {
        return "B";
    }

	// authUser is automatically injected based on the authenticate() result
    @auth(Role.admin | Role.premiumUser)
    auto post(Offer offer, AuthInfo auth)
    {
        return offer;
    }
}

void main() {
	auto router = new URLRouter;
	router.get("/", (req, res) {
        res.writeBody("Hello, World: " ~ req.path);
    });

    listenHTTP(":8080", router);
    runApplication();
}
