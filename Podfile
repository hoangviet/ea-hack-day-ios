platform :ios, '8.0'

use_frameworks!

# Add Application pods here
pod 'RealmSwift'
pod 'JVFloatLabeledTextField'
pod 'SVPullToRefresh'
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'ReactiveCocoa'
pod 'FSLineChart'
pod 'Parse'

target :unit_tests, :exclusive => true do
  link_with 'UnitTests'
  pod 'Realm/Headers'
  pod 'Specta'
  pod 'Expecta'
  pod 'OCMock'
  pod 'OHHTTPStubs'
end
