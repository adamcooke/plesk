require 'net/https'
require 'nokogiri'
require 'plesk/param_builder'
require 'plesk/version'

module Plesk
  class Client

    class Error < StandardError; end
    class RequestError < Error; end
    class ActionError < Error; end

    attr_reader :options

    def initialize(host, username, password, options = {})
      @host = host
      @options = options
      @username = username
      @password = password
    end

    def request(controller, action, &block)
      request = Net::HTTP::Post.new("/enterprise/control/agent.php")
      params = ParamBuilder.build(&block)
      request.body = "<packet><#{controller}><#{action}>#{params}</#{action}></#{controller}></packet>"
      request.add_field 'User-Agent', "PleskRuby/#{Plesk::VERSION}"
      request.add_field 'HTTP_AUTH_LOGIN', @username
      request.add_field 'HTTP_AUTH_PASSWD', @password
      request.add_field 'Content-Type', 'text/xml'
      connection = Net::HTTP.new(@host, @options[:port] || 8443)
      connection.use_ssl = true
      connection.verify_mode = @options[:verify_ssl] == false ? OpenSSL::SSL::VERIFY_NONE : OpenSSL::SSL::VERIFY_PEER
      result = connection.request(request)
      xml = Nokogiri::XML.parse(result.body)
      if xml.xpath('/packet/system/status').first&.content == "error"
        error_code = xml.xpath('/packet/system/errcode').first&.content
        error_message = xml.xpath('/packet/system/errtext').first&.content
        raise RequestError, "#{error_code || "-1"}: #{error_message}"
      elsif xml.xpath("/packet/#{controller}/#{action}/result/status").first&.content == "error"
        error_code = xml.xpath("/packet/#{controller}/#{action}/result/errcode").first&.content
        error_message = xml.xpath("/packet/#{controller}/#{action}/result/errtext").first&.content
        raise ActionError, "#{error_code || "-1"}: #{error_message}"
      else
        xml.xpath("//result")[0]
      end
    end

  end
end

