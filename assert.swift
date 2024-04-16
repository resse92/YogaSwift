// YogaSwift
// Created by: resse

import Foundation

@inlinable
func AssertMainQueue() {
    assert(pthread_main_np() != 0, "This method must be called on the main thread")
}
