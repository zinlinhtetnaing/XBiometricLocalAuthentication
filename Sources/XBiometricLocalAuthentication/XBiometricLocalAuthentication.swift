import Foundation
import LocalAuthentication

public class XBiometricLocalAuthentication: NSObject {
    
    // MARK: - Singleton
    public static let shared = XBiometricLocalAuthentication()
    
    // MARK: - Private
    private override init() {}
    
    public var allowableReuseDuration: TimeInterval = 0
    
    var isFaceIdDevice: Bool {
        let context = LAContext()
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType == .faceID
    }
    
    //TODO: - checks if biometric authentication can be performed currently on the device.
    var enrolledBiometric: Bool {
        var error: NSError?
        let context = LAContext()
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    //MARK: - Check for biometric authentication
    public func authenticateWithBioMetrics(reason: String = "", fallbackTitle: String? = "", cancelTitle: String = "", completion: @escaping (Result<Bool, AuthenticationError>) -> ()) {
        
        // reason
        let reasonString = reason.isEmpty ? defaultBiometricAuthenticationReason : reason
        let context = LAContext()
        context.touchIDAuthenticationAllowableReuseDuration = allowableReuseDuration
        context.localizedFallbackTitle = fallbackTitle
        context.localizedCancelTitle = cancelTitle.isEmpty ? defaultBiometricLocalizedCancelTitle : cancelTitle
        
        // authenticate
        evaluate(policy: .deviceOwnerAuthenticationWithBiometrics, with: context, reason: reasonString, completion: completion)
    }
    
    //TODO: - checks if device supports face id and authentication can be done
    var faceIDAvailable: Bool {
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return canEvaluate && context.biometryType == .faceID
    }
    
    //TODO: - get authentication reason to show while authentication
    private var defaultBiometricAuthenticationReason: String {
        return faceIDAvailable ? faceIdAuthenticationReason : touchIdAuthenticationReason
    }
    
    //TODO: - canel title to show while authentication
    private var defaultBiometricLocalizedCancelTitle: String {
        return faceIDAvailable ? dontUseFaceId : dontUseTouchId
    }
    
    //MARK: - evaluate policy
    private func evaluate( policy: LAPolicy, with context: LAContext, reason: String, completion: @escaping (Result<Bool, AuthenticationError>) -> ()) {
        context.evaluatePolicy(policy, localizedReason: reason) { (success, error) in
            DispatchQueue.main.async {
                guard success else { return completion(.failure(AuthenticationError.biometricError(error as! LAError))) }
                completion(.success(true))
            }
        }
    }
    
}
