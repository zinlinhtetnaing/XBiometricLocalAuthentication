//
//  XBiometricLocalAuthentication+Error.swift
//  
//
//  Created by Zin Lin Htet Naing on 28/08/2023.
//

import Foundation
import LocalAuthentication

let biometryNotAvailableReason = "Biometric authentication is not available for this device."
let authenticationFail = "There was a problem verifying your identity."
let userCancel = "You pressed cancel."
let userFallback = "You pressed password."
let systemCancel = "System have been Cancel."

//TODO: TouchID
let touchIdAuthenticationReason = "Confirm your fingerprint to authenticate."
let touchIdPasscodeAuthenticationReason = "Touch ID is locked now, because of too many failed attempts."
let dontUseTouchId = "Don't Use Touch ID"

//TODO: Error Messages Touch ID
let setPasscodeToUseTouchID = "Please set device passcode to use Touch ID for authentication."
let noFingerprintEnrolled = "There are no fingerprints enrolled in the device. Please go to Device Settings -> Touch ID & Passcode and enroll your fingerprints."
let defaultTouchIDAuthenticationFailedReason = "Touch ID does not recognize your fingerprint. Please try again with your enrolled fingerprint."

//TODO: FaceID
let faceIdAuthenticationReason = "Confirm your face to authenticate."
let faceIdPasscodeAuthenticationReason = "Face ID is locked now, because of too many failed attempts."
let dontUseFaceId = "Don't Use Face ID"

//TODO: Error Messages Face ID
let setPasscodeToUseFaceID = "Please set device passcode to use Face ID for authentication."
let noFaceIdentityEnrolled = "There is no face enrolled in the device. Please go to Device Settings -> Face ID & Passcode and enroll your face."
let defaultFaceIDAuthenticationFailedReason = "Face ID does not recognize your face. Please try again with your enrolled face."


public enum AuthenticationError: LocalizedError {
    case authenticationFailed
    case canceledByUser
    case fallback
    case canceledBySystem
    case passcodeNotSet
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockedout
    case other
    
    static func biometricError(_ error: LAError) -> AuthenticationError {
        switch Int32(error.errorCode) {
        case kLAErrorAuthenticationFailed:
            return .authenticationFailed
        case  kLAErrorUserCancel:
            return .canceledByUser
        case kLAErrorUserFallback:
            return .fallback
        case kLAErrorSystemCancel:
            return .canceledBySystem
        case kLAErrorPasscodeNotSet:
            return .passcodeNotSet
        case kLAErrorBiometryNotAvailable:
            return .biometryNotAvailable
        case kLAErrorBiometryNotEnrolled:
            return .biometryNotEnrolled
        case kLAErrorBiometryLockout:
            return .biometryLockedout
        default:
            return .other
        }
    }
    
    public var errorDescription: String {
        let isFaceIdDevice = XBiometricLocalAuthentication.shared.isFaceIdDevice
        switch self {
        case .authenticationFailed:
            return authenticationFail
        case .canceledByUser:
            return userCancel
        case .fallback:
            return userFallback
        case .canceledBySystem:
            return systemCancel
        case .passcodeNotSet:
            return isFaceIdDevice ? setPasscodeToUseFaceID : setPasscodeToUseTouchID
        case .biometryNotAvailable:
            return biometryNotAvailableReason
        case .biometryNotEnrolled:
            return isFaceIdDevice ? noFaceIdentityEnrolled : noFingerprintEnrolled
        case .biometryLockedout:
            return isFaceIdDevice ? faceIdPasscodeAuthenticationReason : touchIdPasscodeAuthenticationReason
        case .other:
            return isFaceIdDevice ? defaultFaceIDAuthenticationFailedReason : defaultTouchIDAuthenticationFailedReason
        }
    }
    
}
