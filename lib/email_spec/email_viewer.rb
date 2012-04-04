module EmailSpec
  class EmailViewer
    extend Deliveries

    def self.save_and_open_all_raw_emails
      filename = tmp_email_filename

      File.open(filename, "w") do |f|
        all_emails.each do |m|
          f.write m.to_s
          f.write "\n" + '='*80 + "\n"
        end
      end

      open_in_text_editor(filename)
    end

    def self.save_and_open_all_html_emails
      all_emails.each_with_index do |m, index|
        if m.multipart? && html_part = m.parts.detect{ |p| p.content_type.include?('text/html') }
          filename = tmp_email_filename("-#{index}.html")
          File.open(filename, "w") do |f|
            f.write m.parts[1].body
          end
          open_in_browser(filename)
        end
      end
    end

    def self.save_and_open_all_text_emails
      filename = tmp_email_filename

      File.open(filename, "w") do |f|
        all_emails.each do |m|
          if m.multipart? && text_part = m.parts.detect{ |p| p.content_type.include?('text/plain') }
            if m.respond_to?(:ordered_each) # Rails 2 / TMail
              m.ordered_each{|k,v| f.write "#{k}: #{v}\n" }
            else # Rails 3 / Mail
              f.write(text_part.header.to_s + "\n")
            end

            f.write text_part.body
          else
            f.write m.to_s
          end
          f.write "\n" + '='*80 + "\n"
        end
      end

      open_in_text_editor(filename)
    end

    def self.save_and_open_email(mail)
      filename = tmp_email_filename

      File.open(filename, "w") do |f|
        f.write mail.to_s
      end

      open_in_text_editor(filename)
    end

    def self.save_and_open_email_attachments_list(mail)
      filename = tmp_email_filename

      File.open(filename, "w") do |f|
        mail.attachments.each_with_index do |attachment, index|
          info = "#{index + 1}:"
          info += "\n\tfilename: #{attachment.original_filename}"
          info += "\n\tcontent type: #{attachment.content_type}"
          info += "\n\tsize: #{attachment.size}"
          f.write info + "\n"
        end
      end

      open_in_text_editor(filename)
    end

    def self.open_in_text_editor(filename)
      Launchy.open(URI.parse("file://#{File.expand_path(filename)}"), :application => :editor)
    end

    def self.open_in_browser(filename)
      Launchy.open(URI.parse("file://#{File.expand_path(filename)}"))
    end

    def self.tmp_email_filename(extension = '.txt')
      "#{Rails.root}/tmp/email-#{Time.now.to_i}#{extension}"
    end
  end
end
