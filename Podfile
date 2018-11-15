# Uncomment the next line to define a global platform for your project
#source 'https://github.com/CocoaPods/Specs.git'
 platform :ios, '9.0'
  use_frameworks!
target 'LeqiEnglishIOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks

pod 'Alamofire'
pod 'SQLite.swift', '~> 0.11.4'
#pod 'Kingfisher'
pod 'MJRefresh'

# 主模块(必须)
pod 'mob_sharesdk'

# UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
pod 'mob_sharesdk/ShareSDKUI'

# 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
pod 'mob_sharesdk/ShareSDKPlatforms/QQ'
pod 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
#（微信sdk不带支付的命令）
pod 'mob_sharesdk/ShareSDKPlatforms/WeChat'

#pod 'mob_sharesdk/ShareSDKPlatforms/WeChatFull'
#（微信sdk带支付的命令，和上面不带支付的不能共存，只能选择一个）

# 使用配置文件分享模块（非必需）
pod 'mob_sharesdk/ShareSDKConfigFile'

# 扩展模块（在调用可以弹出我们UI分享方法的时候是必需的）
pod 'mob_sharesdk/ShareSDKExtension'

# ShareSDK目前支持一下平台移除平台SDK（不影响分享和授权等功能）
# 使用以下平台语句替换ShareSDKPlatforms模块的语句即可
#pod 'ShareSDK3/PlatformConnector/QQ'
#pod 'ShareSDK3/PlatformConnector/SinaWeibo'
#pod 'ShareSDK3/PlatformConnector/WeChat'
#pod 'ShareSDK3/PlatformConnector/AliPaySocial'
  # Pods for LeqiEnglishIOS

end
