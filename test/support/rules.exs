defmodule Protovalidate.TestRules do
  alias Protovalidate.{DescriptorAdapter, Plan}

  def field(type, attributes \\ []) do
    struct!(
      DescriptorAdapter.Field,
      Keyword.merge(
        [
          name: "implicit_string",
          json_name: "implicit_string",
          number: 1,
          type: type,
          repeated?: false,
          map?: false,
          oneof: nil,
          presence: :implicit,
          well_known_type: nil,
          validation: %{}
        ],
        attributes
      )
    )
  end

  def plan(field, rules, options \\ []) do
    Plan.compile(
      %DescriptorAdapter.Message{
        module: Acme.Descriptor.V1.Probe,
        full_name: "test.Probe",
        fields: [%{field | validation: %{field: rules}}],
        oneofs: [],
        validation: %{}
      },
      options
    )
  end

  def context,
    do: Protovalidate.Plan.Context.new(fail_fast: false, now: %{seconds: 100, nanos: 0})
end
