# frozen_string_literal: true

# Manages versioned PDF templates for DOT-compliant application documents.
#
# Usage:
#   template = ApplicationTemplate.current
#   template.path          # => Pathname to the PDF file
#   template.hash          # => SHA-256 hash
#   template.version       # => "v1"
#   template.verify!       # => raises if file hash doesn't match
#
class ApplicationTemplate
  class TemplateNotFoundError < StandardError; end
  class IntegrityError < StandardError; end

  attr_reader :version, :config

  def initialize(version = nil)
    @version = version || self.class.default_version
    @config = self.class.all_versions[@version]
    raise TemplateNotFoundError, "Template version '#{@version}' not found" unless @config
  end

  def path
    Rails.root.join(config["file"])
  end

  def hash
    config["hash"]
  end

  def render_engine
    config["render_engine"]
  end

  def created_at
    Date.parse(config["created_at"])
  end

  def notes
    config["notes"]
  end

  # Verifies the template file matches its stored hash.
  # Raises IntegrityError if the file has been modified.
  def verify!
    actual_hash = Digest::SHA256.file(path).hexdigest
    return true if actual_hash == hash

    raise IntegrityError,
          "Template #{version} integrity check failed. " \
          "Expected: #{hash}, Got: #{actual_hash}. " \
          "The template file may have been modified."
  end

  def verified?
    verify!
    true
  rescue IntegrityError
    false
  end

  # Returns template metadata for storing with signed applications
  def metadata
    {
      template_version: version,
      template_hash: hash,
      render_engine_version: "#{render_engine}-#{gem_version(render_engine)}"
    }
  end

  class << self
    def current
      new(default_version)
    end

    def find(version)
      new(version)
    end

    def default_version
      loaded_config["default_version"]
    end

    def all_versions
      loaded_config["versions"]
    end

    def available_versions
      all_versions.keys
    end

    private

    def loaded_config
      @loaded_config ||= YAML.load_file(
        Rails.root.join("config", "application_templates.yml")
      )
    end
  end

  private

  def gem_version(gem_name)
    Gem.loaded_specs[gem_name]&.version&.to_s || "unknown"
  end
end
