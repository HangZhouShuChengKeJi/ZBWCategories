#
#  Be sure to run `pod spec lint ZBWCategories.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "ZBWCategories"
  s.version      = "0.1.14"
  s.summary      = "类别扩展类."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                    各种常用类的类别扩展。
                    1、NSObject JSON扩展；序列化+反序列化；
                    2、NSObject 自动归档+反序列化；
                    3、NSObject 深拷贝、浅拷贝；
                    4、其他常用类扩展；例如NSTimer等
                    5、UIKit相关类扩展。包括UIImageView、UIButton、UIView等；
                   DESC

  s.homepage     = "https://github.com/HangZhouShuChengKeJi/ZBWCategories"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "BSD"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "bwzhu" => "bowen.zhu@91chengguo.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/HangZhouShuChengKeJi/ZBWCategories.git", :tag => "#{s.version}" }

  s.source_files  = "ZBWCategories", "ZBWCategories/*.{h,m,mm}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  s.subspec 'NSFoundation+ZBWCategory' do |foundationSpec|
    foundationSpec.source_files = "ZBWCategories/NSFoundation+ZBWCategory/*.{h,m,mm}"

    foundationSpec.subspec 'NSObject+ZBWCategory' do |nsobjectSpec|
      nsobjectSpec.source_files = "ZBWCategories/NSFoundation+ZBWCategory/NSObject+ZBWCategory/*.{h,m,mm}"
    end
  end

  s.subspec 'UIKit+ZBWCategory' do |uikitSpec|
    uikitSpec.source_files = "ZBWCategories/UIKit+ZBWCategory/**/*.{h,m,mm}"
  end

  s.requires_arc = true

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.prefix_header_contents = '#import <ZBWCategories/ZBWCategories.h>'

  s.dependency 'SDWebImage'
  s.dependency 'ZBWJson'

end
