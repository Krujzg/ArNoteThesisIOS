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

    @IBOutlet var resolveShortCodeTextField: UITextField!
    @IBOutlet var typePickerView: UIPickerView!
    @IBOutlet var textMessageTextField: UITextField!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var controllView: UIView!
    
    var pickerData: [String] = [String]()
    var type : String = ""
    var textNode = SCNNode()
    var nextShortCode :Int = 1
    var isResolvedPressed = false
    var choosenShortCode = ""
    var lastPanLocation : SCNVector3? = nil
    
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
    
    func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.sceneView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .featurePoint)
        if let hitResult = hitTestResults.first{
            if isResolvedPressed
            {
                addTextAfterResolvedPressed(at: hitResult)
                isResolvedPressed = false
            }
            else
            {
                addText(at: hitResult)}
            }
    }
    
    @objc func handlePan(panGesture: UIPanGestureRecognizer) {
      
      let location = panGesture.location(in: self.sceneView)
      var panStartZ : CGFloat? = nil
      
      switch panGesture.state {
      case .began:
        // existing logic from previous approach. Keep this.
        guard let hitNodeResult = sceneView.hitTest(location, options: nil).first else { return }
        panStartZ = CGFloat(sceneView.projectPoint(lastPanLocation!).z)
        // lastPanLocation is new
        lastPanLocation = hitNodeResult.worldCoordinates
      case .changed:
        // This entire case has been replaced
        let worldTouchPosition = sceneView.unprojectPoint(SCNVector3(location.x, location.y, panStartZ!))
        let movementVector = SCNVector3(
          worldTouchPosition.x - lastPanLocation!.x,
          worldTouchPosition.y - lastPanLocation!.y,
          worldTouchPosition.z - lastPanLocation!.z)
        textNode.localTranslate(by: movementVector)
        self.lastPanLocation = worldTouchPosition
      default:
        break
      }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {return pickerData.count}
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { type = pickerData[row]}
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {return pickerData[row]}
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitResult = hitTestResults.first{
                if isResolvedPressed
                {
                    addTextAfterResolvedPressed(at: hitResult)
                    isResolvedPressed = false
                }
                else
                {
                    addText(at: hitResult)}
                }
        }
    }*/
    
    private func addText(at hitResult: ARHitTestResult)
    {
        let textGeometry = setMyNoteAppearance(chooseNodeText: textMessageTextField.text!, choosenNodeType: type)
        addNodeToTheScene(textGeometry: textGeometry, hitResult: hitResult)
        getNextShortCodeFromTheDb()
        saveMyNoteDataToDb()
    }
    
    private func setMyNoteAppearance(chooseNodeText: String, choosenNodeType: String) -> SCNGeometry
    {
        let textGeometry = SCNText(string: chooseNodeText, extrusionDepth: 1.0)
        if choosenNodeType == "Normal" {textGeometry.firstMaterial?.diffuse.contents = UIColor.black}
        else if choosenNodeType == "Warning"{textGeometry.firstMaterial?.diffuse.contents = UIColor.yellow}
        else{textGeometry.firstMaterial?.diffuse.contents = UIColor.red}
        return textGeometry
    }
    
    private func addNodeToTheScene(textGeometry : SCNGeometry, hitResult : ARHitTestResult)
    {
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y + 0.01, z: hitResult.worldTransform.columns.3.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        let background = addBackGroundToTheTextNode()
        textNode.addChildNode(background)
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    private func addBackGroundToTheTextNode() -> SCNNode
    {
        let minVec = textNode.boundingBox.min
        let maxVec = textNode.boundingBox.max
        let bound = SCNVector3Make(maxVec.x - minVec.x,
                                   maxVec.y - minVec.y,
                                   maxVec.z - minVec.z);

        let plane = SCNPlane(width: CGFloat(bound.x + 1),
                            height: CGFloat(bound.y + 1))
        plane.cornerRadius = 0.2
        plane.firstMaterial?.diffuse.contents = UIColor.black.withAlphaComponent(0.9)

        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(CGFloat( minVec.x) + CGFloat(bound.x) / 2 ,
                                        CGFloat( minVec.y) + CGFloat(bound.y) / 2,CGFloat(minVec.z - 0.01))
        return planeNode
    }
    
    private func createDbFormat() -> NSDictionary
    {
        var text_message = textMessageTextField.text
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
        
        myNoteDb.child(String(nextShortCode)).setValue(dictionary)
        {
            (error,reference) in
            if error != nil{
                print(error!)
            }
            else
            {
                print("Successful save")
                self.textMessageTextField.text = ""
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
    @IBAction func resolveAction(_ sender: UIButton)
    {
        isResolvedPressed = true
        choosenShortCode = resolveShortCodeTextField.text!
    }
    
    private func addTextAfterResolvedPressed(at hitResult: ARHitTestResult)
    {
        let choosenNodeData = getTheChoosenShortCodeFromTheDb()
        let textmessage = choosenNodeData.value(forKey: "textmessage") as! String
        let type = choosenNodeData.value(forKey: "type") as! String
        let textGeometry = setMyNoteAppearance(chooseNodeText: textmessage, choosenNodeType: type )
        addNodeToTheScene(textGeometry: textGeometry, hitResult: hitResult)
    }
    
    private func getTheChoosenShortCodeFromTheDb() -> NSDictionary
    {
        let myNotesDb = Database.database().reference().child("MyNotes")
        var choosenNodeText = ""
        var choosenNodeType = ""
        
        let query = myNotesDb.queryOrdered(byChild: "shortcode").queryEqual(toValue: choosenShortCode)
        query.observe(.value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            choosenNodeText = snapshotValue!["textmessage"] as! String
            choosenNodeType = snapshotValue!["type"] as! String
        })
        return [
            "type" : choosenNodeType,
            "textmessage" : choosenNodeText]
    }
    
    @IBAction func openFilters(_ sender: UIBarButtonItem)
    {
        controllView.isHidden = false
    }
    
    @IBAction func clearPreviousNode(_ sender: UIButton)
    {
        textNode.removeFromParentNode()
    }
    @IBAction func cancel(_ sender: UIButton)
    {
        controllView.isHidden = true
    }
    @IBAction func apply(_ sender: UIButton)
    {
        controllView.isHidden = true
    }
}
