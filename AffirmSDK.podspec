Pod::Spec.new do |spec|
    spec.name                   = "AffirmSDK"
    spec.authors                = "Affirm, Inc."
    spec.version                = "4.0.12"
    spec.summary                = "Integrate Affirm into your iOS app"
    spec.homepage               = "https://github.com/Affirm/affirm-ios-sdk"
    spec.license                = { :type => "BSD-3-Clause", :file => "LICENSE.txt" }
    spec.source                 = { :git => "https://github.com/Affirm/affirm-ios-sdk.git", :tag => spec.version }
    spec.source_files           = "AffirmSDK/*.{h,m}"
    spec.platform               = :ios, "7.0"
    spec.ios.deployment_target  = "7.0"
    spec.resource               = "AffirmSDK/AffirmSDK.bundle"
end
