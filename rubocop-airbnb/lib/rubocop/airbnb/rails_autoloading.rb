# These methods are useful for Rubocop rules related to Rails autoloading.
module RailsAutoloading
  def run_rails_autoloading_cops?(path)
    return false unless config["Rails".freeze]
    return false unless config["Rails".freeze]["Enabled".freeze]

    # Ignore rake tasks
    return false unless path.end_with?(".rb")

    true
  end

  # Given "foo/bar/baz", return:
  # [
  #   %r{/foo.rb$},
  #   %r{/foo/bar.rb$},
  #   %r{/foo/bar/baz.rb$},
  #   %r{/foo/bar/baz/}, # <= only if allow_dir = true
  # ]
  def allowable_paths_for(expected_dir, options = {})
    options = { allow_dir: false }.merge(options)
    allowable_paths = []
    next_slash = expected_dir.index("/")
    while next_slash
      allowable_paths << %r{/#{expected_dir[0...next_slash]}.rb$}
      next_slash = expected_dir.index("/", next_slash + 1)
    end
    allowable_paths << %r{#{expected_dir}.rb$}
    allowable_paths << %r{/#{expected_dir}/} if options[:allow_dir]
    allowable_paths
  end

  def normalize_module_name(module_name)
    return '' if module_name.nil?
    normalized_name = module_name.gsub(/#<Class:|>/, "")
    normalized_name = "" if normalized_name == "Object"
    normalized_name
  end

  # module_name looks like one of these:
  #   Foo::Bar for an instance method
  #   #<Class:Foo::Bar> for a class method.
  # For either case we return ["Foo", "Bar"]
  def split_modules(module_name)
    normalize_module_name(module_name).split("::")
  end

  def full_const_name(parent_module_name, const_name)
    if parent_module_name == "".freeze
      "#{const_name}"
    else
      "#{parent_module_name}::#{const_name}"
    end
  end
end
