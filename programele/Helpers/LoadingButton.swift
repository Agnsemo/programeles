//
//  LoadingButton.swift
//  MenuPay
//
//  Created by Mikas on 16/05/2019.
//  Copyright © 2019 Mediapark. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
open class LoadingButton: UIButton {
    
    private var _isLoading: Bool = false
    
    // MARK: Loading
    public var isLoading: Bool {
        get { return _isLoading }
        set {
            guard newValue != isLoading || newValue  else { return }
            isUserInteractionEnabled = !newValue
            newValue ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            _isLoading = newValue
            titleToCache(newValue)
        }
    }
    
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.color = self.titleColor(for: .normal)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        return activityIndicator
    }()
    
    // MARK: Hiding title
    
    private var cachedImage: UIImage?
    private var cachedTitle: String?
    private var cachedAttrTitle: NSAttributedString?
    
    private func titleToCache(_ toCache: Bool = true) {
        let imageToCache =      toCache ? image(for: .normal) : nil
        let imageToButton =     toCache ? nil : cachedImage
        let titleToCache =      toCache ? title(for: .normal) : nil
        let titleToButton =     toCache ? nil : cachedTitle
        let attrTitleToCache =  toCache ? attributedTitle(for: .normal) : nil
        let attrTitleToButton = toCache ? nil : cachedAttrTitle
        
        if let imageToCache = imageToCache { cachedImage = imageToCache }
        if let titleToCache = titleToCache { cachedTitle = titleToCache }
        if let attrTitleToCache = attrTitleToCache { cachedAttrTitle = attrTitleToCache }
        
        super.setImage(imageToButton, for: .normal)
        super.setTitle(titleToButton, for: .normal)
        super.setAttributedTitle(attrTitleToButton, for: .normal)
    }
    
    override public func setTitle(_ title: String?, for state: UIControl.State) {
        if isLoading {
            cachedTitle = title
        } else {
            super.setTitle(title, for: state)
        }
    }
    override public func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
        if isLoading {
            cachedAttrTitle = title
        } else {
            super.setAttributedTitle(title, for: state)
        }
    }
    
    override public func setImage(_ image: UIImage?, for state: UIControl.State) {
        if isLoading {
            cachedImage = image
        } else {
            super.setImage(image, for: state)
        }
    }
}

public extension Reactive where Base: LoadingButton {
    /// Bindable sink for `isLoading` property.
    var isLoading: Binder<Bool> {
        return Binder(self.base) { button, isLoading in
            button.isLoading = isLoading
        }
    }
}

public extension PrimitiveSequenceType where Self.Trait == RxSwift.SingleTrait {
    func attach(_ loading: BehaviorRelay<Bool>?) -> Single<Element> {
        return self.do(onSuccess:      { [weak loading] _ in loading?.accept(false)  },
                       onSubscribe: { [weak loading] in loading?.accept(true)     },
                       onDispose:   { [weak loading] in loading?.accept(false)    })
    }
    
    func attach(_ button: LoadingButton?) -> Single<Element> {
        return self.do(onSuccess:      { [weak button] _ in button?.isLoading = false },
                       onSubscribe: { [weak button] in button?.isLoading = true    },
                       onDispose:   { [weak button] in button?.isLoading = false   })
    }
    
    func attach(_ loading: BehaviorRelay<Int>?) -> Single<Element> {
        return self.do(onSubscribe: { [weak loading] in loading?.accept((loading?.value ?? 0) + 1) },
                       onDispose: { [weak loading] in loading?.accept((loading?.value ?? 1) - 1) })
    }
}


public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    func attach(_ loading: BehaviorRelay<Bool>?) -> Driver<Element> {
        return self.do(onNext:      { [weak loading] _ in loading?.accept(false)  },
                       onSubscribe: { [weak loading] in loading?.accept(true)     },
                       onDispose:   { [weak loading] in loading?.accept(false)    })
    }
    func attach(_ button: LoadingButton?) -> Driver<Element> {
        return self.do(onNext:      { [weak button] _ in button?.isLoading = false },
                       onSubscribe: { [weak button] in button?.isLoading = true    },
                       onDispose:   { [weak button] in button?.isLoading = false   })
    }
}

public extension SharedSequenceConvertibleType {
    func attach(_ loading: BehaviorRelay<Bool>?) -> RxCocoa.SharedSequence<Self.SharingStrategy, Self.Element> {
        return self.do(onNext:      { [weak loading] _ in loading?.accept(false)  },
                       onSubscribe: { [weak loading] in loading?.accept(true)     },
                       onDispose:   { [weak loading] in loading?.accept(false)    })
    }
    func attach(_ button: LoadingButton?) -> RxCocoa.SharedSequence<Self.SharingStrategy, Self.Element> {
        return self.do(onNext:      { [weak button] _ in
            button?.isLoading = false },
                       onSubscribe: { [weak button] in
                        button?.isLoading = true    },
                       onDispose:   { [weak button] in
                        button?.isLoading = false   })
    }
}

public extension ObservableType {
    func attach(_ loading: BehaviorRelay<Bool>?) -> Observable<Self.Element> {
        return self.do(onNext:      { [weak loading] _ in loading?.accept(false)  },
                       onSubscribe: { [weak loading] in loading?.accept(true)     },
                       onDispose:   { [weak loading] in loading?.accept(false)    })
    }
    
    func attach(_ button: LoadingButton?) -> Observable<Self.Element> {
        return self.do(onNext:      { [weak button] _ in button?.isLoading = false },
                       onSubscribe: { [weak button] in button?.isLoading = true    },
                       onDispose:   { [weak button] in button?.isLoading = false   })
    }
}


