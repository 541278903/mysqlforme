//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectHTTP
import PerfectHTTPServer
//import MySQL
import MySQL
func handler(request: HTTPRequest, response: HTTPResponse) {
	// Respond with a simple message.
	response.setHeader(.contentType, value: "text/html")
  response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
	// Ensure that response.completed() is called when your processing is done.
	response.completed()
}
let server = HTTPServer()
let request = HTTPRequest.self
let response = HTTPResponse.self
func login() -> RequestHandler{
    return{
        request,response in
        let a = DBManager()
        a.logincai(request, response: response)
    }
}

func delcai() -> RequestHandler{
    return{
        request,response in
        let a = DBManager()
        a.delectcai(request, response: response)
    }
}
func newshou() -> RequestHandler{
    return{
        request,response in
        let a = DBManager()
        a.updatedatashou(request, response: response)
    }
}
func selshou() -> RequestHandler{
    return{
        request,response in
        let a = DBManager()
        a.selshou(request, response: response)
    }
}
func delshou() -> RequestHandler{
    return{
        request,response in
        let a = DBManager()
        a.delshou(request, response: response)
    }
}
func updateData() -> RequestHandler
{
    return { request, response in
        let a = DBManager()
        a.updatedatacai(request, response: response)
    }
}
func SeLibrary()->RequestHandler{
    return {
        request,response in
        let a = DBManagerOther()
        a.install(request, response: response)
    }
}

var routes = Routes()
routes.add(method: .get, uri: "/", handler: handler)
routes.add(method: .post, uri: "/yan/library", handler: SeLibrary())
routes.add(method: .get, uri: "/login/library", handler: SeLibrary())
routes.add(method: .post, uri: "/yan/login", handler: login())
routes.add(method: .get, uri: "/login/cai", handler: login())
routes.add(method: .post, uri: "/yan/newcai", handler: updateData())
routes.add(method: .post, uri: "/yan/delcai", handler: delcai())
routes.add(method: .post, uri: "/yan/newshou", handler: newshou())
routes.add(method: .post, uri: "/yan/selshou", handler: selshou())
routes.add(method: .get, uri: "/login/shou", handler: selshou())
routes.add(method: .post, uri: "/yan/delshou", handler: delshou())
routes.add(method: .get, uri: "/**",
		   handler: StaticFileHandler(documentRoot: "./webroot", allowResponseFilters: true).handleRequest)
try HTTPServer.launch(name: "localhost",
					  port: 8181,
					  routes: routes,
					  responseFilters: [
						(PerfectHTTPServer.HTTPFilter.contentCompression(data: [:]), HTTPFilterPriority.high)])

