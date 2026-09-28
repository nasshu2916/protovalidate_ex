defmodule Protovalidate.Plan do
  @moduledoc false

  alias Protovalidate.{DescriptorAdapter, Violation}

  @enforce_keys [:module, :fields, :oneofs, :cel_rules]
  defstruct [:module, :fields, :oneofs, :cel_rules, :wire_fields, message_oneofs: []]

  @type compiled_rule() :: Protovalidate.Rules.compiled()
  defmodule FieldPlan do
    @moduledoc false
    @enforce_keys [:field, :checks, :presence, :ignore, :collection, :child]
    defstruct [:field, :checks, :presence, :ignore, :collection, :child, :required_source]

    @type t :: %__MODULE__{
            field: DescriptorAdapter.Field.t(),
            checks: [Protovalidate.Plan.compiled_rule()],
            presence: :required | :optional,
            ignore: atom() | nil,
            collection: Protovalidate.Plan.CollectionPlan.t() | nil,
            child: module() | nil,
            required_source: Protovalidate.RuleSource.t() | nil
          }
  end

  defmodule CollectionPlan do
    @moduledoc false
    defstruct items: nil, keys: nil, values: nil

    @type t :: %__MODULE__{
            items: FieldPlan.t() | nil,
            keys: FieldPlan.t() | nil,
            values: FieldPlan.t() | nil
          }
  end

  @type compiled_field() :: FieldPlan.t()
  @type compiled_oneof() :: %{
          oneof: DescriptorAdapter.Oneof.t(),
          required: boolean(),
          source: Protovalidate.RuleSource.t(),
          origin: Violation.Origin.t()
        }
  @type t :: %__MODULE__{
          module: module(),
          fields: [compiled_field()],
          oneofs: [compiled_oneof()],
          message_oneofs: [map()],
          wire_fields: %{String.t() => Buf.Validate.FieldPathElement.t()},
          cel_rules: [Protovalidate.Rules.Custom.compiled()]
        }

  @spec compile(DescriptorAdapter.Message.t(), keyword()) :: t()

  defdelegate compile(descriptor, options), to: Protovalidate.Plan.Compiler

  @spec evaluate(t(), struct(), keyword()) ::
          {:ok, [Violation.t()]} | {:error, Protovalidate.RuntimeError.t()}

  defdelegate evaluate(plan, message, options), to: Protovalidate.Plan.Evaluator
end
