require_plugin 'acts_as_commentable'
require_plugin 'acts_as_scribe'
require_plugin 'acts_as_taggable_on_steroids'
require_plugin 'acts_as_abusable'
require_plugin 'viking'

# require the will_paginate as a gem. This could be ´config.gem´ as well.
require "will_paginate"


Tog::Plugins.settings :tog_core,  'language.default'          => "en",
                                  'host.name'                 => "0.0.0.0",
                                  'host.port'                 => 3000,
                                  'site.name'                 => "toginstallation.com",                                  
                                  'mail.system_from_address'  => "Tog Admin <tog@linkingpaths.com>",
                                  'mail.default_subject'      => "[Tog Installation] ",
                                  'patch_field_error_proc'    => true,
                                  'pagination_size'           => 50

Tog::Plugins.settings :tog_core,  'spam.engine' => '', # 'defensio' || 'akismet'
                                  'spam.key'    => '', # api key
                                  'spam.url'    => ''  # url registered in spam engine

Tog::Plugins.settings :tog_core,  'sanitized.allowed_tags'       => (ActionView::Base.sanitized_allowed_tags.to_a + %w( object param embed )).join(' '),
                                  'sanitized.allowed_attributes' => (ActionView::Base.sanitized_allowed_attributes.to_a + %w( name width height value src href )).join(' '),
                                  'sanitized.comments.allowed_tags' => ActionView::Base.sanitized_allowed_tags.to_a.join(' '),
                                  'sanitized.comments.allowed_attributes' => ActionView::Base.sanitized_allowed_attributes.to_a.join(' ')


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

Tog::Plugins.helpers CoreHelper

Tog::Interface.sections(:admin).add "Home", "/admin/dashboard" 

Tog::Interface.sections(:admin).add "Manage", "/admin/configuration"
Tog::Interface.sections(:admin).tabs("Manage").add_item "Configuration", "/admin/configuration"
Tog::Interface.sections(:admin).tabs("Manage").add_item "Abuses", "/admin/manage_abuses"

Tog::Interface.sections(:member).add "Home", "/"     
Tog::Interface.sections(:site).add "Home", "/"     


