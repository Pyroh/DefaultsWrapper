//
//  ObserverAdaptor.swift
//
//  DefaultsWrapper
//
//  MIT License
//
//  Copyright (c) 2022 Pierre Tacchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import Combine

enum ObservationNeeds {
    case none, projected, objectPublisher, both
    
    var hasNeeds: Bool { self != .none }
    
    mutating func addProjectedNeed() {
        switch self {
        case .none: self = .projected
        case .objectPublisher: self = .both
        case .projected, .both: break
        }
    }
    
    mutating func addObjectPublisherNeed() {
        switch self {
        case .none: self = .objectPublisher
        case .projected: self = .both
        case .objectPublisher, .both: break
        }
    }
    
    mutating func removeObjectPublisherNeed() {
        switch self {
        case .objectPublisher: self = .none
        case .both: self = .projected
        case .projected, .none: break
        }
    }
}

class ObserverAdaptor<Element>: NSObject {
    let key: String
    let getter: () -> Element
    let defaults: UserDefaults
    var observationNeeds: ObservationNeeds = .none
    
    lazy var publisher: PassthroughSubject<Element, Never> = {
        if observationNeeds.hasNeeds {
            defaults.addObserver(self, forKeyPath: key, options: [], context: nil)
        }
        
        observationNeeds.addProjectedNeed()
        return PassthroughSubject()
    }()
    
    init(_ key: String, getter: @escaping () -> Element, defaults: UserDefaults) {
        self.key = key
        self.getter = getter
        self.defaults = defaults
    }
    
    deinit {
        if observationNeeds.hasNeeds {
            defaults.removeObserver(self, forKeyPath: key)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == key else { return }
        
        publisher.send(getter())
    }
}

class ObserverRelayAdaptor<Element>: ObserverAdaptor<Element> {
    private var blockNextObservedValue = false
    private weak var observableObjectPublisher: ObservableObjectPublisher?
    
    func updateObservedObjectPublisherIfNeeded(_ oop: ObservableObjectPublisher) {
        guard oop !== observableObjectPublisher else { return }
        
        observableObjectPublisher = oop
        
        if !observationNeeds.hasNeeds {
            defaults.addObserver(self, forKeyPath: key, options: [], context: nil)
        }
        
        observationNeeds.addObjectPublisherNeed()
    }
    
    func clearObservedObjectPublisher() {
        observableObjectPublisher = nil
        observationNeeds.removeObjectPublisherNeed()
        
        if !observationNeeds.hasNeeds {
            defaults.removeObserver(self, forKeyPath: key)
        }
    }
    
    func notify() {
        observableObjectPublisher.map {
            blockNextObservedValue = true
            $0.send()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)

        guard keyPath == key else { return }
        guard !blockNextObservedValue else {
            blockNextObservedValue.toggle()
            return
        }
        
        observableObjectPublisher?.send()
    }
}
