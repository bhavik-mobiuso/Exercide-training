import Foundation

class FamilyGraphOperation {

    var count = 0
    
    func countFamilyMembers(name: String,peopleCollection: [People],relationhipsCollection: [Relation]) -> Int {
        var peopleData = peopleCollection
        var relationshipsData = relationhipsCollection
        var tmpEmails = [String]() // family members email id
        tmpEmails.removeAll()
        
        for people in peopleData {
        
            if people.name == name {

                count = count + 1// include member himself/herself
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
    func checkRelations(name: String, noOfRelation: Int,peopleCollection: [People],relationhipsCollection: [Relation]) {
        
        var peopleData = peopleCollection
        var relationshipsData = relationhipsCollection
        
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
