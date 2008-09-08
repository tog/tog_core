require_plugin 'acts_as_commentable'

Tog::Plugins.settings :tog_core,  'language.default'          => "en",
                                  'host.name'                 => "0.0.0.0",
                                  'host.port'                 => 3000,
                                  'mail.system_from_address'  => "Tog Admin <tog@linkingpaths.com>",
                                  'mail.default_subject'      => "[Tog Community] "

require "url_writer_retardase_inhibitor"
require "acts_as_commentable_patch"
require "will_paginate"

Tog::Interface.sections(:admin).add "Home", "/admin"          
Tog::Interface.sections(:member).add "Home", "/"     
Tog::Interface.sections(:site).add "Home", "/"     


