defmodule Protovalidate.ValidationError do
  @moduledoc "Indicates that the input violates one or more rules."
  defexception [
    :violations,
    message: "validation failed",
    code: :validation_failed,
    stage: :evaluate
  ]

  @type t :: %__MODULE__{
          violations: [Protovalidate.Violation.t()],
          message: String.t(),
          code: atom(),
          stage: atom()
        }

  def exception(violations: violations) when is_list(violations) do
    %__MODULE__{
      violations: violations,
      message: "validation failed (#{length(violations)} violation(s))"
    }
  end
end

defmodule Protovalidate.CompilationError do
  @moduledoc "Indicates an invalid descriptor or rule definition."
  defexception [:message, :rule_path, code: :invalid_schema, stage: :compile]

  @type t :: %__MODULE__{
          message: String.t(),
          rule_path: [String.t()] | nil,
          code: atom(),
          stage: atom()
        }
end

defmodule Protovalidate.UnsupportedRuleError do
  @moduledoc "Indicates that the validator encountered an unsupported rule."
  defexception [:message, :rule_path, code: :unsupported_rule, stage: :compile]

  @type t :: %__MODULE__{
          message: String.t(),
          rule_path: [String.t()] | nil,
          code: atom(),
          stage: atom()
        }
end

defmodule Protovalidate.RuntimeError do
  @moduledoc "Indicates a runtime failure, such as a mismatch between a message value and its descriptor."
  defexception [:message, code: :runtime_failure, stage: :evaluate]

  @type t :: %__MODULE__{message: String.t(), code: atom(), stage: atom()}
end
