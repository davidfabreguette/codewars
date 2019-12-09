module CodeWars
  class Decision < CodeWarsModel
    attr_accessor :label

    # The event id which the decision will lead to
    attr_accessor :leading_event_id

    # The event id by which the decision was raised
    attr_accessor :decided_event_id
  end
end
