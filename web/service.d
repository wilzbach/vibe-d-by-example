#!/usr/bin/env dub
/+ dub.sdl:
dependency "vibe-d" version="~>0.8.2"
+/
import vibe.d;
import vibe.web.auth;

struct AuthInfo {}

@path("/issues")
class Issues
{
    AuthInfo authenticate(HTTPServerRequest req, HTTPServerResponse res)
    {
        if (!req.session || !req.session.isKeySet("auth"))
            throw new HTTPStatusException(HTTPStatus.forbidden, "Not authorized to perform this action!");
        return req.session.get!AuthInfo("auth");
    }

    MongoCollection m_issues;

    this(MongoDatabase db)
    {
        m_issues = db["issues"];
    }

    @noAuth {
        auto index(HTTPServerRequest req)
        {
            import std.algorithm, std.range;
            Bson filter = Bson.emptyObject;
            if (auto search = "search" in req.query)
            {
                auto searchQuery = Bson([
                    "$regex": Bson(".*" ~ *search ~".*"),
                    "$options": Bson("i")
                ]);
                import std.ascii : isDigit;
                auto arr = [Bson(["blob.body": searchQuery]), Bson(["blob.title": searchQuery])];
                if ((*search).all!isDigit)
                    arr ~= Bson(["blob.number": Bson((*search).to!long)]);
                filter["$or"] = Bson(arr);
            }
            filter["blob.state"] = "open";
            return m_issues.find(filter).sort(["blob.created_at": -1]).take(15).map!(deserializeBson!Json).array;
        }

        auto get(string _issueId)
        {
            Json json;
            auto b = m_issues.findOne(["aid": _issueId]);
            if (b.length > 0)
                json = b.deserializeBson!Json;
            return json;
        }
    }

    //@anyAuth
    @noAuth
    @path("/:issueId/take")
    auto take(string _issueId, /*AuthInfo auth*/)
    {
        import std.datetime : Clock, DateTime;

        import std.stdio;
        writeln("_issueId: ", _issueId);
        auto b = m_issues.findOne(["aid": _issueId]);
        writeln(b.length);
        if (b.length > 0)
        {
            if (!b.tryIndex("takenBy").isNull) {
                enforceHTTP(0, HTTPStatus.badRequest, "already assigned");
            }
            Bson set = Bson.emptyObject;
            set["takenAt"] = BsonDate(Clock.currTime);
            //set["takenBy"] = auth.userId;
            m_issues.update(["aid": _issueId], [
                "$set": set
            ]);
        } else {
            enforceHTTP(0, HTTPStatus.notFound, "Invalid item");
        }
        return "ok";
    }
}

void main()
{
	auto router = new URLRouter;
    router.get("/", (req, res) {
            res.writeBody("Hello, World: " ~ req.path);
    });

    auto serviceSettings = new WebInterfaceSettings();
    serviceSettings.urlPrefix = "/api";
    serviceSettings.ignoreTrailingSlash = true; // true: overloads for trailing /
    //router.registerWebInterface(new Issues(mongoDB), serviceSettings);

    listenHTTP(":8080", router);
    runApplication();
}
