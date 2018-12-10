module EmailSpec::MailExt
  def default_part
    @default_part ||= html_part || text_part || self
  end

  def default_part_body
    # Calling to_str as we want the actual String object
    HTMLEntities.new.decode(default_part.decoded.to_s.to_str)
  end

  def html
    html_part ? html_part.decoded : nil
  end
end

Mail::Message.send(:include, EmailSpec::MailExt)
