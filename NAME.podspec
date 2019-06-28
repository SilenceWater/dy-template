#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = '${POD_NAME}'
  s.version          = '0.0.1'
  s.summary          = 'A short description of ${POD_NAME}.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://192.168.6.115:7990/projects/XDWIOS/repos/${POD_NAME}/browse'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '吕同生' => '${USER_EMAIL}' }
  s.source           = { :git => 'ssh://git@192.168.6.115:7999/xdwios/${POD_NAME}.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = '${POD_NAME}/Classes/**/*'
  
  s.resources = '${POD_NAME}/Assets/${POD_NAME}.xcassets'
  
  s.dependency 'SAKit'
  s.dependency 'SAFoundation'
  s.dependency 'SAModuleService'
  s.dependency 'SAConfig'
  s.dependency 'SALocalizable'
  s.dependency 'SASpecialRequest'
  s.dependency 'SANetwork'
  s.dependency 'SANetworkHUD'
  s.dependency 'SAGlobal'
  
  s.requires_arc = true
end
