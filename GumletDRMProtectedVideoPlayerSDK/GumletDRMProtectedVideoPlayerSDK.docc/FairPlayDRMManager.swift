//
//  FairPlayDRMManager.swift
//  GumletDRMProtectedVideoPlayerSDK
//
//  Created by Khushboo Sharma on 29/01/26.
//

import Foundation
import AVFoundation

final class FairPlayDRMManager: NSObject {

    private let configuration: DRMConfiguration
    private let contentKeySession: AVContentKeySession

    init(configuration: DRMConfiguration) {
        self.configuration = configuration
        self.contentKeySession = AVContentKeySession(
            keySystem: .fairPlayStreaming
        )
        super.init()

        contentKeySession.setDelegate(self, queue: DispatchQueue(label: "fairplay.queue"))
    }

    func addAsset(_ asset: AVURLAsset) {
        contentKeySession.addContentKeyRecipient(asset)
    }

    private func loadCertificate() throws -> Data {
        return try Data(contentsOf: configuration.certificateURL)
    }

    private func requestCKC(spcData: Data,
                            completion: @escaping (Data?) -> Void) {

        var request = URLRequest(url: configuration.licenseServerURL)
        request.httpMethod = "POST"
        request.httpBody = spcData
        request.setValue("application/octet-stream",
                         forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            completion(data)
        }.resume()
    }
}

// MARK: - AVContentKeySessionDelegate
extension FairPlayDRMManager: AVContentKeySessionDelegate {

    func contentKeySession(_ session: AVContentKeySession,
                           didProvide keyRequest: AVContentKeyRequest) {
        Task {
            do {
                let certificate = try loadCertificate()

                let spcData = try await keyRequest.makeStreamingContentKeyRequestData(
                    forApp: certificate,
                    contentIdentifier: configuration.contentID.data(using: .utf8)!,
                    options: nil
                )

                requestCKC(spcData: spcData) { ckcData in
                    guard let ckc = ckcData else {
                        keyRequest.processContentKeyResponseError(
                            NSError(domain: "CKCError", code: -1)
                        )
                        return
                    }

                    let response = AVContentKeyResponse(
                        fairPlayStreamingKeyResponseData: ckc
                    )
                    keyRequest.processContentKeyResponse(response)
                }

            } catch {
                keyRequest.processContentKeyResponseError(error)
            }
        }
    }
}
