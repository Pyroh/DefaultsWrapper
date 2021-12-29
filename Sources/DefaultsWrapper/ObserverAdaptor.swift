//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 29/12/21.
//

import Foundation
import Combine

class ObserverAdaptor<Element>: NSObject {
    let key: String
    let getter: () -> Element
    let defaults: UserDefaults
    
    lazy var publisher: PassthroughSubject<Element, Never> = {
        defaults.addObserver(self, forKeyPath: key, options: [], context: nil)
        
        return PassthroughSubject()
    }()
    
    init(_ key: String, getter: @escaping () -> Element, defaults: UserDefaults) {
        self.key = key
        self.getter = getter
        self.defaults = defaults
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == key else { return }
        
        publisher.send(getter())
    }
}
