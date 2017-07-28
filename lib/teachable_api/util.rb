module Teachable
  module Util
    def raise_if_blank(str, name)
      raise ArgumentError, "#{name} cannot be blank" if str.nil? || str.empty?
    end
  end
end
