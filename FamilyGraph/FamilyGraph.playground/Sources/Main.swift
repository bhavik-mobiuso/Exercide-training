import Foundation

class Main {
    
    //Declare variables
    var parseObj = ParseCSV()
    var oprtObj = FamilyGraphOperaion()
    var peopleData = [People]()
    var relationshipsData = [Relationships]()
    
    func exercises() {
        print("Exercise - 1  Please implement code and data structures that read the files")
        
            peopleData = parseObj.CSVParsingPeople(fileName: "people", fileExtension: "csv", model: Model.People)
            relationshipsData = parseObj.CSVParsingPeople(fileName: "relationships", fileExtension: "csv", model: Model.Relationships)
            
        print("Exercise - 2 Validate correct people loaded.")
        
            print("\nTotal \(peopleData.count) No. Of People Loaded")
            print("\nPeople Data\n")
            for people in peopleData {
                print(people)
            }
            print("\nRelationship Data\n")
            for relations in relationshipsData {
                print(relations)
            }
        
        print("\nExercise - 3 Validate correct relationships loaded.")
        print("\nTest for checking correct relationship\n")
        
            oprtObj.checkRelations(name: "Bob", noOfRelation: 4)
            oprtObj.checkRelations(name: "Jenny", noOfRelation: 3)
            oprtObj.checkRelations(name: "Nigel", noOfRelation: 2)
            oprtObj.checkRelations(name: "Alan", noOfRelation: 0)
        
        print("\nExercise - 4 Write a method that calculates the size of the extended family\n")
        
            let jennyCount = oprtObj.countFamilyMembers(name: "Jenny")
            let bobCount = oprtObj.countFamilyMembers(name: "Bob")

            print("Jenny (\(jennyCount) members)")
            print("Bob (\(bobCount) members)")
        
    }
}
