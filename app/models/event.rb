module CodeWars
  class Event < CodeWarsModel
    attr_accessor :label

    # OPTIONAL The slug of the next event
    # This will overide any decision directive
    # Can be used in combination with "requires_all_decisions"
    # As a result, this attribute will be valid once all decisions have
    # been made by player
    attr_accessor :next_event_slug

    # OPTIONAL This forces player to go through all the provided decisions
    # before being able to go next
    attr_accessor :requires_all_decisions

    # Search for any decisions attached to the event
    # @return [Decision]
    def decisions
      CodeWars::DataStore.instance.decisions.select do |d|
        d.decided_event_slug == self.slug
      end
    end

    # Returns only attached decisions made
    # @return [Decision]
    def decisions_made
      decisions.select do |d|
        d.made_at != nil
      end
    end

    # Wether or not the event asks for a player input
    # that will update any of his attribtes (name?)
    # @return [Boolean]
    def has_a_player_attribute_decision?
      self.decisions
        .select{|d| attr = d.current_player_input_attribute and attr.size > 0}
        .size > 0
    end

    # Returns next raw static event
    # @return [Event]
    def raw_next_event
      CodeWars::DataStore.instance.data[:events][self.indexed_at + 1]
    end

    # This methods is in charge of resolving next event to display
    # @return [Event] The next event to display
    def resolve_next_event
      next_event = nil

      # Go through the events list if no decisions given
      # or if this is player_attribute decision related event
      if has_a_player_attribute_decision? or
        decisions.count == 0
        next_event = raw_next_event

      # Or resolve next event based on player decision choice
      else

      end

      next_event
    end
  end
end
