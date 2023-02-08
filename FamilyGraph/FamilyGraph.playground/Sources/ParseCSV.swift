import Foundation

class ParseCSV {
    
    func CSVParsingPeople(fileName: String,fileExtension: String,model: Model) -> [Any]{
        var formattedData = [[String]]()
        
        let filepath = Bundle.main.path(forResource: fileName, ofType: fileExtension)
        
        do{
            let resultData = try String(contentsOfFile: filepath ?? "")
            let rows = resultData.components(separatedBy: "\n")
            
            for i in rows {
                let columns = i.components(separatedBy: ",")
                formattedData.append(columns)
            }
            formattedData.removeLast()
            
            switch model {
                case .People:
                    var peopleData = [People]()
                    for i in formattedData {
                        peopleData.append(People(name: i[0],email: i[1],age: Int(i[2]) ?? 0))
                    }
                    return peopleData as [People]
                
                case .Relationships:
                    var relationshipsData = [Relationships]()
                    for i in formattedData{
                        relationshipsData.append(Relationships(email: i[0],relation: i[1],email2: String(i[2])))
                    }
                    return relationshipsData as [Relationships]
            }
            
            
        } catch{
            print("---Error---")
            print(error)
            
        }
        return [model]
    }
    
    
}
