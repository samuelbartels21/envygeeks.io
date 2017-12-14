# Frozen-string-literal: true
# Copyright: 2017 - MIT License
# Encoding: utf-8

require "logger"

module Jekyll
  class BetterLogging
    def self.setup
      log_level, logger = Jekyll.logger.level, ::Logger.new(STDERR)
      Jekyll.logger.log_level = logger.level = log_level
      logger.formatter = method(:formatter)
      Jekyll.logger = logger
    end

    # --
    # @return [nil]
    # Formats the logs so they look nice.
    # @param s
    # @param d
    # @param p
    # @param m
    # --
    def self.formatter(_, _, _, m)
      "#{CGI.unescape(m.gsub(Pathutil.pwd + '/', ''))}\n"
    end
  end
end

Jekyll::BetterLogging.setup
