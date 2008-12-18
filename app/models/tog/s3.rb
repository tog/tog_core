# Tog::S3.client
module S3
  require 'right_aws'

  def self.client(options={})
    @s3 ||= RightAws::S3.new(access_key,secret_access_key,options)
  end
  
  def self.options_for_paperclip
    {:storage => "s3", :s3_credentials => credentials, :path => path_for_files, :bucket => default_bucket}
  end
  
  def self.path_for_files
    Tog::Config['plugins.tog_core.storage.s3.path']
  end
  def self.default_bucket
    Tog::Config['plugins.tog_core.storage.s3.bucket']
  end
  def self.credentials
    {:access_key_id => access_key, :secret_access_key => secret_access_key}
  end
  def self.access_key
    Tog::Config['plugins.tog_core.storage.s3.access_key_id'] || warn("S³ WARNING: Put your access key id on Tog::Config['plugins.tog_core.s3.access_key_id']")
  end
  def self.secret_access_key
    Tog::Config['plugins.tog_core.storage.s3.secret_access_key'] || warn("S³ WARNING: Put your secret access key on Tog::Config['plugins.tog_core.s3.secret_access_key']")
  end

  def self.warn(text)
    token = "*" * text.size
    warning = "\n#{token}\n#{text}\n#{token}\n"
    RAILS_DEFAULT_LOGGER.warn(warning)
    nil
  end

end