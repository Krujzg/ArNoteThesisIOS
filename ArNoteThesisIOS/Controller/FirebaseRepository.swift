import Foundation
import Firebase

class FireBaseRepository
{
    let myNoteDb = Database.database().reference().child("MyNotes")
    let shortCodeDb = Database.database().reference().child("ShortCode")
    
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
    
    func saveMyNoteDataToDb(nextShortCode: Int, dictionary: NSDictionary, completionHandler : @escaping CompletionHandlerForSaving)
    {
        myNoteDb.child(String(nextShortCode)).setValue(dictionary)
        {
            (error,reference) in
            if error != nil {completionHandler(false)}
            else {completionHandler(true)}
        }
    }
    
    func getNextShortCodeFromTheDb(completionHandler : @escaping CompletionHandlerForGetNextShortCode)
    {
        shortCodeDb.observe(.value) { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let nextShortCode = snapshotValue!["code"] as! Int
            nextShortCode = nextShortCode+1
            self.setNextShortCodeIntoDb(nextShortCode: nextShortCode)
            completionHandler(true,nextShortCode)
        }
    }
    private func setNextShortCodeIntoDb(nextShortCode: Int)
    {
        self.shortCodeDb.child("code").setValue(nextShortCode)
    }
    
    func getTheChoosenShortCodeFromTheDb(completionHandler : @escaping CompletionHandlerForGetChoosenArNote)
    {
        myNotesDb.child(choosenShortCode).observe(.value) { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            completionHandler(true,dictionary)
        }
    }
}

typealias CompletionHandlerForRetrievingNote = (_ success:Bool, _ myNote:MyNote) -> Void
typealias CompletionHandlerForAuth = (_ success:Bool) -> Void
typealias CompletionHandlerForSaving = (_ success:Bool) -> Void
typealias CompletionHandlerForGetChoosenArNote = (_ success:Bool,_ dictionary: NSDictionary) -> Void
typealias CompletionHandlerForGetNextShortCode = (_ success:Bool,_ nextShortCode: Int) -> Void
