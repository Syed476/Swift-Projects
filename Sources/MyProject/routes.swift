import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.get("webpage") { req -> Response in
        let html = """
        <html>
        <head><title>My Swift Web App</title></head>
        <body>
            <h1>Welcome to My Swift Web App</h1>
            <p>This is a basic HTML page served by Vapor.</p>
        </body>
        </html>
        """
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "text/html; charset=utf-8")
        return Response(status: .ok, headers: headers, body: .init(string: html))
    }
}

