defmodule Protovalidate.CEL.Library do
  @moduledoc false

  alias Celixir.AST
  alias Protovalidate.Rules.String.Format

  @functions %{
    {"isEmail", 0} => {"_pv_is_email", &Format.email?/1},
    {"isHostname", 0} => {"_pv_is_hostname", &Format.hostname?/1},
    {"isHostAndPort", 0} => {"_pv_is_host_and_port_1", &Format.host_and_port?/1},
    {"isHostAndPort", 1} => {"_pv_is_host_and_port_2", &Format.host_and_port_required?/2},
    {"isIp", 0} => {"_pv_is_ip_1", &Format.ip?/1},
    {"isIp", 1} => {"_pv_is_ip_2", &Format.ip?/2},
    {"isIpPrefix", 0} => {"_pv_is_ip_prefix_1", &Format.ip_prefix?/1},
    {"isIpPrefix", 1} => {"_pv_is_ip_prefix_2", &Format.ip_prefix_option?/2},
    {"isIpPrefix", 2} => {"_pv_is_ip_prefix_3", &Format.ip_prefix_options?/3},
    {"isUri", 0} => {"_pv_is_uri", &Format.uri?/1},
    {"isUriRef", 0} => {"_pv_is_uri_ref", &Format.uri_ref?/1}
  }

  def register(environment) do
    Enum.reduce(@functions, environment, fn {_signature, {name, function}}, env ->
      Celixir.Environment.put_function(env, name, function)
    end)
  end

  def rewrite(%AST.Call{function: name, target: target, args: args} = ast) do
    ast = %{ast | target: rewrite(target), args: Enum.map(args, &rewrite/1)}

    case Map.get(@functions, {name, length(args)}) do
      {internal_name, _function} when not is_nil(target) -> %{ast | function: internal_name}
      _other -> ast
    end
  end

  def rewrite(%_module{} = ast) do
    entries = Map.new(Map.from_struct(ast), fn {key, value} -> {key, rewrite(value)} end)
    struct!(ast.__struct__, entries)
  end

  def rewrite(values) when is_list(values), do: Enum.map(values, &rewrite/1)

  def rewrite(value) when is_tuple(value),
    do: value |> Tuple.to_list() |> Enum.map(&rewrite/1) |> List.to_tuple()

  def rewrite(value), do: value
end
