# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

def shared_pods
   
    pod 'GooglePlaces'
    pod 'GooglePlacePicker'
    pod 'GoogleMaps'
    pod 'Alamofire'
    pod 'SVProgressHUD'
    pod 'ObjectMapper'
    pod 'SDWebImage'
    pod 'IQKeyboardManagerSwift', :git => 'https://github.com/hackiftekhar/IQKeyboardManager'
    pod 'ActionSheetPicker-3.0'
    pod 'EAFeatureGuideView'
    
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    
   pod 'Firebase/Auth'

    pod 'FirebaseUI'
    pod 'FirebaseUI/Auth'
    pod 'FirebaseUI/Google'
    pod 'FirebaseUI/Facebook'
    pod 'FirebaseUI/Twitter'
    pod 'FirebaseUI/Phone'
    
    
    pod 'TwitterKit'
    pod 'WechatOpenSDK'
    pod 'GoogleSignIn'
    pod 'SnapKit'
    pod 'DACircularProgress'
    pod 'JSQMessagesViewController'
    pod 'SideMenu'
    
 
    
end
    


target 'HumeApp_V1' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    shared_pods
   
    
    target 'HumeApp_V1Tests' do
        inherit! :search_paths
        # Pods for testing
        shared_pods
    end
    
    target 'HumeApp_V1UITests' do
        inherit! :search_paths
        # Pods for testing
        
    end
    
end
