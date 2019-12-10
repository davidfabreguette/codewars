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

    # Returns only attached available (non-made) decisions
    # @return [Decision]
    def available_decisions
      decisions.select do |d|
        d.made_at == nil
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

    # Returns next event in the list
    # @return [Event]
    def next_event_in_the_list
      CodeWars::DataStore.instance.data[:events][self.indexed_at + 1]
    end

    # Returns the static next event
    # based on #next_event_slug attribute
    # @return [Event]
    def static_next_event
      CodeWars::DataStore.instance.data[:events]
        .select{|e| e.slug == next_event_slug}.first
    end

    # This methods is in charge of resolving next event to display based on
    # any current decision the player is making
    # @params [Decision] Current decision the player is making
    # @return [Event] The next event to display
    def resolve_next_event(current_decision=nil)
      next_event = nil

      # if no decisions is attached
      # or if this is player_attribute decision related event
      # then go through the events list
      if has_a_player_attribute_decision? or
        decisions.count == 0
        next_event = next_event_in_the_list

      # if there's a current decision
      elsif current_decision
        next_event = current_decision.next_event

      # if the event requires all decisions to be made
      elsif requires_all_decisions and
        available_decisions.count == 0
        next_event = static_next_event
      end

      next_event
    end
  end
end
