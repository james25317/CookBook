// 
//  Refresh.swift
//  EasyRefresher
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/4/26
//  Copyright © 2019 Pircate. All rights reserved.
//

import UIKit

public struct Refresh<Base> {
    
    let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
}

public protocol RefreshCompatible: AnyObject {
    
    associatedtype CompatibleType
    
    var refresh: CompatibleType { get set }
}

public extension RefreshCompatible {
    
    var refresh: Refresh<Self> {
        get { Refresh(self) }
        set {}
    }
}

extension UIScrollView: RefreshCompatible {}

public extension Refresh where Base: UIScrollView {
    
    var header: HeaderRefresher {
        get { base.refresh_header }
        set { base.refresh_header = newValue }
    }
    
    var footer: FooterRefresher {
        get { base.refresh_footer }
        set { base.refresh_footer = newValue }
    }
    
    var trailer: TrailerRefresher {
        get { base.refresh_trailer }
        set { base.refresh_trailer = newValue }
    }
}
