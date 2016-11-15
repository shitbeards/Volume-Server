import Vapor

let drop = Droplet()

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("books") { request in
    guard let query = request.data["query"]?.string else {
        throw Abort.badRequest
    }
    let thing = try drop.client.get("\(drop.config["google-books", "api-base-url"]!.string!)/volumes", query: [
        "q": query,
        "key": drop.config["google-books", "api-key"]!.string!
    ])
    return thing
}

drop.get("test") { request in
    return try drop.client.get("\(drop.config["google-books", "test"]!.string!)")
}

drop.resource("posts", PostController())

drop.run()
