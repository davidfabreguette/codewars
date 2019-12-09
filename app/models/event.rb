module CodeWars
  class Event < CodeWarsModel
    attr_accessor :label

    # The ID of the next event
    # This next event won't be used with any decision
    # is attached to the current Event
    attr_accessor :next_event_id
  end
end
