//
//  DRMConfiguration.swift
//  GumletDRMProtectedVideoPlayerSDK
//
//  Created by Khushboo Sharma on 29/01/26.
//

import Foundation

public struct DRMConfiguration {
    public let licenseServerURL: URL
    public let certificateURL: URL
    public let contentID: String

    public init(licenseServerURL: URL,
                certificateURL: URL,
                contentID: String) {
        self.licenseServerURL = licenseServerURL
        self.certificateURL = certificateURL
        self.contentID = contentID
    }
}
