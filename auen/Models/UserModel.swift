import Foundation


struct User: Identifiable, Codable {
    var id: String
    var email: String
    var password: String
    
    var initials: String{
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: email){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
   
}


