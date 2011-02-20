module GeneratorsExamples

  def it_not_supported(property)
    it "is not supported" do
      klass.new("").should_not support_property(property)
    end
  end

end

RSpec.configure do |config|
  config.extend GeneratorsExamples
end
