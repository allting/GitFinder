//
//  Document.swift
//  GitFinder
//
//  Created by kkr on 2017. 8. 9..
//
//

import Cocoa

class Document: NSPersistentDocument {
    let events = SCEvents()
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
        
        self.setupFileSystemEvents()
    }
    
    fileprivate func setupFileSystemEvents() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        events.delegate = self
        events.startWatchingPaths(paths)
        Swift.print("SCEvents:\(events)")
    }
}

extension Document : SCEventListenerProtocol {
    func pathWatcher(_ pathWatcher:SCEvents, eventOccurred event:SCEvent){
        Swift.print("Event:\(event)")
        
        let flags: SCEventFlags = event.eventFlags
        
        if flags.rawValue & SCEventFlags.itemIsFile.rawValue != SCEventFlags.itemIsFile.rawValue {
            return
        }
        
        if flags.rawValue & SCEventFlags.itemCreated.rawValue == SCEventFlags.itemCreated.rawValue {
            Swift.print("SCEventStreamEventFlagItemCreated")
            return
        }

        if flags.rawValue & SCEventFlags.itemFinderInfoMod.rawValue == SCEventFlags.itemFinderInfoMod.rawValue {
            Swift.print("SCEventStreamEventFlagItemModified")
            return
        }

        if flags.rawValue & SCEventFlags.itemRenamed.rawValue == SCEventFlags.itemRenamed.rawValue {
            Swift.print("SCEventStreamEventFlagItemRemoved")
            return
        }
    }
}
