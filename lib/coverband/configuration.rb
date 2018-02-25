# frozen_string_literal: true

module Coverband
  class Configuration
    attr_accessor :redis, :root_paths, :root,
                  :ignore, :additional_files, :percentage, :verbose, :reporter,
                  :stats, :logger, :startup_delay, :trace_point_events,
                  :include_gems, :memory_caching, :s3_bucket, :coverage_file, :store,
                  :collector, :disable_on_failure_for

    def initialize
      @root = Dir.pwd
      @redis = nil
      @stats = nil
      @root_paths = []
      @ignore = []
      @additional_files = []
      @include_gems = false
      @percentage = 0.0
      @verbose = false
      @reporter = 'scov'
      @collector = 'trace'
      @logger = Logger.new(STDOUT)
      @startup_delay = 0
      @trace_point_events = [:line]
      @memory_caching = false
      @coverage_file = nil
      @store = nil
      @disable_on_failure_for = nil
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    # TODO: considering removing @redis / @coveragefile and have user set store directly
    def store
      return @store if @store
      if redis
        @store = Coverband::Adapters::RedisStore.new(redis)
      elsif Coverband.configuration.coverage_file
        @store = Coverband::Adapters::FileStore.new(coverage_file)
      end
      @store
    end
  end
end
