require 'json'
class Array
  # Missing helpfull rails #deep_symbolize_keys method in pure ruby
  # Workaround using JSON lib found @ https://stackoverflow.com/questions/24927653/how-to-elegantly-symbolize-keys-for-a-nested-hash
  # - @return [Array] array with any hash symobilized keys
  def deep_symbolize_keys
    JSON.parse(JSON[self], symbolize_names: true)
  end
end
