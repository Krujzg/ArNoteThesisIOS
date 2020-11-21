import Foundation
import Firebase

class FireBaseRepository : NSObject
{
    static let shared = FireBaseRepository()
    let myNotesDb = Database.database().reference().child("MyNotes")
    let shortCodeDb = Database.database().reference().child("ShortCode")
    var sfbShortCodeInt : Int = 1
    
    func retrieveNotes(completionHandler: @escaping CompletionHandlerForRetrievingNote)
    {
        myNotesDb.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! NSDictionary
            let myNote = self.createArNoteFromSnapshot(snapshotValue: snapshotValue)
            completionHandler(true,myNote)
            }
    }
    
    private func createArNoteFromSnapshot(snapshotValue : NSDictionary) -> MyNote
    {
        let shortcode = snapshotValue["shortcode"] as! String
        let type = snapshotValue["type"] as! String
        let date = snapshotValue["date"] as! String
        let textMessage = snapshotValue["textmessage"] as! String
        return MyNote(
            shortCode: shortcode,
            type: type,
            date: date,
            textMessage: textMessage)
    }
    
    func loginWithFireBaseAuth(email: String, password: String, completionHandler: @escaping CompletionHandlerForAuth )
    {
        Auth.auth().signIn(withEmail: email, password: password)
        {
            (user, error) in
            if error != nil {completionHandler(false)}
            else {completionHandler(true)}
        }
    }
    
    func registerUserIntoFireBaseAuth(email: String, password: String, completionHandler: @escaping CompletionHandlerForAuth)
    {
        Auth.auth().createUser(withEmail: email, password: password) {
            (user, error) in
            
            if error != nil {completionHandler(false)}
            else {completionHandler(true)}
        }
    }
    
    func logoutTheUser()
    {
        do
        {
         try Auth.auth().signOut()
        }
        catch {print(error)}
    }
    
    func saveMyNoteDataToDb(nextShortCode: Int, dictionary: NSDictionary, completionHandler : @escaping CompletionHandlerForSaving)
    {
        myNotesDb.child(String(nextShortCode)).setValue(dictionary)
        {
            (error,reference) in
            if error != nil {completionHandler(false)}
            else {completionHandler(true)}
        }
    }
    
    func getNextShortCodeFromTheDb(completionHandler : @escaping CompletionHandlerForGetNextShortCode)
    {
        shortCodeDb.observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            var nextShortCode = snapshotValue!["code"] as! Int
            self.sfbShortCodeInt = nextShortCode
            completionHandler(true,nextShortCode)
            nextShortCode = nextShortCode+1
            self.setNextShortCodeIntoDb(nextShortCode: nextShortCode)
        })
    }
    private func setNextShortCodeIntoDb(nextShortCode: Int)
    {
        self.shortCodeDb.child("code").setValue(nextShortCode)
    }
    
    func getTheChoosenShortCodeFromTheDb(choosenShortCode : String, completionHandler : @escaping CompletionHandlerForGetChoosenArNote)
    {
        myNotesDb.child(choosenShortCode).observe(.value) { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            completionHandler(true,dictionary!)
        }
    }
    
    func saveMeasurementDataIntoDb(dbChildName: String,measurement: String, completionHandler : @escaping CompletionHandlerForSaving)
    {
        var sfbShortCode : Int = sfbShortCodeInt
        if dbChildName == "Customization" {sfbShortCode = sfbShortCodeInt + 1}
        let devicename = UIDevice.current.name
        Database.database().reference().child(devicename).child("Measurement").child(dbChildName).child(String(sfbShortCode)).setValue(measurement)
        completionHandler(true)
    }
}

typealias CompletionHandlerForRetrievingNote = (_ success:Bool, _ myNote:MyNote) -> Void
typealias CompletionHandlerForAuth = (_ success:Bool) -> Void
typealias CompletionHandlerForSaving = (_ success:Bool) -> Void
typealias CompletionHandlerForGetChoosenArNote = (_ success:Bool,_ dictionary: NSDictionary) -> Void
typealias CompletionHandlerForGetNextShortCode = (_ success:Bool,_ nextShortCode: Int) -> Void
