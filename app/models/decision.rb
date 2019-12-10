module CodeWars
  class Decision < CodeWarsModel
    attr_accessor :label

    # OPTIONAL The event slug which the decision will lead to
    # If left empty, decision will lead to raw static next event
    # Be aware this attribute can be overidden by events#next_event_slug
    # see events#next_event_slug comment
    attr_accessor :next_event_slug

    # The event slug by which the decision was raised
    attr_accessor :decided_event_slug

    # OPTIONAL If set - Event will ask the player for a custom input
    # (instead of a string choice) and will store the response to the
    # given current player model attribute
    # @example
    # "#name" will take the player input and store it to current player's #name attribute
    attr_accessor :current_player_input_attribute

    # Stores the time at which the decision was made by player
    attr_accessor :chosen_at

    def update_player(player_input)
      if CodeWars::Player.instance.respond_to? current_player_input_attribute
        CodeWars::Player.instance.update({
          current_player_input_attribute => player_input
        })
      end
    end

    def next_event
      CodeWars::DataStore.instance.events.select{|e| e.slug == self.next_event_slug}.first
    end

  end
end
