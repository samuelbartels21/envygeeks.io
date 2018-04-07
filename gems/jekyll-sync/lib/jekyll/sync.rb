# Frozen-string-literal: true
# Copyright: 2017 - MIT License
# Encoding: utf-8

require "logger"
require "jekyll"

module Jekyll
  class Sync
    def self.setup
      logger = Logger.new(STDERR)
      log_level = Jekyll.logger.level
      Jekyll.logger.log_level = logger.level = log_level
      logger.formatter = method(:formatter)
      Jekyll.logger = logger
    end

    # --
    # @return [nil]
    # Formats the logs so they look nice.
    # @param [String] m the message
    # @param [String] s unused
    # @param [String] d unused
    # @param [String] p unused
    # --
    def self.formatter(_, _, _, m)
      "#{CGI.unescape(m.gsub(Pathutil.pwd + '/', ''))}\n"
    end
  end
end

Jekyll::Sync.setup
