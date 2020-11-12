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

class ArSceneViewController: UIViewController, ARSCNViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var resolveShortCodeTextField: UITextField!
    @IBOutlet var typePickerView: UIPickerView!
    @IBOutlet var textMessageTextField: UITextField!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var controllView: UIView!
    @IBOutlet var MessageBox: UITextView!
    
    var pickerData: [String] = [String]()
    var type : String = "Normal"
    var textNode = SCNNode()
    var selectedNode: SCNNode?
    var nextShortCode :Int = 1
    var isResolvedPressed = false
    var choosenShortCode = ""
    var lastPanLocation : SCNVector3? = nil
    var isHitTestingBlocked = true
    
    var PCoordx: Float = 0.0
    var PCoordy: Float = 0.0
    var PCoordz: Float = 0.0
    let kMovingLengthPerLoop: CGFloat = 0.5
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerData = ["Normal", "Warning", "Urgent"]
        self.textMessageTextField.delegate = self
        self.resolveShortCodeTextField.delegate = self
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
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.sceneView.addGestureRecognizer(panGestureRecognizer)
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer)
    {
        var hitNode : [SCNHitTestResult]
        switch sender.state {
            case .began:
                hitNode = self.sceneView.hitTest(sender.location(in: self.sceneView),
                                                     options: nil)
                self.selectedNode = hitNode.first?.node
                print(self.selectedNode)
                if selectedNode != nil {
                    self.PCoordx = (hitNode.first?.worldCoordinates.x)!
                    self.PCoordy = (hitNode.first?.worldCoordinates.y)!
                    self.PCoordz = (hitNode.first?.worldCoordinates.z)!
                }
            case .changed:
                // when you start to pan in screen with your finger
                // hittest gives new coordinates of touched location in sceneView
                // coord-pcoord gives distance to move or distance paned in sceneview
                hitNode = sceneView.hitTest(sender.location(in: sceneView), options: nil)
                if selectedNode != nil {
                    if let coordx = hitNode.first?.worldCoordinates.x,
                        let coordy = hitNode.first?.worldCoordinates.y,
                        let coordz = hitNode.first?.worldCoordinates.z {
                        let action = SCNAction.moveBy(x: CGFloat(coordx - PCoordx),
                                                      y: CGFloat(coordy - PCoordy),
                                                      z: CGFloat(coordz - PCoordz),
                                                      duration: 0.0)
                        self.selectedNode?.runAction(action)

                        self.PCoordx = coordx
                        self.PCoordy = coordy
                        self.PCoordz = coordz
                    }

                    sender.setTranslation(CGPoint.zero, in: self.sceneView)
                }
               
            case .ended:
                self.PCoordx = 0.0
                self.PCoordy = 0.0
                self.PCoordz = 0.0
            default:
                break
            }
    }
    @IBAction func tapped(_ sender: UITapGestureRecognizer)
    {
        if !isHitTestingBlocked {
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
    }
    
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer)
    {
        let pinchLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(pinchLocation)
        
        if !hitTest.isEmpty {
            let results = hitTest.first!
            let node = results.node
            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            print(sender.scale)
            //let nodeChildren = results.node.childNodes.first
            //nodeChildren!.runAction(pinchAction)
            node.runAction(pinchAction)
            sender.scale = 1.0
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {return pickerData.count}
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { type = pickerData[row]}
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {return pickerData[row]}
    
    private func addText(at hitResult: ARHitTestResult)
    {
        var text_message = textMessageTextField.text
        if text_message == "" {text_message = "Missing Text...."}
        let textGeometry = setMyNoteAppearance(chooseNodeText: text_message!, choosenNodeType: type)
        getNextShortCodeFromTheDb(textGeometry: textGeometry, hitResult: hitResult)
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
        sceneView.scene.rootNode.addChildNode(textNode)
        MessageBox.text = "Arnote added! Shortcode:\(String(nextShortCode-1))"
    }
    
    /*private func addBackGroundToTheTextNode() -> SCNNode
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
    }*/
    
    private func createDbFormat() -> NSDictionary
    {
        var text_message = textMessageTextField.text
        if text_message == "" {text_message = "Missing Text...."}
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = df.string(from: Date())
        let myNoteData = MyNote(
            shortCode: String(nextShortCode),
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
                let alert = UIAlertController(title: "Szerver hiba", message: "Nem elérhető a szerver", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Oké", style: UIAlertAction.Style.default, handler: nil))
            }
            else
            {
                print("Successful save")
                self.textMessageTextField.text = ""
            }
        }
    }
    
    private func getNextShortCodeFromTheDb(textGeometry: SCNGeometry, hitResult: ARHitTestResult)
    {
        let shortCodeDb = Database.database().reference().child("ShortCode")
            
        shortCodeDb.observe(.value) { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            self.nextShortCode = snapshotValue!["code"] as! Int
            self.nextShortCode = self.nextShortCode+1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            shortCodeDb.child("code").setValue(self.nextShortCode)
            self.saveMyNoteDataToDb()
        })
        addNodeToTheScene(textGeometry: textGeometry, hitResult: hitResult)
    }
    
    private func addTextAfterResolvedPressed(at hitResult: ARHitTestResult)
    {
        MessageBox.text = "Adding \(choosenShortCode) Note..."
        getTheChoosenShortCodeFromTheDb(at: hitResult)
    }
    
    private func getTheChoosenShortCodeFromTheDb(at hitResult: ARHitTestResult)
    {
        let myNotesDb = Database.database().reference().child("MyNotes")
        var choosenNodeText = ""
        var choosenNodeType = ""
        
        myNotesDb.child(choosenShortCode).observe(.value) { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            choosenNodeText = snapshotValue!["textmessage"] as! String
            choosenNodeType = snapshotValue!["type"] as! String
            self.setDataAfterResolveAction(choosenNodeText: choosenNodeText, choosenNodeType: choosenNodeType, hitResult: hitResult)
        }
    }
    
    private func setDataAfterResolveAction(choosenNodeText : String, choosenNodeType : String, hitResult : ARHitTestResult)
    {
        let textmessage = choosenNodeText
        let type = choosenNodeType
        let textGeometry = setMyNoteAppearance(chooseNodeText: textmessage, choosenNodeType: type )
        addNodeToTheScene(textGeometry: textGeometry, hitResult: hitResult)
        MessageBox.text = " \(textmessage) arnote added!"
    }
    
    @IBAction func apply(_ sender: UIButton)
    {
        controllView.isHidden = true
        isHitTestingBlocked = false
    }
    @IBAction func cancel(_ sender: UIButton)
    {
        controllView.isHidden = true
        isHitTestingBlocked = false
    }
    @IBAction func openFilter(_ sender: UIButton)
    {
        controllView.isHidden = false
        isHitTestingBlocked = true
    }
    @IBAction func resolveActionButtonPress(_ sender: UIButton)
    {
        isResolvedPressed = true
        choosenShortCode = resolveShortCodeTextField.text!
    }
    @IBAction func clearPrevNode(_ sender: UIButton)
    {
        textNode.removeFromParentNode()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resolveShortCodeTextField.resignFirstResponder()
        textMessageTextField.resignFirstResponder()
        return true
    }
}
extension Int { var degreesToRadians: Double { return Double(self) * .pi/180}}

enum CategoryBitMask: Int {
      case categoryToSelect = 2        // 010
      case otherCategoryToSelect = 4   // 100
      // you can add more bit masks below . . .
  }

enum BodyType : Int {
    case ObjectModel = 2;
}
