# :nocov:

# Required for Ruby < 2.5
if !{}.respond_to? :transform_keys!
  class Hash
    def transform_keys!
      keys.each { |key| self[yield(key)] = delete(key) }
      self
    end
  end
end