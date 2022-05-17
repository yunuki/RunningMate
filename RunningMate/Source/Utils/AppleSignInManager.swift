//
//  AppleSignInManager.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import Foundation
import AuthenticationServices

protocol AppleSignInManagerDelegate: AnyObject {
    func success(authorizationCode: String)
    func fail(error: AppleSignInManager.AppleSignInError)
}

final class AppleSignInManager: NSObject {
    
    enum AppleSignInError: Error {
        case authorization
        case decode
    }
    
    weak var viewController: UIViewController?
    weak var delegate: AppleSignInManagerDelegate?
    
    func setAppleSignInPresentationAnchorView(_ vc: UIViewController?) {
        self.viewController = vc
    }
}

extension AppleSignInManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController!.view.window!
    }
}

extension AppleSignInManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let authorizationCodeData = credential.authorizationCode,
              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else {
            delegate?.fail(error: .decode)
            return
        }
        
        print(authorizationCode)
        delegate?.success(authorizationCode: authorizationCode)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.fail(error: .authorization)
    }
}
