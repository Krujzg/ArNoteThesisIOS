//
//  ViewController.swift
//  ArNoteThesisIOS
//
//  Created by Gergo on 2020. 10. 11..
//

import UIKit
import SceneKit
import ARKit
import Firebase

class ArSceneViewController: UIViewController, ARSCNViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var textMessage: UITextField!
    @IBOutlet var typePickerView: UIPickerView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var controllView: UIView!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var resolveButton: UIButton!
    
    @IBOutlet var settingButton: UIButton!
    var pickerData: [String] = [String]()
    var type : String = ""
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerData = ["Normal", "Warning", "Urgent"]
        self.typePickerView.delegate = self
        self.typePickerView.dataSource = self
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        controllView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        type = pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first{
                addText(at: hitResult)
            }
        }
    }
    
    func addText(at hitResult: ARHitTestResult)
    {
        if textMessage.text == ""
        {
            textMessage.text = "Missing text.."
        }
        let textGeometry = SCNText(string: textMessage.text, extrusionDepth: 1.0)
        if type == ""{ type = "Normal"}
        if type == "Normal" {
            textGeometry.firstMaterial?.diffuse.contents = UIColor.black
        }
        else if type == "Warning"
        {
            textGeometry.firstMaterial?.diffuse.contents = UIColor.yellow
        }
        else{
            textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        }
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y + 0.01, z: hitResult.worldTransform.columns.3.z)
        
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        var text_message = textMessage.text
        let myNoteDb = Database.database().reference().child("MyNotes")
        if text_message == "" {text_message = "Missing Text...."}
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = df.string(from: Date())
        let myNoteData = MyNote(
            shortCode: "11",
            type: type,
            date: now,
            textMessage: text_message!)
        let nsArray = [myNoteData.shortcode,myNoteData.type,myNoteData.date,myNoteData.textMessage]
        
        myNoteDb.childByAutoId().setValue(nsArray)
        {
            (error,reference) in
            if error != nil{
                print(error!)
            }
            else
            {
                print("Successful save")
                self.textMessage.text = ""
            }
        }
    }
    
    //temporary code
    @IBAction func justcancel(_ sender: UIButton) {
        controllView.isHidden = true
    }
    @IBAction func applyFilters(_ sender: UIButton)
    {
        controllView.isHidden = true
    }
    
    @IBAction func cancelFilters(_ sender: UIButton)
    {
        controllView.isHidden = true
    }
    @IBAction func showSettings(_ sender: UIButton) {
        controllView.isHidden = true
    }
    /*
     @IBAction func sendPressed(_ sender: AnyObject) {
         
         messageTextfield.endEditing(true)
         //TODO: Send the message to Firebase and save it in our database
         messageTextfield.isEnabled = false
         sendButton.isEnabled = false
         
         let messagesDB = Database.database().reference().child("Messages")
         
         let messageDictionary = ["Sender" : Auth.auth().currentUser?.email,
                                  "MessageBody" : messageTextfield.text!]
         
         messagesDB.childByAutoId().setValue(messageDictionary){
             (error, reference) in
             if error != nil{
                 print(error)
             }
             else{
                 print("Message saved successfully")
                 self.messageTextfield.isEnabled = true
                 self.sendButton.isEnabled = true
                 self.messageTextfield.text! = ""
             }
         } // custom random id key
         
     }
     */

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
}