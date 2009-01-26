module AbuseHelper   
  def report_abuse_link(instance, name=I18n.t("tog_core.site.abuses.report_abuse"), html_options={})
     link_to name, report_abuse_with_model_path(:resource_type => instance.class.name, :resource_id => instance.id ), html_options if instance
  end   
end                                              