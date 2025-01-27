

Pod::Spec.new do |s|
  s.name             = 'Swiftronix'
  s.version          = '1.0.1'
  s.summary          = 'A combined library with Alamofire, SwiftyJSON'
  s.description      = 'This pod includes popular Swift libraries such as Alamofire, SwiftyJSON'
  s.homepage         = 'https://github.com/abhiganesh1610/Swiftronix'
  s.license          = { :type => 'MIT', :text => 'https://opensource.org/licenses/MIT' }
  s.author           = { 'Ganesh' => 'abhiganesh16101999@gmail.com' }
  s.source           = { :git => 'https://github.com/abhiganesh1610/Swiftronix.git', :tag => s.version }
  s.source_files     = 'Swiftronix/Main.swift'
  s.swift_versions   = '5.0'
  s.ios.deployment_target = '11.0'


  # Add dependencies here



end

