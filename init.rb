require_plugin 'acts_as_commentable'

Tog::Plugins.settings :tog_core,  'language.default'          => "en",
                                  'host.name'                 => "0.0.0.0",
                                  'host.port'                 => 3000,
                                  'site.name'                 => "toginstallation.com",                                  
                                  'mail.system_from_address'  => "Tog Admin <tog@linkingpaths.com>",
                                  'mail.default_subject'      => "[Tog Installation] ",
                                  'patch_field_error_proc'    => true

require "url_writer_retardase_inhibitor"
require "acts_as_commentable_patch"
require "will_paginate"
require "active_record_helper_patch"

Tog::Interface.sections(:admin).add "Home", "/admin"          
Tog::Interface.sections(:member).add "Home", "/"     
Tog::Interface.sections(:site).add "Home", "/"     


