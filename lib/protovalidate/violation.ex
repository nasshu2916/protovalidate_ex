defmodule Protovalidate.Violation do
  @moduledoc """
  Represents a single validation violation.

  Input values are not retained because they may contain sensitive information.
  """

  defmodule Origin do
    @moduledoc false
    @enforce_keys [:constraint, :field, :rule]
    defstruct [:constraint, :field, :rule, :index]

    @type t :: %__MODULE__{
            constraint: atom(),
            field: Buf.Validate.FieldPath.t() | nil,
            rule: Buf.Validate.FieldPath.t() | nil,
            index: non_neg_integer() | nil
          }
  end

  @enforce_keys [:field_path, :rule_path, :rule_id, :message]
  defstruct [
    :field_path,
    :rule_path,
    :rule_id,
    :message,
    for_key: false,
    details: %{},
    rule_source: nil,
    origin: nil
  ]

  @type t :: %__MODULE__{
          field_path: Protovalidate.FieldPath.t(),
          rule_path: [String.t()],
          rule_id: String.t(),
          rule_source: Protovalidate.RuleSource.t() | nil,
          origin: Origin.t() | nil,
          message: String.t(),
          for_key: boolean(),
          details: map()
        }

  @type option() ::
          {:rule_path, [String.t()]}
          | {:rule_source, Protovalidate.RuleSource.t() | nil}
          | {:origin, Origin.t() | nil}
          | {:for_key, boolean()}
          | {:details, map()}

  @spec new(Protovalidate.FieldPath.t(), String.t(), String.t(), [option()]) :: t()
  def new(field_path, rule_id, message, options \\ []) do
    %__MODULE__{
      field_path: field_path,
      rule_path: Keyword.get(options, :rule_path, String.split(rule_id, ".")),
      rule_id: rule_id,
      rule_source: Keyword.get(options, :rule_source),
      origin: Keyword.get(options, :origin),
      message: message,
      for_key: Keyword.get(options, :for_key, false),
      details: Keyword.get(options, :details, %{})
    }
  end
end
