module CodeWars
  class Event < CodeWarsModel
    attr_accessor :label

    # OPTIONAL The slug of the next event
    # This will overide any decision directive
    # Can be used in combination with "requires_all_decisions"
    # As a result, this attribute will be valid once all decisions have
    # been made by player
    attr_accessor :next_event_slug

    # OPTIONAL This forces the player to go through all the provided decisions
    # before going next
    attr_accessor :requires_all_decisions

    # OPTIONAL This forces the player to kill the boss before going next
    attr_accessor :requires_boss_beaten

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

    # Returns the next event saved in store through #next_event_slug
    # based on #next_event_slug attribute
    # @return [Event]
    def static_next_event
      if next_event_slug and next_event_slug.size > 0
        CodeWars::DataStore.instance.data[:events]
          .select{|e| e.slug == next_event_slug}.first
      end
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

        next_event = static_next_event || next_event_in_the_list

      # if the event is the final boss event
      # and the boss is beaten
      elsif requires_boss_beaten and CodeWars::DarkCobol.instance.is_beaten?
        next_event = static_next_event

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


    # Returns wether or not the player input is considered valid
    # @param [String] player_input
    # @return [Boolean] Wether or not the input is a valid one
    def is_player_input_valid?(player_input)
      player_input_is_valid = false

      if player_input && player_input.size > 0
        if has_a_player_attribute_decision?
          player_input_is_valid = true
        else player_input and (player_i = player_input.to_i)
          player_input_is_valid = (player_i > 0 and
            player_i <= available_decisions.count)
        end
      end

      player_input_is_valid
    end
  end
end
