// mic-users.swift
// Prints the bundle ID of every app currently using a microphone, one per line.
// Requires macOS 14.2+ (Core Audio process objects).
// Build: swiftc -O mic-users.swift -o mic-users

import CoreAudio
import Foundation

func addr(_ selector: AudioObjectPropertySelector) -> AudioObjectPropertyAddress {
    AudioObjectPropertyAddress(
        mSelector: selector,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain)
}

func processObjects() -> [AudioObjectID] {
    var a = addr(kAudioHardwarePropertyProcessObjectList)
    var size: UInt32 = 0
    let system = AudioObjectID(kAudioObjectSystemObject)
    guard AudioObjectGetPropertyDataSize(system, &a, 0, nil, &size) == noErr, size > 0 else { return [] }
    var ids = [AudioObjectID](repeating: 0, count: Int(size) / MemoryLayout<AudioObjectID>.size)
    guard AudioObjectGetPropertyData(system, &a, 0, nil, &size, &ids) == noErr else { return [] }
    return ids
}

func isUsingMic(_ id: AudioObjectID) -> Bool {
    var a = addr(kAudioProcessPropertyIsRunningInput)
    var value: UInt32 = 0
    var size = UInt32(MemoryLayout<UInt32>.size)
    guard AudioObjectGetPropertyData(id, &a, 0, nil, &size, &value) == noErr else { return false }
    return value != 0
}

func bundleID(_ id: AudioObjectID) -> String? {
    var a = addr(kAudioProcessPropertyBundleID)
    var ref: Unmanaged<CFString>? = nil
    var size = UInt32(MemoryLayout<Unmanaged<CFString>?>.size)
    let status = withUnsafeMutablePointer(to: &ref) {
        AudioObjectGetPropertyData(id, &a, 0, nil, &size, $0)
    }
    guard status == noErr, let s = ref?.takeRetainedValue() else { return nil }
    let str = s as String
    return str.isEmpty ? nil : str
}

func pid(_ id: AudioObjectID) -> pid_t {
    var a = addr(kAudioProcessPropertyPID)
    var value: pid_t = -1
    var size = UInt32(MemoryLayout<pid_t>.size)
    _ = AudioObjectGetPropertyData(id, &a, 0, nil, &size, &value)
    return value
}

for obj in processObjects() where isUsingMic(obj) {
    print(bundleID(obj) ?? "pid:\(pid(obj))")
}
