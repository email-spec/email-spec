module EmailSpec::MailExt
  def default_part
    @default_part ||= html_part || text_part || self
  end

  def default_part_body
    # Calling to_str as we want the actual String object
    HTMLEntities.new.decode(default_part.body.to_s.to_str)
  end

  def html
    html_part ? html_part.body.raw_source : nil
  end
end

Mail::Message.send(:include, EmailSpec::MailExt)
