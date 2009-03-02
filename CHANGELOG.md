Edge
----

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