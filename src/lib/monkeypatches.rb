class ContainerOverrideLookupFailedError < RuntimeError; end

class Array
  def merge_container_hashes(container_overrides)
    hashes = []
    container_overrides.each do |container_override|
      container = find { |cont| cont["name"] == container_override["name"] }
      raise ContainerOverrideLookupFailedError unless container
      hashes.push container.deep_merge container_override
    end
    # pp hashes
    hashes
  end

  def merge_container_env(container_overrides)
    hashes = self
    container_overrides.each do |container_override|
      container = hashes.find { |cont| cont["name"] == container_override["name"] }
      container["value"] = container_override["value"] if container
    end
    # pp hashes
    hashes
  end
end

class Hash
  def deep_merge(hash)
    merger = proc do |_, v1, v2|
      if v1.is_a?(Hash) && v2.is_a?(Hash)
        v1.merge v2, &merger
      elsif v1.is_a?(Array) && v2.is_a?(Array)
        # handle special case for merging kubernetes container configuration
        if v1[0].is_a?(Hash) && v1[0].has_key?("name")
          if !v1[0].has_key?("value")
            v1.merge_container_hashes v2
          else
            v1.merge_container_env v2
          end
        else
          v1 | v2
        end
      else
        [:undefined, nil, :nil].include?(v2) ? v1 : v2
      end
    end
    val = merge hash.to_h, &merger
    # p val
    val
  end

  alias_method :f, :fetch
end

class Array
  alias_method :f, :fetch
end
