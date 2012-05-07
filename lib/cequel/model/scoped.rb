module Cequel

  module Model

    module Scoped

      extend ActiveSupport::Concern

      module ClassMethods
        delegate :consistency, :count, :first, :limit, :select, :where,
          :to => :all

        def all
          @_cequel.current_scope || empty_scope
        end

        def select(*rows)
          all.select(*rows)
        end

        def with_scope(scope)
          @_cequel.synchronize do
            old_scope = @_cequel.current_scope
            begin
              @_cequel.current_scope = scope
              yield
            ensure
              @_cequel.current_scope = old_scope
            end
          end
        end

        private

        def empty_scope
          Scope.new(self, [column_family])
        end

      end

    end

  end

end