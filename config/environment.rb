config.plugin_paths += %W( #{RAILS_ROOT}/vendor/plugins/cms-engine/vendor/plugins )
config.plugins = [ :find_by_param, :all ]

config.autoload_paths += %W( #{RAILS_ROOT}/vendor/plugins/cms-engine/app/models/page_types )

config.gem "mislav-will_paginate", :version => ">= 2.3.0", :lib => "will_paginate", :source => "http://gems.github.com"
config.gem "authlogic", :version => "<= 2.1.3"
config.gem "resource_controller", :version => ">= 0.6.6"
config.gem 'RedCloth', :lib => 'redcloth'
config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"
config.gem 'faker'
config.gem 'cucumber'
config.gem 'ancestry'
