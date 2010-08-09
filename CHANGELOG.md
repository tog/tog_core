Edge
----

* Saving referer for comment, so we can get back to he commented object from a comment list
* Admin view for managing comments
* filter_item method for filtering lists in admin views moved here from tog_users

0.6.0
----

* Added acts_as_shareable to installation template, used by tog_social
* EDGE version installation installs EDGE versions of tog's core plugins
* Added config.reload_plugins entry to development environment
* acts_as_commentable is now installed as gem
* Flash setted after abuse report (kudos to Andrei Erdoss)
* Caching Tog::Config values
* Installation template now asks about installing gems as sudo
* new generator for creating plugin's migrations, on installation and after updates
* using acts_as_rateable and acts_as_shareable as plugins, which fixes problem with timestamps while installing
* using acts_as_taggable_on instead of acts_as_taggable_on_steroids_
* comments can be posted to twitter (kudos to boonious)
* for comments notification, commentable must respond to user or owner (till now must respond to owner)
* New language selector using dropdown list
* Added translations for Brazilian Portuguese

0.5.4
----

* Fixed redirection after abuse confirmation (kudos to Arnau Sanchez)

0.5.3
----

0.5.2
----

* Fixed #4. Misspelled name for I18nHelper. Thanks to Richard Shank and Javier Lafora 
* Added some missed keys in spanish locale

0.5.1
----

* Added a new installer (kudos to the passenger guys for remember us that the command line can be a better place)
* First language selector implementation (allow users to set the locale).

0.5.0
----

* Admin views updated, so all views have the same look and feel
* (almost) Full i18n (kudos to Andrei Erdoss)
* Renamed application.rb to application_controller.rb (Rails 2.3 support)
* Small changes to code and test (Rails 2.3 support, kudos to Andrei Erdoss)
* Removed tog-desert gem, now using pivotal labs' official desert gem (desert 0.5 support)
* Renamed routes.rb to desert_routes.rb (Rails 2.3 + desert 0.5 support)
* Removed support for observers in plugins, was supported by tog-desert (desert 0.5 support)
* Added port to mailer URL options (kudos to Balint Erdi)
* Better support for Amazon S3 (kudos to Gaizka)
* Support for jRails in order to use jQuery instead of Prototype (kudos to Richard Shank)


0.4.4
----

0.4.3
----

0.4.2
----
* Ticket #129.  i18n patch for will_paginate helper. This enable translated pagination by default in every tog based app.
* New Tog::Deprecation module.
* Ticket #105. Comments approbe and delete should be in member/comments_controller
* Ticket #118. i18n in navigation tabs
* Ticket #112. Edit profile in a fresh installation

0.4.0
----
* Search controller and search helper improved.
* Sanitize tags change allowed
* Ticket #102. Consolidate comments listing and form
* Check spam in comments using Viking
* Tog::Search improved interface and docs
* Clean up
* Ticket #100. Menu problem in admin site
* Ticket #99. Link to commentable in comment notification mail
* Sync tog's i18n implementation with rails 2.2.2

0.3.0
----
* Since we've had problems with the proper moment to create the config table we've moved the process of manage the table existence to a internal method
* Implemented create_tog_config_table on Tog::Config as last resort. It should be really hard to get 'Config doesn't exists' messages now.
* Add user routes to tog_core
* Moved users_helper to tog_core
* Change admin's home url, from /admin to /admin/dashboard so tabs are highlighted properly
* Ticket #88. Problem with URLs in UserMailer
