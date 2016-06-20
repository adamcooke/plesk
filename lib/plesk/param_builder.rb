module Plesk
  module ParamBuilder

    class Block
      attr_accessor :result
      def initialize
        @result = ""
      end

      def method_missing(key, value = nil, &block)
        if block_given?
          @result += "<#{key}>"
          i = Block.new
          result = i.instance_exec(&block)
          @result += i.result
          unless result.nil?
            @result += result.to_s
          end
          @result += "</#{key}>"
        elsif value
          @result += "<#{key}>#{value}</#{key}>"
        else
          @result += "<#{key} />"
        end

        nil
      end
    end

    def self.build(&block)
      i = Block.new
      i.instance_exec(&block)
      i.result
    end

  end
end
