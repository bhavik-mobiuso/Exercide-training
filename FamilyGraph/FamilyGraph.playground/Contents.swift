import Foundation

// constants

let family = "FAMILY"

enum Model {
    
    case People
    case Relationships
}

struct People {
    
    var name:String = ""
    var email:String = ""
    var age:Int = 0
}
struct Relationships {
    
    var email:String = ""
    var relation:String = ""
    var email2:String = ""
}


/*
func passModel <T> (modelType: T.Type) {
    print(modelType)
    let arr = [modelType]
}

passModel(modelType: [People].self)
*/

var peopleData = [People] ()
var relationshipsData = [Relationships] ()

CSVParsingPeople(fileName: "people", fileExtension: "csv",delimiter: ",")
CSVParsingRelationships(fileName: "relationships", fileExtension: "csv",delimiter: ",")


func CSVParsingPeople(fileName: String,fileExtension: String,delimiter: String){
    var formattedData = [[String]]()
        
    let filepath = Bundle.main.path(forResource: fileName, ofType: fileExtension)
    
    do{
        let resultData = try String(contentsOfFile: filepath ?? "")
            let rows = resultData.components(separatedBy: "\n")
              for i in rows {
                  let columns = i.components(separatedBy: delimiter)
                  formattedData.append(columns)
              }
              formattedData.removeLast()

              for i in formattedData{
                  peopleData.append(People(name: i[0],email: i[1],age: Int(i[2]) ?? 0))

              }
          
      } catch{
        print("---Error---")
        print(error)
        
      }
}

func CSVParsingRelationships(fileName: String,fileExtension: String,delimiter: String) {
    var formattedData = [[String]]()
        
    let filepath = Bundle.main.path(forResource: fileName, ofType: fileExtension)
    
    do{
        let resultData = try String(contentsOfFile: filepath ?? "")
            let rows = resultData.components(separatedBy: "\n")
            
              for i in rows {
                  let columns = i.components(separatedBy: delimiter)
                  formattedData.append(columns)
              }
              for i in formattedData{
                  relationshipsData.append(Relationships(email: i[0],relation: i[1],email2: i[2]))
              }
          
      } catch{
        print("---Error---")
        print(error)
      }
}
print("Exercise - 2 Validate correct people loaded.")

print("\nTotal \(peopleData.count) No. Of People Loaded")
print("\nPeople Data\n")

for i in peopleData {
    print(i)
}


print("\nRelationship Data\n")
for i in relationshipsData {
    print(i)
}

print("\nExercise - 3 Validate correct relationships loaded.")
print("\nTest for checking correct relationship\n")
func checkRelations(name: String, noOfRelation: Int) {
    var count = 0
    for people in peopleData {
        for relationship in relationshipsData {
            if people.email == relationship.email || people.email == relationship.email2 {
                count = count + 1
            }
        }
        if people.name == name {
            if noOfRelation == count {
                print("Test For \(name) is correct")
            }
            else {
                print("Test For \(name) is incorrect")
            }
        }
        count = 0
    }
}
checkRelations(name: "Bob", noOfRelation: 4)
checkRelations(name: "Jenny", noOfRelation: 3)
checkRelations(name: "Nigel", noOfRelation: 2)
checkRelations(name: "Alan", noOfRelation: 0)


print("\nExercise - 4 Write a method that calculates the size of the extended family\n")

func countFamilyMembers(name: String) -> Int {

    var count = 0 // counter variable for family members
    var tmpEmails = [String]()//Family Members Email id
    tmpEmails.removeAll()
    for people in peopleData {
        
        if people.name == name {
            count = count + 1// Include Member himself/herself
            for relationship in relationshipsData {
                
                if (people.email == relationship.email || people.email == relationship.email2 && relationship.relation == family){
                    count = count + 1
                    tmpEmails.append(relationship.email2)
                }
                else {
                    if tmpEmails.contains(relationship.email) && relationship.relation == family && !tmpEmails.contains(relationship.email2) {
                        print("Another Member Found In \(people.name)'s Family")
                    }
                    else if !tmpEmails.contains(relationship.email) && relationship.relation == family && tmpEmails.contains(relationship.email2) {
                        print("Another Member Found In \(people.name)'s Family - \(relationship.email)")
                        count = count + 1
                    }
                }
            }
        }
    }
    return count
}

let jennyCount = countFamilyMembers(name: "Jenny")
let bobCount = countFamilyMembers(name: "Bob")

print("Jenny (\(jennyCount) members)")
print("Bob (\(bobCount) members)")
