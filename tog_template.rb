TOG_RELEASE = "v0.5.1"

module Colored
  extend self
  COLORS = { 'green'   => 32, 'yellow'  => 33,'blue'    => 34}
  EXTRAS = {'clear'     => 0, 'bold'      => 1}
  
  COLORS.each do |color, value|
    define_method(color) { colorize(self, :foreground => color) }
    define_method("on_#{color}") { colorize(self, :background => color) }
    COLORS.each do |highlight, value|
      next if color == highlight
      define_method("#{color}_on_#{highlight}") { colorize(self, :foreground => color, :background => highlight) }
    end
  end
  EXTRAS.each do |extra, value|
    next if extra == 'clear'
    define_method(extra) { colorize(self, :extra => extra) }
  end
  define_method(:to_eol) do
    tmp = sub(/^(\e\[[\[\e0-9;m]+m)/, "\\1\e[2K")
    if tmp == self
      return "\e[2K" << self
    end
    tmp
  end
  def colorize(string, options = {})
    colored = [color(options[:foreground]), color("on_#{options[:background]}"), extra(options[:extra])].compact * ''
    colored << string
    colored << extra(:clear)
  end
  def colors
    @@colors ||= COLORS.keys.sort
  end
  def extra(extra_name)
    extra_name = extra_name.to_s
    "\e[#{EXTRAS[extra_name]}m" if EXTRAS[extra_name]
  end
  def color(color_name)
    background = color_name.to_s =~ /on_/
    color_name = color_name.to_s.sub('on_', '')
    return unless color_name && COLORS[color_name]
    "\e[#{COLORS[color_name] + (background ? 10 : 0)}m" 
  end
end unless Object.const_defined? :Colored
String.send(:include, Colored)

require 'open3'

def silence!
#  Rails::Generator::Base.logger.quiet = true
end
def verbum!
#  Rails::Generator::Base.logger.quiet = false
end

def add_desert_require
  sentinel = 'Rails::Initializer.run do |config|'
  gsub_file 'config/environment.rb', /(#{Regexp.escape(sentinel)})/mi, "\nrequire 'desert'\n\\1" 
end

def install_require_gems
  run "gem sources -a http://gems.github.com"
  
  gem 'desert', :version => '0.5', :lib => 'desert'
  gem 'mislav-will_paginate', :version => '~> 2.3.6', :lib => 'will_paginate', :source => 'http://gems.github.com'
  gem 'tog-tog', :version => '0.5', :lib => 'tog'
  gem 'mocha'
  gem 'thoughtbot-factory_girl', :lib => 'factory_girl'
  rake "gems:install", :sudo => true
end

def install_tog_core_plugins    
  quiet_git_install('tog_core', "git://github.com/tog/tog_core.git", TOG_RELEASE)
  quiet_git_install('tog_social', "git://github.com/tog/tog_social.git", TOG_RELEASE)
  quiet_git_install('tog_mail', "git://github.com/tog/tog_mail.git", TOG_RELEASE)

  route "map.routes_from_plugin 'tog_core'"
  puts "* adding tog_core routes to host app... #{"added".green.bold}";
  route "map.routes_from_plugin 'tog_social'"
  puts "* adding tog_tog_social routes to host app... #{"added".green.bold}";
  route "map.routes_from_plugin 'tog_mail'"
  puts "* adding tog_mail routes to host app... #{"added".green.bold}";

  file "db/migrate/" + Time.now.strftime("%Y%m%d%H%M%S") + "_install_tog.rb",
  %q{class InstallTog < ActiveRecord::Migration
      def self.up
        migrate_plugin "tog_core", 6
        migrate_plugin "tog_social", 5
        migrate_plugin "tog_mail", 2
      end

      def self.down
        migrate_plugin "tog_mail", 0 
        migrate_plugin "tog_social", 0 
        migrate_plugin "tog_core", 0
      end
  end
  }     
  puts "* generating tog_core migration... #{"generated".green.bold}";
  
end

def generate_acts_as_commentable_migration
  sleep 1 # Template runner is too fast and generate multiple migrations with the same number
  file "db/migrate/" + Time.now.strftime("%Y%m%d%H%M%S") + "_acts_as_commentable.rb",
  %q{class ActsAsCommentable < ActiveRecord::Migration
    def self.up
      create_table "comments", :force => true do |t|
        t.column "title", :string, :limit => 50, :default => "" 
        t.column "comment", :text, :default => "" 
        t.column "created_at", :datetime, :null => false
        t.column "commentable_id", :integer, :default => 0, :null => false
        t.column "commentable_type", :string, :limit => 15, :default => "", :null => false
        t.column "user_id", :integer, :default => 0, :null => false
      end
      add_index "comments", ["user_id"], :name => "fk_comments_user" 
    end

    def self.down
      drop_table :comments
    end
  end
  }   
  puts "* acts_as_commentable migration... #{"generated".green.bold}";
end

def generate_acts_as_rateable_migration
  sleep 1 # Template runner is too fast and generate multiple migrations with the same number
  file "db/migrate/" + Time.now.strftime("%Y%m%d%H%M%S") + "_add_ratings.rb",
  %q{class AddRatings < ActiveRecord::Migration
      def self.up
      create_table :ratings do |t|
              t.column :rating, :integer    # You can add a default value here if you wish
              t.column :rateable_id, :integer, :null => false
              t.column :rateable_type, :string, :null => false
      end
      add_index :ratings, [:rateable_id, :rating]    # Not required, but should help more than it hurts
      end

      def self.down
      drop_table :ratings
      end
  end
  }
  puts "* acts_as_rateable migration... #{"generated".green.bold}";
end

def generate_acts_as_abusable_migration
  generate "acts_as_abusable_migration" 
  puts "* acts_as_abusable migration... #{"generated".green.bold}";
end

def generate_acts_as_taggable_migration
  generate "acts_as_taggable_migration"
  puts "* acts_as_taggable migration... #{"generated".green.bold}";
end

def generate_acts_as_scribe_migration
  generate "acts_as_scribe_migration"
  puts "* acts_as_scribe migration... #{"generated".green.bold}";
end

def install_tog_user_plugin    
  verbum!    
  
  if STDIN.gets.strip == ""
    silence!   

    quiet_git_install('tog_user', "git://github.com/tog/tog_user.git", TOG_RELEASE)

    route "map.routes_from_plugin 'tog_user'"
    puts "* adding routes to host app... #{"added".green.bold}";
    
    file "db/migrate/" + Time.now.strftime("%Y%m%d%H%M%S") + "_install_tog_user.rb",
    %q{class InstallTogUser < ActiveRecord::Migration
        def self.up
          migrate_plugin "tog_user", 1
        end

        def self.down
          migrate_plugin "tog_user", 0 
        end
    end
    }
    puts "* generating migration... #{"generated".green.bold}";
  else
    silence!  
  end
end

def introduction_banner
  puts %q{
This installer will guide you through the tog integration process. The installer
downloads a few plugins over the internet so the time it takes depends in a great
measure of your bandwidth, but usually it should take a few minutes.

Here's what you can expect from the installation process:

 1. All the tog's dependencies will be installed for you.
 2. The installer will generate a few migrations required by the dependencies
 4. The host app will be a working tog instance after the installation.

Don't worry if anything goes wrong. This installer will advise you on how to
solve any problems.

Press Enter to continue, or Ctrl-C to abort.}  
STDIN.gets
end    

def tog_user_banner
  puts <<-eos
Tog includes its own user authentication library: tog_user. It's based
on the great restful-authentication plugin and well suited to work out-the-box.

If you're creating a new app #{"it's definitely recommended to install this plugin".green.bold}.
If you've already using a user library in the host app you can skip this step.

Press Enter to install tog_user, or 'n' to skip this step
eos
end           

def gem_banner
  puts <<-eos
We try to install the required gems as superuser so you could be asked to enter your password.

eos
end

def congratulations_banner
  puts <<-eos
Hurrah!... everything should be fine now. Some things you could try:

* Run the tests. Just run: '#{"rake db:test:prepare && rake tog:plugins:test".green.bold}'.
* Start the app in your favorite server and check your new, shiny tog installation.  
* Visit http://wiki.github.com/tog/tog if you need technical read about the platform.
* You can install more tog plugins. For a list of available plugins check 
  http://www.toghq.com/tog_plugins

eos
end

def installation_step(title, &block)
  puts "\n--------------------------------------------  \n\n"
  puts "#{title.yellow_on_blue.bold} \n\n"
  yield
end

def install_svn_plugins(plugins)
  plugins.each_pair do |name, url| 
    print "* #{name}... "; STDOUT.flush
    plugin name, :svn => url 
    puts "installed".green.bold
  end
end 

def install_git_plugins(plugins)
  plugins.each_pair do |name, url|     
    quiet_git_install(name, url) 
  end                    
end   

def quiet_git_install(name, url, tag=nil)
  print "* #{name}... "; 
  resolution = "installed".green
    command = "script/plugin install #{url}"
    command << " -r 'tag #{tag}'" if tag
    Open3.popen3(command) { |stdin, stdout, stderr| 
      stdout.each { |line| resolution = "already installed -> skipped".yellow if line =~ /already installed/; STDOUT.flush }
    }
  puts resolution.bold  
end


silence!

installation_step "Welcome to the Tog installer #{TOG_RELEASE}" do
  introduction_banner
end

installation_step "Installing gem dependencies..." do
  gem_banner
  install_require_gems
end

installation_step "Installing plugin dependencies..." do
  
  install_svn_plugins({
    'acts_as_commentable'    => "http://juixe.com/svn/acts_as_commentable",
    'acts_as_state_machine'  => "http://elitists.textdriven.com/svn/plugins/acts_as_state_machine/trunk",
    'seo_urls'               => "http://svn.redshiftmedia.com/svn/plugins/seo_urls"
  })  
  
  install_git_plugins({
    'acts_as_taggable_on_steroids' => "git://github.com/jviney/acts_as_taggable_on_steroids.git",
    'acts_as_rateable' => "git://github.com/andry1/acts_as_rateable.git",
    'acts_as_abusable' => "git://github.com/linkingpaths/acts_as_abusable.git",
    'acts_as_scribe'   => "git://github.com/linkingpaths/acts_as_scribe.git",
    'paperclip' => "git://github.com/thoughtbot/paperclip.git",
    'viking'    => "git://github.com/technoweenie/viking.git"
  })
  
end

installation_step "Generating dependencies migrations..." do     
  generate_acts_as_commentable_migration
  generate_acts_as_rateable_migration
  generate_acts_as_abusable_migration
  generate_acts_as_taggable_migration
  generate_acts_as_scribe_migration
end    


installation_step "Installing tog_user plugin..." do   
  tog_user_banner
  install_tog_user_plugin
end

installation_step "Installing tog core plugins..." do   
  install_tog_core_plugins
end

installation_step "Updating the host app files..." do
  add_desert_require
  append_file 'Rakefile', "require 'tasks/tog'\n"
  puts "* including tog rake tasks... #{"done".green.bold}";
  
  rake "tog:plugins:copy_resources"
  puts "* copy tog plugins resources... #{"done".green.bold}";
  rake "db:migrate"
  puts "* run migrations... #{"done".green.bold}";
  run 'rm public/index.html'
  puts "* removing index.html... #{"done".green.bold}";
end

installation_step "Tog #{TOG_RELEASE} installed" do
  congratulations_banner
end
