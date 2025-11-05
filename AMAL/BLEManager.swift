import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isConnected = false
    @Published var receivedText = ""
    
    private var centralManager: CBCentralManager!
    private var bluefruitPeripheral: CBPeripheral?
    
    private var txCharacteristic: CBCharacteristic?
    private var rxCharacteristic: CBCharacteristic?
    
    // Adafruit BLE UART UUIDs
    private let uartServiceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    private let txUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
    private let rxUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Central Manager
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth ON, scanning...")
            centralManager.scanForPeripherals(withServices: [uartServiceUUID], options: nil)
        } else {
            print("Bluetooth not ready")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Found peripheral: \(peripheral.name ?? "unknown")")
        bluefruitPeripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "device")")
        isConnected = true
        peripheral.delegate = self
        peripheral.discoverServices([uartServiceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == uartServiceUUID {
            peripheral.discoverCharacteristics([txUUID, rxUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for char in characteristics {
            if char.uuid == txUUID {
                txCharacteristic = char
                peripheral.setNotifyValue(true, for: char)
            } else if char.uuid == rxUUID {
                rxCharacteristic = char
            }
        }
        print("UART characteristics ready.")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == txUUID, let value = characteristic.value,
           let string = String(data: value, encoding: .utf8) {
            DispatchQueue.main.async {
                self.receivedText += string
            }
        }
    }
    
    // MARK: - Sending Data
    
    func send(_ text: String) {
        guard let peripheral = bluefruitPeripheral,
              let rx = rxCharacteristic else { return }
        
        let data = (text + "\n").data(using: .utf8)!
        peripheral.writeValue(data, for: rx, type: .withResponse)
    }
}
