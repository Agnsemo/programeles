//
//  Weekly.swift
//  Ananda
//
//  Created by Justas Liola on 24/10/2016.
//  Copyright © 2017 Mediapark. All rights reserved.
//
//  Credit to: http://blog.xebia.com/function-references-in-swift-and-retain-cycles/

import Foundation

func Weakly<T: AnyObject, U, V>(_ object: T, _ method: @escaping (T) -> ((U) -> V)) -> ((U) -> V) {
    return { [weak object] parameter in method(object!)(parameter) }
}

func Weakly<T: AnyObject, V>(_ object: T, _ method: @escaping (T) -> (() -> V)) -> (() -> V) {
    return { [weak object] in method(object!)() }
}

func Weakly2<T: AnyObject, U, U1, V>(_ object: T, _ method: @escaping (T) -> ((U, U1) -> V) ) -> (((U, U1)) -> V) {
    return { [weak object] args in method(object!)(args.0, args.1) }
}

func Weakly3<T: AnyObject, U, U1, U2, V>(_ object: T, _ method: @escaping (T) -> ((U, U1, U2) -> V) ) -> (((U, U1, U2)) -> V) {
    return { [weak object] args in method(object!)(args.0, args.1, args.2) }
}
