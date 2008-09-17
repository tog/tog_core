require_plugin 'acts_as_commentable'
require_plugin 'acts_as_scribe'
require_plugin 'acts_as_taggable_on_steroids'

# require the will_paginate as a gem. This could be ´config.gem´ as well.
require "will_paginate"


Tog::Plugins.settings :tog_core,  'language.default'          => "en",
                                  'host.name'                 => "0.0.0.0",
                                  'host.port'                 => 3000,
                                  'site.name'                 => "toginstallation.com",                                  
                                  'mail.system_from_address'  => "Tog Admin <tog@linkingpaths.com>",
                                  'mail.default_subject'      => "[Tog Installation] ",
                                  'patch_field_error_proc'    => true

require "active_record_helper_patch"
require "acts_as_commentable_patch"
require "reloadable_plugins_patch"
require "url_writer_retardase_inhibitor"


# We've backported i18n-0.0.1 from rails to Tog, allowing pre-Rails 2.2 to use Backend::Simple
# until they're upgraded is released and we see widespread adoption of it.
require "i18n" unless defined?(I18n)
Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_translations file
end



Tog::Interface.sections(:admin).add "Home", "/admin" 
Tog::Interface.sections(:admin).add "Configuration", "/admin/configuration"         
Tog::Interface.sections(:member).add "Home", "/"     
Tog::Interface.sections(:site).add "Home", "/"     


