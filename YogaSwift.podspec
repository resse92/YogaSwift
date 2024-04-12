#
# Be sure to run `pod lib lint YogaSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'YogaSwift'
    s.version          = '0.0.1'
    s.summary          = 'more swift to use yoga'

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = 'more swift to use yoga'

    s.homepage         = 'https://github.com/resse92/YogaSwift'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'resse' => 'zrljp12@gmail.com' }
    s.source           = { :git => 'https://github.com/resse92/YogaSwift.git', :tag => s.version.to_s }

    s.ios.deployment_target = '10.0'
    
    s.default_subspec = 'core'
    
    s.subspec 'core' do |subspec|
        subspec.source_files = 'YogaSwift/Classes/**/*'
    end

    s.subspec 'yoga' do |subspec|
        subspec.source_files = "yoga/**/*.{h,m,mm,cpp,c}"
#        subspec.public_header_files = "yoga/Yoga.h"
        subspec.public_header_files = "yoga/*.h"

        subspec.compiler_flags = [
            '-fno-omit-frame-pointer',
            '-fexceptions',
            '-Wall',
            '-Werror',
            '-std=c++20',
            '-fPIC'
        ]

        subspec.libraries = 'c++'
        subspec.pod_target_xcconfig = {
            'DEFINES_MODULE' => 'YES',
            'HEADER_SEARCH_PATHS' => '"$(PODS_TARGET_SRCROOT)"',
            'OTHER_LDFLAGS' => '-l"stdc++"',
#            'OTHER_CPLUSPLUSFLAGS' => '-std=c++20', # 仅应用于 C++ 文件
        }
#        subspec.preserve_paths = 'yoga/**/*.h'
    end

end
