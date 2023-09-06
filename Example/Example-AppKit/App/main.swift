//
//  main.swift
//  Example-AppKit
//
//  Created by Mikhail Vospennikov on 10.02.2023.
//

import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
