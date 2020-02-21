#
#  Be sure to run `pod spec lint JarvisKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "JarvisKit"
  spec.version      = "1.0.0"
  spec.summary      = "JarvisKit is an elegant debug tool for iOS development."
  spec.description  = "JarvisKit is an elegant debug tool for iOS development. Such as sandbox manager, NSUserDefaults manager, Network capture, Crash log etc."


  spec.homepage     = "https://github.com/codingiran/JarvisKit"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = { "codingiran" => "codingiran@gmail.com" }
  spec.social_media_url   = "https://weibo.com/iranq"
  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/codingiran/JarvisKit.git", :tag => "#{spec.version}" }
  spec.source_files = "JarvisKit/**/*.{h,m}"
  spec.resource     = "JarvisKit/JarvisKit.bundle"

  spec.requires_arc = true

  spec.dependency "LookinServer"
  spec.dependency "MLeaksFinder"

end
