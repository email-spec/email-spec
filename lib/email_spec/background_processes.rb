module EmailSpec
  module BackgroundProcesses
    module DelayedJob
      def all_emails
        Delayed::Worker.send :public, :work_off
        @worker = Delayed::Worker.new(:max_priority => nil, :min_priority => nil, :quiet => true)
        @worker.work_off
        super
      end

      def last_email_sent
        Delayed::Worker.send :public, :work_off
        @worker = Delayed::Worker.new(:max_priority => nil, :min_priority => nil, :quiet => true)
        @worker.work_off
        super
      end

      def reset_mailer
        Delayed::Worker.send :public, :work_off
        @worker = Delayed::Worker.new(:max_priority => nil, :min_priority => nil, :quiet => true)
        @worker.work_off
        super
      end

      def mailbox_for(address)
        Delayed::Worker.send :public, :work_off
        @worker = Delayed::Worker.new(:max_priority => nil, :min_priority => nil, :quiet => true)
        @worker.work_off
        super
      end
    end

    module Compatibility
      if defined?(Delayed)
        include EmailSpec::BackgroundProcesses::DelayedJob
      end
    end
  end
end
