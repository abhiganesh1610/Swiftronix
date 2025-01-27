//
//  Main.swift
//  Swiftronix
//
//  Created by Ganesh on 27/12/24.
//

import SwiftUI
import Foundation


// MARK: - API CALLING -
public enum NetworkError: Error {
    case badRequest
    case decodingError(Error)
    case invalidResponse
    case errorResponse(ErrorResponse)
}

extension NetworkError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
            case .badRequest:
                return NSLocalizedString("Bad Request (400): Unable to perform the request.", comment: "badRequestError")
            case .decodingError(let error):
                return NSLocalizedString("Unable to decode successfully. \(error)", comment: "decodingError")
            case .invalidResponse:
                return NSLocalizedString("Invalid response.", comment: "invalidResponse")
            case .errorResponse(let errorResponse):
                return NSLocalizedString("Error \(errorResponse.message ?? "")", comment: "Error Response")
        }
    }
}

public enum HTTPMethod {
    case get([URLQueryItem])
    case post(Data?)
    case delete
    case put(Data?)
    
    var name: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .delete:
                return "DELETE"
            case .put:
                return "PUT"
        }
    }
}

public struct Resource<T: Codable> {
    let url: URL
    var method: HTTPMethod = .get([])
    var headers: [String: String]? = nil
    var modelType: T.Type
}

public struct HTTPClient {
    
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        self.session = URLSession(configuration: configuration)
    }
    
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        
        var request = URLRequest(url: resource.url)
        
        // Set HTTP method and body if needed
        switch resource.method {
            case .get(let queryItems):
                var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
                components?.queryItems = queryItems
                guard let url = components?.url else {
                    throw NetworkError.badRequest
                }
                request.url = url
                
            case .post(let data), .put(let data):
                request.httpMethod = resource.method.name
                request.httpBody = data
                
            case .delete:
                request.httpMethod = resource.method.name
        }
        
        // Set custom headers
        if let headers = resource.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Check for specific HTTP errors
        switch httpResponse.statusCode {
            case 200...299:
                break // Success
            default:
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkError.errorResponse(errorResponse)
        }
        
        do {
            let result = try JSONDecoder().decode(resource.modelType, from: data)
            return result
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}


public struct ErrorResponse: Codable {
    let message: String?
}











//
//#
//#  Be sure to run `pod spec lint Swiftronix.podspec' to ensure this is a
//#  valid spec and to remove all comments including this before submitting the spec.
//#
//#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
//#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
//#
//
//Pod::Spec.new do |spec|
//
//  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
//  #
//  #  These will help people to find your library, and whilst it
//  #  can feel like a chore to fill in it's definitely to your advantage. The
//  #  summary should be tweet-length, and the description more in depth.
//  #
//
//  spec.name         = "Swiftronix"
//  spec.version      = "0.0.1"
//  spec.summary      = "A short description of Swiftronix."
//
//  # This description is used to generate tags and improve search results.
//  #   * Think: What does it do? Why did you write it? What is the focus?
//  #   * Try to keep it short, snappy and to the point.
//  #   * Write the description between the DESC delimiters below.
//  #   * Finally, don't worry about the indent, CocoaPods strips it!
//  spec.description  = <<-DESC
//                   DESC
//
//  spec.homepage     = "http://EXAMPLE/Swiftronix"
//  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
//
//
//  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
//  #
//  #  Licensing your code is important. See https://choosealicense.com for more info.
//  #  CocoaPods will detect a license file if there is a named LICENSE*
//  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
//  #
//
//  spec.license      = "MIT (example)"
//# spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
//
//
//  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
//  #
//  #  Specify the authors of the library, with email addresses. Email addresses
//  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
//  #  accepts just a name if you'd rather not provide an email address.
//  #
//  #  Specify a social_media_url where others can refer to, for example a twitter
//  #  profile URL.
//  #
//
//  spec.author             = { "Ganesh" => "ganesh@zeoner.com" }
//  # Or just: spec.author    = "Ganesh"
//  # spec.authors            = { "Ganesh" => "ganesh@zeoner.com" }
//  # spec.social_media_url   = "https://twitter.com/Ganesh"
//
//  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
//  #
//  #  If this Pod runs only on iOS or OS X, then specify the platform and
//  #  the deployment target. You can optionally include the target after the platform.
//  #
//
//  # spec.platform     = :ios
//  # spec.platform     = :ios, "5.0"
//
//  #  When using multiple platforms
//  # spec.ios.deployment_target = "5.0"
//  # spec.osx.deployment_target = "10.7"
//  # spec.watchos.deployment_target = "2.0"
//  # spec.tvos.deployment_target = "9.0"
//  # spec.visionos.deployment_target = "1.0"
//
//
//  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
//  #
//  #  Specify the location from where the source should be retrieved.
//  #  Supports git, hg, bzr, svn and HTTP.
//  #
//
//  spec.source       = { :git => "http://EXAMPLE/Swiftronix.git", :tag => "#{spec.version}" }
//
//
//  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
//  #
//  #  CocoaPods is smart about how it includes source code. For source files
//  #  giving a folder will include any swift, h, m, mm, c & cpp files.
//  #  For header files it will include any header in the folder.
//  #  Not including the public_header_files will make all headers public.
//  #
//
//  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
//  spec.exclude_files = "Classes/Exclude"
//
//  # spec.public_header_files = "Classes/**/*.h"
//
//
//  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
//  #
//  #  A list of resources included with the Pod. These are copied into the
//  #  target bundle with a build phase script. Anything else will be cleaned.
//  #  You can preserve files from being cleaned, please don't preserve
//  #  non-essential files like tests, examples and documentation.
//  #
//
//  # spec.resource  = "icon.png"
//  # spec.resources = "Resources/*.png"
//
//  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"
//
//
//  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
//  #
//  #  Link your library with frameworks, or libraries. Libraries do not include
//  #  the lib prefix of their name.
//  #
//
//  # spec.framework  = "SomeFramework"
//  # spec.frameworks = "SomeFramework", "AnotherFramework"
//
//  # spec.library   = "iconv"
//  # spec.libraries = "iconv", "xml2"
//
//
//  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
//  #
//  #  If your library depends on compiler flags you can set them in the xcconfig hash
//  #  where they will only apply to your library. If you depend on other Podspecs
//  #  you can include multiple dependencies to ensure it works.
//
//  # spec.requires_arc = true
//
//  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
//  # spec.dependency "JSONKit", "~> 1.4"
//
//end
//
//
