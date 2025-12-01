//
//  BluetoothView.swift
//  LymphaSense
//
//  Created by Lindsay on 11/28/25.
//

/*
import SwiftUI
import CoreBluetooth
import UIKit

struct BluetoothView: View {
    @StateObject private var manager = BluetoothManager()

    var body: some View {
        VStack {
            Text(manager.isScanning ? "Scanning..." : "Scan Complete")
                .font(.title)

            List(manager.peripherals, id: \.identifier) { device in
                Text(device.name ?? "Unknown Device")
            }

            Button(manager.isScanning ? "Stop Scan" : "Rescan") {
                manager.isScanning ? manager.stopScan() : manager.startScan()
            }
            .padding()
        }
        .navigationTitle("Bluetooth Setup")
    }
    
} */

// BluetoothView.swift

import SwiftUI
import CoreBluetooth

struct BluetoothView: View {
    private var manager = BluetoothManager()
    //@StateObject private var manager = BluetoothManager()

    var body: some View {
        VStack {
            
            // Display status
            Text(statusMessage)
                .font(.title)
                .padding(.bottom)
                .foregroundColor(manager.isConnected ? .green : .blue)
            
            // List discovered peripherals
            List(manager.peripherals, id: \.identifier) { device in
                VStack(alignment: .leading) {
                    Text(device.name ?? "Unknown Device")
                        .font(.headline)
                    Text("ID: \(device.identifier.uuidString)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            // Control Buttons
            HStack {
                Button(manager.isScanning ? "Stop Scan" : "Rescan") {
                    manager.isScanning ? manager.stopScan() : manager.startScan()
                }
                .buttonStyle(.borderedProminent)
                .disabled(manager.isConnected) // Can't scan while connected
                
                if manager.isConnected {
                    Button("Disconnect") {
                        manager.disconnect()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            .padding()
        }
        .navigationTitle("Bluetooth Setup")
    }
    
    var statusMessage: String {
        if manager.isConnected {
            return "Connected to \(manager.connectedPeripheral?.name ?? "Device")"
        } else if manager.isScanning {
            return "Scanning..."
        } else {
            return "Scan Complete"
        }
    }
}
