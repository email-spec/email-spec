module EmailSpec
  module Extractors
    class Base
      attr_accessor :mail

      def initialize(mail)
        @mail = mail
      end

      def call
        part_body ? HTMLEntities.new.decode(part_body) : ''
      end

      private

      def part_body
        raise NotImplementedError
      end
    end

    class DefaultPartBody < Base
      private

      def part_body
        (mail.html_part || mail.text_part || mail).body
      end
    end

    class HtmlPartBody < Base
      private

      def part_body
        mail.html_part ? mail.html_part.body : nil
      end
    end

    class TextPartBody < Base
      private

      def part_body
        mail.text_part ? mail.text_part.body : nil
      end
    end
  end
end
