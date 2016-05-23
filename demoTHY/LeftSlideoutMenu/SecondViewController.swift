import UIKit
import PRAR

//@property (nonatomic, strong) PRARManager *prARManager;
var prARManager = PRARManager()
let x: Int32 = AR_VIEW_TAG
let y = Int(x)

class SecondViewController: UIViewController, PRARManagerDelegate {

    @IBOutlet var logoButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    func alert(title: String, withDetails details: String) {
        //print("alert function")
        let alert: UIAlertView = UIAlertView(title: title, message: details, delegate: nil, cancelButtonTitle: "Ok", otherButtonTitles: "")
        alert.show()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        logoButton.setImage(UIImage(named: "skylance.png"), forState: .Normal)
        leftButton.setFAIcon(FAType.FAMap, forState: .Normal)
        rightButton.setFAIcon(FAType.FABinoculars, forState: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // do stuff here
        //print("1")
        prARManager = PRARManager.init(size: self.view.frame.size, delegate: self, showRadar: true)
        //print("2")
    }
    
    override func viewDidAppear(animated: Bool) {
        //print("3")
        let locationCoordinates = CLLocationCoordinate2D(latitude: 41.085468, longitude: 29.044033)
        //print("4")
        prARManager.startARWithData(self.getDummyData() as [AnyObject], forLocation: locationCoordinates)
        //print("5")
    }
    
    func getDummyData() -> NSArray {
        //print("6")
        /*
        let dummyData: [AnyObject] = [["id": 0, "lat": 40.898553, "lon": 29.309219, "title": "Sabiha Gökçen Havalimanı", "iata":"SAW", "icao":"LTFJ", "operator":"Malaysia Airports", "temperature":"13 °C" , "wind":"Orta Şiddetli (Güneybatı)"],
            ["id": 1, "lat": 40.976922, "lon": 28.814606, "title": "Atatürk Havalimanı", "iata":"IST", "icao":"LTBA", "operator":"TAV Airports", "temperature":"14.3 °C" , "wind":"Orta Şiddetli (Güneybatı)"],
            ["id": 2, "lat": 40.128082, "lon": 32.995083, "title": "Esenboğa Havalimanı", "iata":"ESB", "icao":"LTAC", "operator":"TAV Airports", "temperature":"11 °C" , "wind":"Sakin"],
            ["id": 3, "lat": 38.292392, "lon": 27.156953, "title": "Adnan Menderes Havalimanı", "iata":"ADB", "icao":"LTBJ", "operator":"TAV Airports", "temperature":"15 °C" , "wind":"Şiddetli (Güney)"],
            ["id": 4, "lat": 40.995108, "lon": 39.789728, "title": "Trabzon Havalimanı", "iata":"TZX", "icao":"LTCG", "operator":"DHMİ", "temperature":"26 °C" , "wind":"Şiddetli (Güney)"],
            ["id": 5, "lat": 37.893897, "lon": 40.201019, "title": "Diyarbakır Havalimanı", "iata":"DIY", "icao":"LTCC", "operator":"DHMİ", "temperature":"8 °C" , "wind":"Orta Şiddetli (Güney)"]]
        
        
        NSUserDefaults.standardUserDefaults().setObject(dummyData, forKey: "dummyData")
        NSUserDefaults.standardUserDefaults().synchronize()
        */
        
        
        let myDummyData = NSUserDefaults.standardUserDefaults().objectForKey("dummyData")!
        //print("7")
        return myDummyData as! NSArray;
    }
    
    func prarDidSetupAR(arView: UIView, withCameraLayer cameraLayer: AVCaptureVideoPreviewLayer, andRadarView radar: UIView) {
        //print("8")
        NSLog("Finished displaying ARObjects")
        //print("9")
        self.view.layer.addSublayer(cameraLayer)
        //print("10")
        self.view!.addSubview(arView)
        //print("11")
        self.view.bringSubviewToFront(self.view.viewWithTag(y)!)
        //self.view.bringSubviewToFront(self.view!.viewWithTag(AR_VIEW_TAG));
        //self.view!.bringSubviewToFront(self.view!.viewWithTag( 042313 )!)
        //print("12")
        self.view!.addSubview(radar)
        //print("13")
    }

    func prarUpdateFrame(arViewFrame: CGRect) {
        //print("14")
        self.view.viewWithTag(y)?.frame = arViewFrame
        //print("hello")
        //self.view.viewWithTag(AR_VIEW_TAG)!.frame = arViewFrame
        //self.view!.viewWithTag(042313)!.frame = arViewFrame
        //print("15")
    }
    
    func prarGotProblem(problemTitle: String!, withDetails problemDetails: String!) {
        //print("16")
        self.alert(problemTitle, withDetails: problemDetails)
        //print("17")
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        //print("18")
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
        //print("19")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //print("20")
    }
    
    
    @IBAction func switchTabBarToFirstPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("switchTabBar", object: nil, userInfo: ["item" : 0])
    }
    
}

