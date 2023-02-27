import Foundation

final class CSVParser {
    var peopleData = [People]()
    var rawData = [[String]]()
    
    func loadCsv(fileName: String,fileExtension: String,model: Model,delimiter: String) -> [Any]{
        
        let filepath = Bundle.main.path(forResource: fileName, ofType: fileExtension)
        
        do{
            let content = try String(contentsOfFile: filepath ?? "")
            let rows = content.components(separatedBy: "\n")
            
            for i in rows {
                let columns = i.components(separatedBy: delimiter)
                rawData.append(columns)
            }
            
            switch model {
            case .People:
                var peopleData = [People]()
                for i in rawData {
                    peopleData.append(People(name: i[0],email: i[1],age: Int(i[2]) ?? 0))
                }
                return peopleData
                
            case .Relationships:
                var relationshipsData = [Relation]()
                for i in rawData{
                    relationshipsData.append(Relation(email: i[0],relation: i[1],email2: i[2]))
                }
                return relationshipsData
            }
            
        } catch{
            print(error)
        }
        return []
    }
    
    
    typealias  Handler <T> = (Result<T,CSVParseError>) -> Void
    
    func readCSV <T> (fileName: String, fileExtension: String,delimiter: String, modelType: Model,completion: @escaping Handler<T>) {
        let filepath = Bundle.main.path(forResource: fileName, ofType: fileExtension)
        
        do{
            let content = try String(contentsOfFile: filepath ?? "")
            let rows = content.components(separatedBy: "\n")
            
            for i in rows {
                let columns = i.components(separatedBy: delimiter)
                rawData.append(columns)
            }
            
            switch modelType {
            case .People:
                var peopleData = [People]()
                for i in rawData {
                    peopleData.append(People(name: i[0],email: i[1],age: Int(i[2]) ?? 0))
                }
                completion(.success(peopleData as! T))
                
            case .Relationships:
                var relationshipsData = [Relation]()
                for i in rawData{
                    relationshipsData.append(Relation(email: i[0],relation: i[1],email2: i[2]))
                }
                completion(.success(relationshipsData as! T))
            }
            
        } catch{
            completion(.failure(.FileNotFound))
        }
    }
}
