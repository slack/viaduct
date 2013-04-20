module Viaduct
  class Runner
    def self.run(app, options=nil)
      new.run(app, options)
    end

    def run(callable_id, options=nil)
      callable = callable_id
      callable = Builder.new.use(callable_id) if callable_id.kind_of?(Class)
      raise ArgumentError, "Argument to run must be a callable object or known class." if !callable || !callable.respond_to?(:call)

      # Create the initial environment with the options given
      environment = Environment.new
      environment.merge!(options || {})

      callable.call(environment)
      environment
    end
  end
end
