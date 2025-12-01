import SwiftUI

struct BluetoothView: View {
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        VStack {
            Text("Connect to Device")
                .font(.largeTitle)
                .padding()

            if bluetoothManager.isScanning {
                ProgressView("Scanning…")
                    .padding()
            }

            List(bluetoothManager.peripherals, id: \.identifier) { peripheral in
                Button(action: {
                    bluetoothManager.connect(to: peripheral)
                }) {
                    Text(peripheral.name ?? "Unknown Device")
                }
            }

            Button("Scan for Devices") {
                bluetoothManager.startScan()
            }
            .padding()
        }
    }
}
