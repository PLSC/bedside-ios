//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AppSyncRealTimeClient

/// AWS Lambda Authorizer interceptor
class LambdaAuthInterceptor: AuthInterceptor {

    let authTokenProvider: AWSLambdaAuthProvider

    init(authTokenProvider: AWSLambdaAuthProvider) {
        self.authTokenProvider = authTokenProvider
    }

    func interceptMessage(_ message: AppSyncMessage, for endpoint: URL) -> AppSyncMessage {
        let host = endpoint.host!
        let authToken = authTokenProvider.getLatestAuthToken()
        guard case .subscribe = message.messageType else {
            return message
        }

        let authHeader = TokenAuthHeader(token: authToken, host: host)
        var payload = message.payload ?? AppSyncMessage.Payload()
        payload.authHeader = authHeader

        let signedMessage = AppSyncMessage(
            id: message.id,
            payload: payload,
            type: message.messageType
        )
        return signedMessage
    }

    func interceptConnection(
        _ request: AppSyncConnectionRequest,
        for endpoint: URL
    ) -> AppSyncConnectionRequest {
        let host = endpoint.host!
        let authToken = authTokenProvider.getLatestAuthToken()

        let authHeader = TokenAuthHeader(token: authToken, host: host)
        let base64Auth = AppSyncJSONHelper.base64AuthenticationBlob(authHeader)

        let payloadData = SubscriptionConstants.emptyPayload.data(using: .utf8)
        let payloadBase64 = payloadData?.base64EncodedString()

        guard var urlComponents = URLComponents(url: request.url, resolvingAgainstBaseURL: false) else {
            return request
        }
        let headerQuery = URLQueryItem(name: RealtimeProviderConstants.header, value: base64Auth)
        let payloadQuery = URLQueryItem(name: RealtimeProviderConstants.payload, value: payloadBase64)
        urlComponents.queryItems = [headerQuery, payloadQuery]
        guard let url = urlComponents.url else {
            return request
        }
        let signedRequest = AppSyncConnectionRequest(url: url)
        return signedRequest
    }
}

// MARK: - TokenAuthenticationHeader
/// Authentication header for user pool based auth
private class TokenAuthHeader: AuthenticationHeader {
    let authorization: String

    init(token: String, host: String) {
        self.authorization = token
        super.init(host: host)
    }

    private enum CodingKeys: String, CodingKey {
        case authorization = "Authorization"
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(authorization, forKey: .authorization)
        try super.encode(to: encoder)
    }
}
