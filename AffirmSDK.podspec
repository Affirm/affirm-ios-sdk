Pod::Spec.new do |spec|
    spec.name                   = "AffirmSDK"
    spec.authors                = "Affirm, Inc."
    spec.version                = "2.2.0"
    spec.summary                = "Integrate Affirm into your iOS app"
    spec.homepage               = "https://github.com/Affirm/affirm-ios-sdk"
    spec.license                = { :type => "BSD-3-Clause", :file => "LICENSE.txt" }
    spec.source                 = { :git => "https://github.com/Affirm/affirm-ios-sdk.git", :tag => spec.version.to_s }
    spec.source_files           = "AffirmSDK.framework/Versions/A/Headers/*.h"
    spec.platform               = :ios, "7.0"
    spec.ios.deployment_target  = "7.0"
    spec.vendored_frameworks    = "AffirmSDK.framework"
    spec.public_header_files    = "AffirmSDK.framework/Versions/A/Headers/*.h"
    spec.resource               = "AffirmSDK.bundle"
end
