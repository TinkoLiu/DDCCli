//
//  main.swift
//  ddccli
//
//  Created by Tinko on 2023/8/7.
//

import Foundation
import ArgumentParser

enum DDCAction: String {
    case Undef = ""
    case List = "list"
    case Get = "get"
    case Set = "set"
}

var allDisplays: [Display] = []

func PrepareAllMonitors() -> Void {
    DisplayManager.shared.configureDisplays()
    DisplayManager.shared.addDisplayCounterSuffixes()
    DisplayManager.shared.updateArm64AVServices()
    allDisplays = DisplayManager.shared.getAllDisplays()
}

struct DDCCli: ParsableCommand {
    // @Flag(name: .shortAndLong)
    // var verbose = false
    
    static let configuration: CommandConfiguration = CommandConfiguration(
        abstract: "A tool for control monitors via DDC/CI on M2 mac.",
        subcommands: [SubCommandList.self, SubCommandGet.self, SubCommandSet.self]
    )
    
    struct SubCommandList: ParsableCommand {
        static let configuration: CommandConfiguration = CommandConfiguration(
            commandName: "list",
            abstract: "List all monitors"
        )
        func run() throws {
            PrepareAllMonitors()
            print("Found \(allDisplays.count) monitor(s)")
            for (index, item) in allDisplays.enumerated() {
                print("#\(index) Name: \(item.name) (Vendor: \(String(format: "%02X", item.vendorNumber ?? 0)), Model: \(String(format: "%02X", item.modelNumber ?? 0)))")
            }
        }
    }
    
    struct SubCommandGet: ParsableCommand {
        static let configuration: CommandConfiguration = CommandConfiguration(
            commandName: "get",
            abstract: "Get VCP value from a monitor"
        )
        @Option(name: .shortAndLong)
        var display: Int
        
        @Option()
        var vcp: UInt8
        
        
        func validate() throws {
            PrepareAllMonitors()
            guard display >= 0 && display < allDisplays.count else {
                throw ValidationError("Invalid display ID")
            }
        }
        
        func run() throws {
            var result = Arm64DDC.read(service: allDisplays[display].arm64avService, command: vcp)
            if result != nil {
                print(result!.current)
            }
        }
    }
    
    struct SubCommandSet: ParsableCommand {
        static let configuration: CommandConfiguration = CommandConfiguration(
            commandName: "set",
            abstract: "Set VCP value to a monitor"
        )
        @Option(name: .shortAndLong)
        var display: Int
        @Option()
        var vcp: UInt8
        @Option()
        var value: UInt16
        
        func validate() throws {
            PrepareAllMonitors()
            guard display >= 0 && display < allDisplays.count else {
                throw ValidationError("Invalid display ID")
            }
        }
        
        func run() throws {
            var result = Arm64DDC.write(service: allDisplays[display].arm64avService, command: vcp, value: value)
            print(result)
        }
    }
    
}

DDCCli.main()
