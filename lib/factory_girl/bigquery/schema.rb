module FactoryGirl
  module Bigquery
    module Schema
      def self.define(&block)
        DSL.run(block)
      end

      class DSL
        def self.run(block)
          new.instance_eval(&block)
        end

        def table(name)
          table = Table.new(name)
          yield table if block_given?
          FactoryGirl::Bigquery.register_table(table)
        end
      end
    end
  end
end
