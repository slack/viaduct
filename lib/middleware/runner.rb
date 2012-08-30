require 'logger'

module Middleware
  class Runner
    @@reported_interrupt = false

    def initialize(globals=nil, &block)
      @globals      = globals || {}
      @lazy_globals = block
      @logger       = Logger.new($stderr)
    end

    def run(callable_id, options=nil)
      callable = callable_id
      callable = Builder.new.use(callable_id) if callable_id.kind_of?(Class)
      raise ArgumentError, "Argument to run must be a callable object or registered action." if !callable || !callable.respond_to?(:call)

      # Create the initial environment with the options given
      environment = Environment.new
      environment.merge!(@globals)
      environment.merge!(@lazy_globals.call) if @lazy_globals
      environment.merge!(options || {})

      @logger.info("Running action: #{callable_id}")
      callable.call(environment)
    end
  end
end
