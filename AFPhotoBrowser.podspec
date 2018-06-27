Pod::Spec.new do |s|

  s.name = 'AFPhotoBrowser'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'Photo browser plugin with vertical and horizontal scroll.'
  s.description = <<-DESCRIPTION
                  AFPhotoBrowser is based on MWPhotoBrowser, I deprecated some API and add some new features, such as vertical scroll.
                  DESCRIPTION
  s.screenshots = [
  ]

  s.homepage = 'https://github.com/mkjfeng01/AFPhotoBrowser'
  s.author = { 'mkjfeng01' => 'mkjfeng01@gmail.com' }

  s.source = {
    :git => 'https://github.com/mkjfeng01/AFPhotoBrowser.git',
    :tag => '0.0.1'
  }
  s.platform = :ios, '10.0'
  s.source_files = 'Pod/Classes/**/*'
#  s.resource_bundles = {
#    'AFPhotoBrowser' => ['Pod/Assets/*.png']
#  }
  s.requires_arc = true

  s.frameworks = 'ImageIO', 'QuartzCore', 'AssetsLibrary', 'MediaPlayer'
  s.weak_frameworks = 'Photos'

  s.dependency 'MBProgressHUD'
  s.dependency 'DACircularProgress'
  s.dependency 'SDWebImage'

end
