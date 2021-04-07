//
//  Model.swift
//  CurrencyCourses
//
//  Created by Dmitriy Lee on 8/13/20.
//  Copyright © 2020 LEES Entertainment. All rights reserved.
//

import UIKit

/*
<fullname>АВСТРАЛИЙСКИЙ ДОЛЛАР</fullname>
  <title>AUD</title>
  <description>95.29</description>
  <quant>1</quant>
  <index>UP</index>
  <change>0.00</change>
*/

class Currency {
    
    var title: String?
    
    var description: String?
    var descriptionDouble: Double?
    
    var quant: String?
    var quantDouble: Double?
    
    var imageFlag: UIImage? {
        if let title = title {
            return UIImage(named: title+"")
        }
        return nil
    }
    
    class func tenge() -> Currency {
        let r = Currency()
        r.title = "KZT"
        r.quant = "1"
        r.quantDouble = 1
        r.description = "1"
        r.descriptionDouble = 1
        
        return r
    }
    
}

class Model: NSObject, XMLParserDelegate {
    static let shared = Model()
    
    var currencies: [Currency] = []
    var currentDate: String = ""
    
    var fromCurrency: Currency = Currency.tenge()
    var toCurrency: Currency = Currency.tenge()
    
    func convert(amount: Double?) -> String {
        if amount == nil {
            return ""
        }
        
        let d = ( (fromCurrency.descriptionDouble! / fromCurrency.quantDouble!) / (toCurrency.descriptionDouble! / toCurrency.quantDouble!) ) * amount!
        
        return String(d)
    }
    
    var pathForXML: String {
       let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
        print(path)
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
        
        return Bundle.main.path(forResource: "data", ofType: "xml")!

    }
    
    var urlForXML: URL? {
        return URL(fileURLWithPath: pathForXML)
    }
    
    func loadXMLFile(date: Date?) {
        
        var strUrl = "https://nationalbank.kz/rss/rates_all.xml"
        
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            strUrl = strUrl+dateFormatter.string(from: date!)
        }
        let url = URL(string: strUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            var errorGlobal: String?
            
            if error == nil {
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
                let urlForSave = URL(fileURLWithPath: path)
                do {
                    try  data?.write(to: urlForSave)
                    print("Файл загружен")
                    self.parseXML()
                    
                } catch {
                    print("Error when save data: \(error.localizedDescription)")
                    errorGlobal = error.localizedDescription
                }
               
            } else {
                print("error when loadXMLFile:"+error!.localizedDescription)
                errorGlobal = error?.localizedDescription
            }
            
            if let errorGlobal = errorGlobal {
                NotificationCenter.default.post(name: NSNotification.Name("ErrorWhenXMLloading"), object: self, userInfo: ["ErrorName": errorGlobal])
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startLoadingXML"), object: self)
        
        task.resume()
    }
    
//распарсить xml и положить его в currencies: [Currency], отправить уведомление приложению о том, что данные обновились
    func parseXML() {
        currencies = [Currency.tenge()]
        
        let parser = XMLParser(contentsOf: urlForXML!)
        parser?.delegate = self
        parser?.parse()
        
        print("Данные обновлены")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataRefreshed"), object: self)
        
        for c in currencies {
            if c.title == fromCurrency.title {
                fromCurrency = c
            }
            if c.title == toCurrency.title {
                toCurrency = c
            }
        }
        
    }
    
    var currentCurrency: Currency?
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "rates" {
            if let currentDateString = attributeDict["date"] {
                currentDate = currentDateString
            }
        }

        if elementName == "item" {
            currentCurrency = Currency()
        }
    }
    
    var currentCharacters: String = ""
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCharacters = string
    }

    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if elementName == "title" {
            currentCurrency?.title = currentCharacters
        }
        
        if elementName == "quant" {
            currentCurrency?.quant = currentCharacters
            currentCurrency?.quantDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        
        if elementName == "description" {
            currentCurrency?.description = currentCharacters
            currentCurrency?.descriptionDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        
        if elementName == "item" {
            currencies.append(currentCurrency!)
        }
    }
}
