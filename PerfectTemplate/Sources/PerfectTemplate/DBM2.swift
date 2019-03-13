//
//  File.swift
//  PerfectTemplate
//
//  Created by Edward on 2019/3/8.
//

import Foundation

import PerfectLib
import PerfectHTTP
import MySQL

class DBManagerOther{
    
    static let testHost = "127.0.0.1"
    static let testUser = "root"
    static let testPassword = "yongkun"
    static let testSchema = "user_db"
    
    var dataMysql:MySQL!
    var resp:RespModel!//请求相应对象信息载体
    
    init() {
        dataMysql = MySQL() // 创建一个MySQL连接实例
        let connected =  dataMysql.connect(host: DBManager.testHost, user: DBManager.testUser, password: DBManager.testPassword, db: DBManager.testSchema)
        if connected != true{
            print("链接失败")
        }
    }
    func install(_ request:HTTPRequest,response:HTTPResponse)
    {
        resp = RespModel()
        func complate(){
            try! response.setBody(json: resp.getJSONValues())
            response.completed()
        }
        let success = dataMysql.query(statement: "select * from library")
        guard success else{
            resp.codeStatus = "获取图书信息失败"
            resp.code = 1
            complate()
            return
        }
        resp.code = 0
        resp.codeStatus = "查询成功"
        resp.data = []
        complate()
    }
    
}
