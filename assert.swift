// YogaSwift
// Created by: resse

import Foundation

@inlinable
func __YogaSwiftAssertMainQueue() {
    assert(pthread_main_np() != 0, "This method must be called on the main thread")
}
