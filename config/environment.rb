config.plugin_paths += %W( #{RAILS_ROOT}/vendor/plugins/cms-engine/vendor/plugins )
config.plugins = [ :find_by_param, :all ]

config.autoload_paths += %W( #{RAILS_ROOT}/vendor/plugins/cms-engine/app/models/page_types )

config.gem "will_paginate"
config.gem "authlogic", :version => "<= 2.1.3"
config.gem "resource_controller", :version => ">= 0.6.6"
config.gem 'RedCloth', :lib => 'redcloth'
config.gem "factory_girl"
config.gem 'faker'
config.gem 'cucumber'
config.gem 'ancestry'
