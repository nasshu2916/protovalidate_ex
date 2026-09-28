defmodule Protovalidate.Plan.Context do
  @moduledoc false
  alias Buf.Validate.FieldPath, as: WireFieldPath
  alias Protovalidate.{FieldPath, Violation, ViolationPath}

  defstruct violations: [],
            path: [],
            rule_prefix: [],
            for_key: false,
            stopped: false,
            count: 0,
            fail_fast: false,
            now: nil,
            options: [],
            validation_budget: nil,
            active_source: nil,
            wire_prefix: [],
            wire_fields: %{}

  @type t :: %__MODULE__{
          violations: [Protovalidate.Violation.t()],
          path: [FieldPath.segment()],
          rule_prefix: [String.t()],
          for_key: boolean(),
          stopped: boolean(),
          count: non_neg_integer(),
          fail_fast: boolean(),
          now: map(),
          options: keyword(),
          validation_budget: Protovalidate.ValidationBudget.t(),
          active_source: Protovalidate.RuleSource.t() | nil,
          wire_prefix: [Buf.Validate.FieldPathElement.t()],
          wire_fields: %{String.t() => Buf.Validate.FieldPathElement.t()}
        }

  @spec new(keyword()) :: t()
  def new(options), do: new(options, fn -> System.monotonic_time(:millisecond) end)

  @doc false
  @spec new(keyword(), (-> integer())) :: t()
  def new(options, clock) do
    budget =
      Keyword.get_lazy(options, :validation_budget, fn ->
        Protovalidate.ValidationBudget.new(options, clock)
      end)

    %__MODULE__{
      fail_fast: Keyword.fetch!(options, :fail_fast),
      options: options,
      validation_budget: budget,
      now: Keyword.get_lazy(options, :now, &Protovalidate.Rules.WellKnown.timestamp_now/0)
    }
  end

  def remaining(%{validation_budget: budget}),
    do: Protovalidate.ValidationBudget.remaining(budget)

  @spec scope(t(), [FieldPath.segment()], boolean(), Buf.Validate.FieldPathElement.t() | nil) ::
          t()
  def scope(context, segments, for_key \\ false, wire_element \\ nil) do
    prefix = if wire_element, do: context.wire_prefix ++ [wire_element], else: context.wire_prefix
    %{context | path: context.path ++ segments, for_key: for_key, wire_prefix: prefix}
  end

  def for_plan(context, plan) do
    fields =
      plan.wire_fields ||
        Map.new(plan.fields, fn %{field: field} ->
          {field.name, ViolationPath.field_element(field)}
        end)

    %{context | wire_fields: fields}
  end

  def wire_field(context, field), do: Map.fetch!(context.wire_fields, field.name)

  def collection_wire_field(%{wire_fields: fields}, field, segment) do
    case Map.fetch(fields, field.name) do
      {:ok, element} -> ViolationPath.subscript(element, segment, field)
      :error when map_size(fields) == 0 -> nil
    end
  end

  @spec restore(t(), t()) :: t()
  def restore(context, parent),
    do: %{
      context
      | path: parent.path,
        for_key: parent.for_key,
        rule_prefix: parent.rule_prefix,
        wire_prefix: parent.wire_prefix,
        wire_fields: parent.wire_fields
    }

  @spec add(t(), Protovalidate.Violation.t()) :: Protovalidate.Rules.result()
  def add(context, violation) do
    source = violation.rule_source || context.active_source

    violation = %{
      violation
      | field_path: FieldPath.new(context.path ++ violation.field_path.segments),
        for_key: context.for_key,
        rule_path: context.rule_prefix ++ violation.rule_path,
        rule_source: source,
        origin: origin(context, violation, source)
    }

    result(%{
      context
      | violations: [violation | context.violations],
        count: context.count + 1,
        stopped: context.fail_fast
    })
  end

  defp origin(%{wire_fields: fields}, %{origin: nil}, nil) when map_size(fields) == 0,
    do: nil

  defp origin(context, violation, source) do
    constraint =
      case violation.origin do
        %Violation.Origin{constraint: kind} -> kind
        _ -> if(source, do: source.kind, else: :field)
      end

    field = field_path(context, violation, constraint)

    rule =
      case violation.origin do
        %Violation.Origin{rule: path} -> path
        _ -> if(source, do: source.wire_path, else: nil)
      end

    index = if violation.origin, do: violation.origin.index
    %Violation.Origin{constraint: constraint, field: field, rule: rule, index: index}
  end

  defp field_path(%{wire_prefix: []}, %{field_path: %{segments: []}}, constraint)
       when constraint in [:message_oneof, :message_cel],
       do: nil

  defp field_path(context, violation, _constraint) do
    local =
      case violation.origin do
        %Violation.Origin{field: %WireFieldPath{elements: elements}} -> elements
        _ -> Enum.map(violation.field_path.segments, &local_element(&1, context.wire_fields))
      end

    %WireFieldPath{elements: context.wire_prefix ++ local}
  end

  defp local_element({:field, name}, fields), do: Map.fetch!(fields, name)

  @spec result(t()) :: Protovalidate.Rules.result()
  def result(%{stopped: true} = context), do: {:halt, context}
  def result(context), do: {:cont, context}

  defdelegate map_key_type(type), to: Protovalidate.DescriptorAdapter
end
