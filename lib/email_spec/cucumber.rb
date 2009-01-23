# require this in your env.rb file after you require cucumber/rails/world

%w[helpers matchers].each do |file|
  require File.join(File.dirname(__FILE__), file)
end

# Global Setup
ActionMailer::Base.delivery_method = :test unless ActionMailer::Base.delivery_method == :activerecord
ActionMailer::Base.perform_deliveries = true

Before do 
  # Scenario setup
  ActionMailer::Base.deliveries.clear if ActionMailer::Base.delivery_method == :test
end

After do
  EmailViewer.save_and_open_all_raw_emails if ENV['SHOW_EMAILS']
  EmailViewer.save_and_open_all_html_emails if ENV['SHOW_HTML_EMAILS']
  EmailViewer.save_and_open_all_text_emails if ENV['SHOW_TEXT_EMAILS']
end

World do |world|
  world.extend EmailSpec::Helpers
  world.extend EmailSpec::Matchers  
end

class EmailViewer
  def self.save_and_open_all_raw_emails
    filename = "#{RAILS_ROOT}/tmp/email-#{Time.now.to_i}.txt"

    File.open(filename, "w") do |f|
      Email.all.each do |email|
        f.write email.mail
        f.write "\n" + '='*80 + "\n"
      end
    end

    `mate #{filename}`
  end

  def self.save_and_open_all_html_emails
    Email.all.each_with_index do |email, index|
      m = TMail::Mail.parse(email.mail)
      if m.multipart? && html_part = m.parts.detect{ |p| p.content_type == 'text/html' }
        filename = "#{RAILS_ROOT}/tmp/email-#{Time.now.to_i}-#{index}.html"
        File.open(filename, "w") do |f|
          f.write m.parts[1].body
        end
        `open #{filename}`
      end
    end
  end

  def self.save_and_open_all_text_emails
    filename = "#{RAILS_ROOT}/tmp/email-#{Time.now.to_i}.txt"

    File.open(filename, "w") do |f|
      Email.all.each do |email|
        m = TMail::Mail.parse(email.mail)
        if m.multipart? && text_part = m.parts.detect{ |p| p.content_type == 'text/plain' }
          m.ordered_each{|k,v| f.write "#{k}: #{v}\n" }
          f.write text_part.body
        else
          f.write email.mail
        end
        f.write "\n" + '='*80 + "\n"
      end
    end

    `mate #{filename}`
  end
end