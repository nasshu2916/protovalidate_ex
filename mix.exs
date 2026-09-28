defmodule Protovalidate.MixProject do
  use Mix.Project

  def project do
    [
      app: :protovalidate,
      version: "0.1.0",
      elixir: "~> 1.19",
      description: "Descriptor-driven Protocol Buffers validation with Buf Protovalidate rules",
      package: [
        files: [
          "lib",
          "priv/conformance/baseline.json",
          "priv/proto",
          "mix.exs",
          "LICENSE",
          "README.md",
          "README_ja.md",
          "CONTRIBUTING.md",
          "CONTRIBUTING_ja.md",
          "docs"
        ],
        licenses: ["Apache-2.0"],
        links: %{}
      ],
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      # buf.validate は lib/generated からコンパイルし、fixture の重複定義は読み込まない。
      test_ignore_filters: [
        &String.starts_with?(&1, "test/generated/"),
        &String.starts_with?(&1, "test/support/")
      ],
      # Protobuf 定義から機械生成したコードと手動実行用の Mix タスクは、
      # プロダクトの分岐を表さないためカバレッジ集計の対象外にする。
      test_coverage: [
        ignore_modules: [
          ~r/^(?:Acme|Buf\.Validate)\./,
          ~r/^Mix\.Tasks\.Protovalidate\./
        ]
      ],
      dialyzer: [plt_add_apps: [:mix, :ex_unit]],
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "benchmarks/lib", "test/generated/acme"]
  defp elixirc_paths(_env), do: ["lib"]

  defp deps do
    [
      {:protobuf, "~> 0.17.0"},
      {:telemetry, "~> 1.3"},
      {:celixir, "~> 0.3.0"},
      {:benchee, "~> 1.5", only: :test},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.38", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        {"README.md", filename: "readme"},
        {"README_ja.md", filename: "readme_ja"},
        "docs/api-design.md",
        "docs/api-design_ja.md",
        "docs/compatibility.md",
        "docs/compatibility_ja.md",
        "docs/rule-support.md",
        "docs/rule-support_ja.md",
        "docs/telemetry.md",
        "docs/telemetry_ja.md",
        "docs/migration.md",
        "docs/migration_ja.md",
        "docs/integrations.md",
        "docs/integrations_ja.md",
        "docs/cel.md",
        "docs/cel_ja.md",
        {"examples/phoenix_sample/README.md", filename: "phoenix-sample"},
        {"examples/phoenix_sample/README_ja.md", filename: "phoenix-sample_ja"}
      ],
      groups_for_extras: [
        Overview: [
          "README.md",
          "docs/api-design.md"
        ],
        Compatibility: [
          "docs/compatibility.md",
          "docs/rule-support.md"
        ],
        Telemetry: ["docs/telemetry.md"],
        Guides: [
          "docs/migration.md",
          "docs/integrations.md",
          "docs/cel.md",
          "examples/phoenix_sample/README.md"
        ],
        "概要（日本語）": [
          "README_ja.md",
          "docs/api-design_ja.md"
        ],
        "互換性（日本語）": [
          "docs/compatibility_ja.md",
          "docs/rule-support_ja.md"
        ],
        "Telemetry（日本語）": ["docs/telemetry_ja.md"],
        "ガイド（日本語）": [
          "docs/migration_ja.md",
          "docs/integrations_ja.md",
          "docs/cel_ja.md",
          "examples/phoenix_sample/README_ja.md"
        ]
      ],
      # 内部実装と生成型は ExDoc の公開モジュール一覧に出さないため、参照警告を除外する。
      skip_undefined_reference_warnings_on: [
        "Buf.Validate.FieldPath",
        "Buf.Validate.Violations",
        "Protovalidate.Plan",
        "Protovalidate.Plan.Compiler",
        "Protovalidate.Plan.Evaluator",
        "Protovalidate.Plan.Context",
        "Protovalidate.Validator.PlanCache",
        "Protovalidate.CELExecution",
        "Protovalidate.CEL.DescriptorResolver",
        "Protovalidate.Validator.CompileConfig",
        "Protovalidate.Violation.Origin",
        "Google.Protobuf.FieldDescriptorProto",
        "Buf.Validate.FieldPath.t()",
        "Buf.Validate.Violations.t()",
        "Protovalidate.CEL.DescriptorResolver.t()",
        "Protovalidate.Validator.CompileConfig.t()",
        "Protovalidate.Violation.Origin.t()",
        "Google.Protobuf.FieldDescriptorProto.t()",
        "lib/protovalidate/violation_codec.ex",
        "lib/protovalidate/violation.ex",
        "lib/protovalidate/cel/type_environment.ex",
        "lib/protovalidate/rule_source.ex",
        "lib/protovalidate/validator.ex",
        "lib/protovalidate/predefined_rule_registry.ex"
      ]
    ]
  end
end
