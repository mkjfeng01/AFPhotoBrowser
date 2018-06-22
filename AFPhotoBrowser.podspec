Pod::Spec.new do |s|

  s.name = 'AFPhotoBrowser'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'PhotoBrowser plugin for `Cloud`'
  s.description = <<-DESCRIPTION
                  DESCRIPTION
  s.screenshots = [
  ]

  s.homepage = 'https://github.com/mkjfeng01/PhotoBrowser'
  s.author = { 'mkjfeng01' => 'mkjfeng01@gmail.com' }

  s.source = {
    :git => 'https://github.com/mkjfeng01/PhotoBrowser.git',
    :tag => '0.0.1'
  }
  s.platform = :ios, '10.0'
  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'AFPhotoBrowser' => ['Pod/Assets/*.png']
  }
  s.requires_arc = true

  s.frameworks = 'ImageIO', 'QuartzCore', 'AssetsLibrary', 'MediaPlayer'
  s.weak_frameworks = 'Photos'

  s.dependency 'MBProgressHUD'
  s.dependency 'DACircularProgress'
  s.dependency 'SDWebImage'

end
