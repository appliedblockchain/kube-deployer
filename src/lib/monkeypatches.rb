class ContainerOverrideLookupFailedError < RuntimeError; end

class Array
  def merge_container_hashes(container_overrides)
    container_overrides.each do |container_override|
      container = find { |container| container["name"] == container_override["name"] }
      raise ContainerOverrideLookupFailedError unless container
      container.merge! container_override
    end
  end
end

class Hash
  def deep_merge(hash)
    merger = proc do |_, v1, v2|
      if v1.is_a?(Hash) && v2.is_a?(Hash)
        v1.merge v2, &merger
      elsif v1.is_a?(Array) && v2.is_a?(Array)
        if v1[0].is_a?(Hash) && v1[0].has_key?("name")
          v1.merge_container_hashes v2
        else
          v1 | v2
        end
      # handle special case for merging kubernetes container configuration
      else
        [:undefined, nil, :nil].include?(v2) ? v1 : v2
      end
    end
    merge hash.to_h, &merger
  end

  alias_method :f, :fetch
end

class Array
  alias_method :f, :fetch
end
