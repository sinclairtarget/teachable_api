module Teachable
  # Represents an order made by a user.
  class Order
    attr_reader :id, :number, :special_instructions, :total, :total_quantity,
      :created_at, :updated_at

    def initialize(order_hash)
      @id = order_hash['id']
      @number = order_hash['number']
      @special_instructions = order_hash['special_instructions']
      @total = order_hash['total']
      @total_quantity = order_hash['total_quantity']
      @created_at = order_hash['created_at']
      @updated_at = order_hash['updated_at']
    end
  end
end
