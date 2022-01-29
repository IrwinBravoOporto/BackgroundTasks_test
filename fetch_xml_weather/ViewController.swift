//
//  ViewController.swift
//  fetch_xml_weather
//
//  Created by Yuki Shinohara on 2021/01/25.
//

import UIKit
import CoreBluetooth
import CoreLocation

struct ImpactService {
   public static let service = CBUUID(string: "27B63C23-938E-E0F9-44E9-7412487FA5E6")
}

struct DisplayPeripheral: Hashable {
    let peripheral: CBPeripheral
    let lastRSSI: NSNumber
    let isConnectable: Bool
    
    var hashValue: Int { return peripheral.hashValue }
    
    static func ==(lhs: DisplayPeripheral, rhs: DisplayPeripheral) -> Bool {
        return lhs.peripheral == rhs.peripheral
    }
}

class ViewController: UIViewController {
    
    private lazy var locationManager: CLLocationManager = {
      let manager = CLLocationManager()
      manager.desiredAccuracy = kCLLocationAccuracyBest
      manager.delegate = self
      manager.requestAlwaysAuthorization()
      manager.allowsBackgroundLocationUpdates = true
      return manager
    }()
    
    private var centralManager: CBCentralManager!
    private var peripherals = Set<DisplayPeripheral>()
    private var viewReloadTimer: Timer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.startUpdatingLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("NewFunctionName"), object: nil)
    }
    @objc func functionName(notification: NSNotification){
        
        print("Primer Plano")
        peripherals = []
        self.centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.centralManager!.isScanning {
                strongSelf.centralManager?.stopScan()
            }
        }
    }
    
     func startScanning() {
//         peripherals = []
//         centralManager.scanForPeripherals(withServices: [ImpactService.service], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
//         DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
//             guard let strongSelf = self else { return }
//             if strongSelf.centralManager!.isScanning {
//                 strongSelf.centralManager?.stopScan()
//             }
//         }
        peripherals = []
        self.centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.centralManager!.isScanning {
                strongSelf.centralManager?.stopScan()
            }
        }
    }
}

extension ViewController:CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        if (central.state == .poweredOn){
//            scanningButton.isEnabled = true
            startScanning()
        }else{
//            updateStatusText("Bluetooth Disabled")
//            scanningButton.isEnabled = false
            peripherals.removeAll()
//            tableView.reloadData()
//            UIAlertController.presentAlert(on: self, title: "Bluetooth Unavailable", message: "Please turn bluetooth on")
        }
        
//        if UIApplication.shared.applicationState == .active {
//            NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
//        } else {
//            NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
//        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        let isConnectable = advertisementData["kCBAdvDataIsConnectable"] as! Bool
        let displayPeripheral = DisplayPeripheral(peripheral: peripheral, lastRSSI: RSSI, isConnectable: isConnectable)
        print(displayPeripheral)
        peripherals.insert(displayPeripheral)
        var valueKwemaUUID = false
        for var i in 0..<peripherals.count{
            
            if (displayPeripheral.peripheral.identifier == UUID(uuidString: "27B63C23-938E-E0F9-44E9-7412487FA5E6")){
                valueKwemaUUID = true
            }
            i += 1
        }
        
        print(valueKwemaUUID)
        
    }
}


extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let mostRecentLocation = locations.last else {
        return
      }
      
      if UIApplication.shared.applicationState == .active {
          print("App is active\(mostRecentLocation)")
          NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
      } else {
        print("App is backgrounded. New location is %@", mostRecentLocation)
          NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
      }
    }
  }

