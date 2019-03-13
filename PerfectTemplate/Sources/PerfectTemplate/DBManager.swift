//
//  DBManager.swift
//  PerfectTemplate
//
//  Created by Edward on 2019/3/5.
//


import Foundation
import PerfectLib
import PerfectHTTP
import MySQL

class DBManager{
    
    static let testHost = "47.96.127.89:54432"
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
    
    
    
    //上传菜品
    func updatedatacai(_ request:HTTPRequest,response:HTTPResponse) {
        
        resp=RespModel()
        func complate()->Void{
            try! response.setBody(json: resp.getJSONValues())
            response.completed()
        }
        //1 获取post上来的数据
        let name = request.param(name: "name")
        let guige = request.param(name: "guige")
        let jinhuojia = request.param(name: "jinhuojia")
        let shoujia = request.param(name: "shoujia")
        let shuliang = request.param(name: "shuliang")
        
        if(name == nil || guige == nil || jinhuojia == nil || shoujia == nil || shuliang == nil)
        {
            if(name==nil)
            {
                resp.codeStatus = "缺少name参数"
                resp.code = 1
                complate()
                return
            }
            if(guige==nil)
            {
                resp.codeStatus = "缺少guige参数"
                resp.code = 1
                complate()
                return
            }
            if(jinhuojia==nil)
            {
                resp.codeStatus = "缺少jinhuojia参数"
                resp.code = 1
                complate()
                return
            }
            if(shoujia==nil)
            {
                resp.codeStatus = "缺少shoujia参数"
                resp.code = 1
                complate()
                return
            }
            if(shuliang==nil)
            {
                resp.codeStatus = "缺少shuliang参数"
                resp.code = 1
                complate()
                return
            }
            resp.codeStatus = "缺少参数"
            resp.code = 1
            complate()
            return
        }
        
        //2  把这个参数 写入数据库
        let cha = dataMysql.query(statement: "select c_name,c_guige from caishi")    //向mysql输入sql语句
        guard cha else{
            resp.codeStatus = "查询菜式错误"
            resp.code = 1
            complate()
            return
        }
        let res = dataMysql.storeResults() //获得执行sql语句之后的返回值
        
        var resultA = [[String?]]()
        while let row = res?.next() {
            var a = [row[0],row[1]]
            resultA.append(a)
            a.removeAll()
        }
        if (resultA.count == 0){
            let success = dataMysql.query(statement: "insert into caishi(c_name,c_guige,c_jinhuo,c_shouhuo,c_shuliang1,c_shuliang2) values ('\(name!)','\(guige!)','\(jinhuojia!)','\(shoujia!)','\(shuliang!)','\(shuliang!)');")
            guard success else{
                resp.codeStatus = "菜式插入错误"
                resp.code = 1
                complate()
                return
            }
        }else{
            for item in 0...resultA.count-1{
                if (resultA[item][0] == name! && resultA[item][1] == guige!){
                    let a = UpdataData(o_name: name!, n_name: name!, n_guige: guige!, n_jinhuo: jinhuojia!, n_shouhuo: shoujia!, n_shuliang: shuliang!)
                    if (a){
                        resp.code = 0
                        resp.codeStatus = "菜式修改成功"
                        complate()
                        return
                    }
                    resp.code = 1
                    resp.codeStatus = "修改失败"
                    return
                    
                }
                
            }
            let success = dataMysql.query(statement: "insert into caishi(c_name,c_guige,c_jinhuo,c_shouhuo,c_shuliang1,c_shuliang2) values ('\(name!)','\(guige!)','\(jinhuojia!)','\(shoujia!)','\(shuliang!)','\(shuliang!)')")
            guard success else{
                resp.codeStatus = "菜式插入错误"
                resp.code = 1
                complate()
                return
            }
            
        }
        resp.code = 0
        resp.codeStatus = "插入成功"
        complate()
    }
    func UpdataData(o_name:String,n_name:String,n_guige:String,n_jinhuo:String,n_shouhuo:String,n_shuliang:String) ->Bool{
        let para="update caishi set c_name='\(n_name)',c_guige='\(n_guige)',c_jinhuo='\(n_jinhuo)',c_shouhuo='\(n_shouhuo)',c_shuliang1='\(n_shuliang)',c_shuliang2='\(n_shuliang)' where c_name='\(o_name)' and c_guige='\(n_guige)';"
        let update = dataMysql.query(statement: para)
        guard update else{
            resp.codeStatus = "菜式更新失败"
            return false
        }
        return true
    }
    
    
    //获取菜品 可以
    func logincai(_ request:HTTPRequest,response:HTTPResponse) {
        resp=RespModel()
        func complate()->Void{
            try! response.setBody(json: resp.getJSONValues())
            response.completed()
        }
        //1 将foo表所有数据返回   通过访问login接口 就可以获取foo的数据
        
        let success = dataMysql.query(statement: "select * from caishi")
        guard success else{
            resp.codeStatus = "获取菜品sal语句错误"
            resp.code = 1
            complate()
            return
        }
        let res = dataMysql.storeResults()
        var resultA = [[String:Any]]()
        while let row = res?.next() {
            var dic:[String:Any]=[:]
            dic["name"]=row[1]
            dic["guige"]=row[2]
            dic["jinhuojia"]=row[3]
            dic["shoujia"]=row[4]
            dic["shuliang"]=row[5]
            resultA.append(dic)
            dic.removeAll()
        }
        res?.close()
        
        
        resp.code = 0
        resp.codeStatus = "查询成功"
        resp.data = resultA
        complate()
    }
    
