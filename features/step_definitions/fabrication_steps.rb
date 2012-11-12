World(FabricationMethods)

Fabrication::Config.register_with_steps = true

def with_ivars(fabricator)
  @they = yield fabricator
  model = @they.last.class.to_s.underscore
  instance_variable_set("@#{model.pluralize}", @they)
  instance_variable_set("@#{model.singularize}", @they.last)
  Fabrication::Cucumber::Fabrications[model.singularize.gsub(/\W+/,'_').downcase] = @they.last
end

Given /^the following ([^"]*):$/ do |model_name, table|
  with_ivars Fabrication::Cucumber::StepFabricator.new(model_name) do |fab|
    fab.from_table(table)
  end
end
