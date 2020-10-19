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
    var nextShortCode :Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerData = ["Normal", "Warning", "Urgent"]
        self.typePickerView.delegate = self
        self.typePickerView.dataSource = self
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        controllView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {return pickerData.count}
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { type = pickerData[row]}
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {return pickerData[row]}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitResult = hitTestResults.first{ addText(at: hitResult)}
        }
    }
    
    private func addText(at hitResult: ARHitTestResult)
    {
        let textGeometry = setMyNoteAppearance()
        addNodeToTheScene(textGeometry: textGeometry, hitResult: hitResult)
        getNextShortCodeFromTheDb()
        saveMyNoteDataToDb()
    }
    
    private func setMyNoteAppearance() -> SCNGeometry
    {
        if textMessage.text == ""{textMessage.text = "Missing text.."}
        let textGeometry = SCNText(string: textMessage.text, extrusionDepth: 1.0)
        if type == ""{ type = "Normal"}
        if type == "Normal" {textGeometry.firstMaterial?.diffuse.contents = UIColor.black}
        else if type == "Warning"{textGeometry.firstMaterial?.diffuse.contents = UIColor.yellow}
        else{textGeometry.firstMaterial?.diffuse.contents = UIColor.red}
        return textGeometry
    }
    
    private func addNodeToTheScene(textGeometry : SCNGeometry, hitResult : ARHitTestResult)
    {
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y + 0.01, z: hitResult.worldTransform.columns.3.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    private func createDbFormat() -> NSDictionary
    {
        var text_message = textMessage.text
        if text_message == "" {text_message = "Missing Text...."}
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = df.string(from: Date())
        let myNoteData = MyNote(
            shortCode: String(nextShortCode+1),
            type: type,
            date: now,
            textMessage: text_message!)
        
        return [
            "shortcode" : myNoteData.shortcode,
            "type" : myNoteData.type,
            "date" : myNoteData.date,
            "textmessage" : myNoteData.textMessage]
    }
    
    private func saveMyNoteDataToDb()
    {
        let myNoteDb = Database.database().reference().child("MyNotes")
        let dictionary = createDbFormat()
        
        myNoteDb.childByAutoId().setValue(dictionary)
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
    
    private func getNextShortCodeFromTheDb()
    {
        let shortCodeDb = Database.database().reference().child("ShortCode")
            
        shortCodeDb.observe(.value) { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            self.nextShortCode = snapshotValue!["code"] as! Int
        }
        
        shortCodeDb.updateChildValues(["code" : nextShortCode + 1])
    }
    
    
    @IBAction func applyFilters(_ sender: UIButton){controllView.isHidden = true}
    @IBAction func cancelFilters(_ sender: UIButton){controllView.isHidden = true}
    @IBAction func showSettings(_ sender: UIButton) {controllView.isHidden = false}
}
