//
//  RespModel.swift
//  PerfectTemplate
//
//  Created by Edward on 2019/3/5.
//

import PerfectLib
import PerfectHTTP

class RespModel: JSONConvertibleObject {
    static let registerName = "resp"
    var code = 0
    var data = [[String:Any]]()
    var codeStatus = "链接成功"
    var mysql = ""
    
    override func setJSONValues(_ values: [String : Any]) {
        self.code = getJSONValue(named: "code", from: values, defaultValue: 0)
        self.data = getJSONValue(named: "data", from: values, defaultValue: [[:]])
        self.codeStatus = getJSONValue(named: "codeStatus", from: values, defaultValue: "链接成功")
        self.mysql = getJSONValue(named: "mysql", from: values, defaultValue: "1")
    }
    
    override func getJSONValues() -> [String : Any] {
        return[
            "code":code,
            "data":data,
            "codeStatues":codeStatus,
            "mysql":mysql,
        ]
    }
}

