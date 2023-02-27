import Foundation

class Main {
    
    // intiallize class objects
    var csvParser = CSVParser()
    var familyGraph = FamilyGraphOperation()
    var people = [People]()
    var relation = [Relation]()
    
    func exercises() {
        
        print("Exercise - 1  Please implement code and data structures that read the files")
        
        csvParser.readCSV(fileName: "people", fileExtension: "csv", delimiter: ",", modelType: Model.People) { data in
            switch data {
            case .success(let data):
                self.peopleData = data
                
            case .failure(let error):
                print(error)
            }
        
            for i in 0...data.count - 1{
                
                let people = data[i] as! People
                people[i].name = people.name
                people[i].email = people.email
                people[i].age = people.age
                
            }
        }

            
            
             
        print("Exercise - 2 Validate correct people loaded.")
        
            print("\nTotal \(people.count) No. Of People Loaded")
            print("\nPeople Data\n")
            for people in people {
                print(people)
            }
            print("\nRelationship Data\n")
            for relations in relation {
                print(relations)
            }
        
        print("\nExercise - 3 Validate correct relationships loaded.")
        print("\nTest for checking correct relationship\n")
        
        
        
        familyGraph.checkRelations(name: "Bob", noOfRelation: 4)
        familyGraph.checkRelations(name: "Jenny", noOfRelation: 3)
        familyGraph.checkRelations(name: "Nigel", noOfRelation: 2)
        familyGraph.checkRelations(name: "Alan", noOfRelation: 0)
        
        print("\nExercise - 4 Write a method that calculates the size of the extended family\n")
        
            let jennyCount = familyGraph.countFamilyMembers(name: "Jenny")
            let bobCount = familyGraph.countFamilyMembers(name: "Bob")

            print("Jenny (\(jennyCount) members)")
            print("Bob (\(bobCount) members)")
        
    }
}
