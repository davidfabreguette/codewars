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
    attr_accessor :made_at

    # OPTIONAL IF set - defines life points attack in a final boss fight
    attr_accessor :life_points

    # This methods updates #current_player_input_attribute player attribute
    # with given
    # - @param [String] player_input
    # - @return [Player]
    def update_player(player_input)
      if CodeWars::Player.instance.respond_to? current_player_input_attribute
        CodeWars::Player.instance.update(
          current_player_input_attribute => player_input
        )
      end
    end

    # - @return [Event] next event saved in store
    def next_event
      if next_event_slug
        case next_event_slug.class.to_s
        when 'String'
          CodeWars::DataStore.instance.events
                             .select { |e| e.slug == next_event_slug }.first
        when 'Array'
          sample_index = rand(next_event_slug.size)
          CodeWars::DataStore.instance.events
                             .select { |e| e.slug == next_event_slug[sample_index] }.first
        end
      end
    end
  end
end
