import Foundation

class FamilyGraphOperaion {
    
    static let obj = FamilyGraphOperaion()
    var parseObj = ParseCSV()
    
    func retriveData() {
        var peopleData = parseObj.CSVParsingPeople(fileName: "people", fileExtension: "csv", model: Model.People)
        var relationshipsData = parseObj.CSVParsingPeople(fileName: "relationships", fileExtension: "csv", model: Model.Relationships)
        
    }
    func countFamilyMembers(name: String) -> Int {

        var count = 0 // counter variable for family members
        var tmpEmails = [String]()//Family Members Email id
        tmpEmails.removeAll()
        for people in peopleData {
            
            if people.name == name {
                count = count + 1// Include Member himself/herself
                for relationship in relationshipsData {
                    
                    if (people.email == relationship.email || people.email == relationship.email2 && relationship.relation == "FAMILY"){
                        count = count + 1
                        tmpEmails.append(relationship.email2)
                    }
                    else {
                        if tmpEmails.contains(relationship.email) && relationship.relation == "FAMILY" && !tmpEmails.contains(relationship.email2) {
                            print("Another Member Found In \(people.name) Family")
                        }
                        else if !tmpEmails.contains(relationship.email) && relationship.relation == "FAMILY" && tmpEmails.contains(relationship.email2) {
                            print("Another Member Found In \(people.name) Family - \(relationship.email)")
                            count = count + 1
                        }
                    }
                }
            }
        }
        return count
    }
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
}