    //删除菜品
    func delectcai(_ request:HTTPRequest,response:HTTPResponse){
        resp=RespModel()
        func complate()->Void{
            try! response.setBody(json: resp.getJSONValues())
            response.completed()
        }
        //设置数据库语言
        let name = request.param(name: "name")
        let guige = request.param(name: "guige")
        
        let success2 = dataMysql.query(statement: "delete from caishi where c_name='\(name!)' and c_guige='\(guige!)';")
        guard success2 else{
            resp.codeStatus = "删除菜品sql语句错误"
            resp.code = 1
            complate()
            return
        }
        let res3 = dataMysql.storeResults()
        res3?.close()
        
        resp.code = 0
        resp.codeStatus = "删除成功"
        complate()
        
    }
    
    //新增售货员
    func updatedatashou(_ request:HTTPRequest,response:HTTPResponse) {
        resp=RespModel()
        func complate()->Void{
            try! response.setBody(json: resp.getJSONValues())
            response.completed()
        }
        //1 获取post上来的数据  修改哪个表数据啊 foo吧    把 5  修改成duan 吧
        let name = request.param(name: "name")
        let count = request.param(name: "count")
        let pass = request.param(name: "pass")
        let quanxian = request.param(name: "quanxian")
        
        if(name == nil || count == nil || pass == nil || quanxian == nil)
        {
            if(name==nil)
            {
                resp.codeStatus = "缺少name参数"
                resp.code = 1
                complate()
                return
            }
            if(count==nil)
            {
                resp.codeStatus = "缺少count参数"
                resp.code = 1
                complate()
                return
            }
            if(pass==nil)
            {
                resp.codeStatus = "缺少pass参数"
                resp.code = 1
                complate()
                return
            }
            if(quanxian==nil)
            {
                resp.codeStatus = "缺少quanxian参数"
                resp.code = 1
                complate()
                return
            }
        }
        //2  把这个参数 写入数据库
        
        //        let success = dataMysql.query(statement: "insert into shouhuoyuan(user_name,user_count,user_pass,quanxian) values ('\(name!)','\(count!)','\(pass!)','\(quanxian!)');")
        //        guard success else{
        //            resp.codeStatus = "mysql错误"
        //            resp.code = 1
        //            complate()
        //            return
        //        }
        let cha1 = dataMysql.query(statement: "select user_name,user_count from shouhuoyuan ")
        guard cha1 else{
            resp.codeStatus = "获取店员sql语句错误"
            resp.code = 1
            complate()
            return
        }
        let res1 = dataMysql.storeResults()
        var resultA1 = [[String?]]()
        while let row = res1?.next() {
            var a = [row[0],row[1]]
            resultA1.append(a)
            a.removeAll()
        }
        if (resultA1.count == 0){
            let success = dataMysql.query(statement: "insert into shouhuoyuan(user_name,user_count,user_pass,quanxian) values ('\(name!)','\(count!)','\(pass!)','\(quanxian!)');")
            guard success else{
                resp.codeStatus = "插入店员错误"
                resp.code = 1
                complate()
                return
            }
        }else{
            for item in 0...resultA1.count-1{
                if(resultA1[item][0] == name! && resultA1[item][1] == count!){
                    let a = UpdataShou(username: name!, usercount: count!, userpass: pass!, quanxian: quanxian!)
                    if(a){
                        resp.code = 0
                        resp.codeStatus = "修改店员信息成功"
                        complate()
                        return
                    }
                    resp.code = 1
                    resp.codeStatus = "修改店员信息失败"
                    complate()
                    return
                }
            }
            let success1 = dataMysql.query(statement: "insert into shouhuoyuan(user_name,user_count,user_pass,quanxian) values ('\(name!)','\(count!)','\(pass!)','\(quanxian!)');")
            guard success1 else{
                resp.codeStatus = "新增店员失败"
                resp.code = 1
                complate()
                return
            }
            
        }
        res1?.close()
        resp.code = 0
        resp.codeStatus = "success"
        complate()
    }
    func UpdataShou(username:String,usercount:String,userpass:String,quanxian:String)->Bool{
        let para = "update shouhuoyuan set user_name='\(username)',user_count='\(usercount)',user_pass='\(userpass)',quanxian='\(quanxian)' where user_name='\(username)' and user_count='\(usercount)';"
        let update = dataMysql.query(statement: para)
        guard update else{
            return false
        }
        return true
    }
    //获取售货员
    func selshou(_ request:HTTPRequest,response:HTTPResponse) {
        resp=RespModel()
        func complate()->Void{
            try! response.setBody(json: resp.getJSONValues())
            response.completed()
        }
        //1 将foo表所有数据返回   通过访问login接口 就可以获取foo的数据
        
        let success11 = dataMysql.query(statement: "select * from shouhuoyuan")
        guard success11 else{
            resp.codeStatus = "获取售货员信息错误"
            resp.code = 1
            complate()
            return
        }
        let res12 = dataMysql.storeResults()
        var resultA12 = [[String:Any]]()
        while let row = res12?.next() {
            var dic:[String:Any]=[:]
            dic["name"]=row[1]
            dic["count"]=row[2]
            dic["pass"]=row[3]
            dic["quanxian"]=row[4]
            resultA12.append(dic)
            dic.removeAll()
        }
        res12?.close()
        resp.code = 0
        resp.codeStatus = "获取成功"
        resp.data = resultA12
        complate()
    }
    //删除售货员
    func delshou(_ request:HTTPRequest,response:HTTPResponse){
        resp=RespModel()
        func complate()->Void{
            try! response.setBody(json: resp.getJSONValues())
            response.completed()
        }
        //设置数据库语言
        let name = request.param(name: "name")
        let count = request.param(name: "count")
        
        let success13 = dataMysql.query(statement: "delete from shouhuoyuan where user_name='\(name!)' and user_count='\(count!)';")
        guard success13 else{
            resp.codeStatus = "删除售货员错误"
            resp.code = 1
            complate()
            return
        }
        let res13 = dataMysql.storeResults()
        res13?.close()
        resp.code = 0
        resp.codeStatus = "删除成功"
        complate()
        
    }
    
    
    
    
}


