

Pod::Spec.new do |s|
  s.name             = 'Swiftronix'
  s.version          = '1.0.0'
  s.summary          = 'A combined library with Alamofire, SwiftyJSON'
  s.description      = 'This pod includes popular Swift libraries such as Alamofire, SwiftyJSON'
  s.homepage         = 'https://github.com/abhiganesh1610/Swiftronix'
  s.license          = { :type => 'MIT', :text => 'https://opensource.org/licenses/MIT' }
  s.author           = { 'Ganesh' => 'abhiganesh16101999@gmail.com' }
  s.source           = { :git => 'https://github.com/abhiganesh1610/Swiftronix.git', :tag => '1.0.0' }
  s.ios.deployment_target = '11.0'

  # Specify the source files
  s.source_files     = 'Swiftronix/Main.swift'

  # Add dependencies here


  # Specify Swift version
  s.swift_versions = '5.0'


end

