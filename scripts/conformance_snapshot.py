#!/usr/bin/env python3
"""固定版 harness の全件ログを分類し、新しい失敗を CI で検出する。"""
import argparse
import collections
import json
import re
from pathlib import Path


REASONS = {}

# 各項目は、1回の互換性変更としてレビューできる原因単位にする。
# library の固有関数と標準ルールから同じ関数を呼ぶケースは同じ理由にまとめる。
WORK_ITEMS = (
    {
        "id": "CEL_LIBRARY_IS_EMAIL",
        "summary": "isEmail() の local part と末尾ドット判定を合わせる",
        "owners": ["lib/protovalidate/rules/string/format.ex"],
        "reason_codes": ("F1",),
        "fixture": "library/is_email/invalid/trailing_dot",
    },
    {
        "id": "CEL_LIBRARY_IS_HOST_AND_PORT",
        "summary": "isHostAndPort() と標準ルールの optional_port・port 表記を合わせる",
        "owners": ["lib/protovalidate/rules/string/format.ex", "lib/protovalidate/cel/library.ex"],
        "reason_codes": ("F2",),
        "fixture": "library/is_host_and_port/port_required/false/valid/example",
    },
    {
        "id": "CEL_LIBRARY_IS_HOSTNAME",
        "summary": "isHostname() で末尾が数字だけの label を判定する",
        "owners": ["lib/protovalidate/rules/string/format.ex"],
        "reason_codes": ("F3",),
        "fixture": "library/is_hostname/invalid/last_label_must_not_be_all_digits",
    },
    {
        "id": "CEL_LIBRARY_IS_IP",
        "summary": "isIp() で IPv6 zone ID を判定する",
        "owners": ["lib/protovalidate/rules/string/format.ex"],
        "reason_codes": ("F4",),
        "fixture": "library/is_ip/version/omitted/valid/ipv6_zone-id",
    },
    {
        "id": "CEL_LIBRARY_IS_IP_PREFIX",
        "summary": "isIpPrefix() の prefix 長と strict 判定を合わせる",
        "owners": ["lib/protovalidate/rules/string/format.ex", "lib/protovalidate/cel/library.ex"],
        "reason_codes": ("F5",),
        "fixture": "library/is_ip_prefix/version/0/strict/omitted/valid/ipv4_prefix",
    },
    {
        "id": "CEL_LIBRARY_IS_URI",
        "summary": "isUri() の host と zone ID 判定を合わせる",
        "owners": ["lib/protovalidate/rules/string/format.ex"],
        "reason_codes": ("F6",),
        "fixture": "library/is_uri/invalid/host_reg-name_pct-encoded_invalid_utf8",
    },
    {
        "id": "PREDEFINED_REGISTRY_HARNESS",
        "summary": "harness の predefined extension の wire field を登録する",
        "owners": ["lib/protovalidate/conformance/runtime_descriptor_adapter.ex", "lib/protovalidate/conformance/executor.ex", "lib/protovalidate/predefined_rule_registry.ex", "lib/protovalidate/rules/custom.ex", "lib/protovalidate/rule_source.ex", "lib/protovalidate/violation_codec.ex"],
        "reason_codes": ("P1",),
        "fixture": "predefined_rules/proto/2023/bool/invalid",
    },
    {
        "id": "PRESENCE_DEFAULTS",
        "summary": "proto2 と edition 2023 の明示的 presence と default 値を保持する",
        "owners": ["lib/protovalidate/conformance/runtime_descriptor_adapter.ex", "lib/protovalidate/descriptor_adapter.ex"],
        "reason_codes": ("P2",),
        "fixture": "standard_rules/required/proto2/scalar/optional_with_default/default",
    },
    {
        "id": "DELIMITED_DESCRIPTOR",
        "summary": "delimited message を runtime descriptor で解決する",
        "owners": ["lib/protovalidate/conformance/runtime_descriptor_adapter.ex"],
        "reason_codes": ("D1",),
        "fixture": "standard_rules/ignore/proto/2023/message/explicit_presence/delimited/ignore_empty/invalid/default",
    },
    {
        "id": "GROUP_RECURSION",
        "summary": "group の再帰検証を実装する",
        "owners": ["lib/protovalidate/conformance/runtime_descriptor_adapter.ex", "lib/protovalidate/plan/evaluator.ex"],
        "reason_codes": ("G1",),
        "fixture": "groups/custom/invalid",
    },
)


def classify(suite, case, block):
    if suite == "predefined_rules":
        return "P1"
    if suite == "groups":
        return "G1"
    if suite == "standard_rules/string" and case.startswith("host_and_port/"):
        return "F2"
    if suite.startswith("library/"):
        library_rule = suite.split("/", 1)[1]
        return {
            "is_email": "F1", "is_host_and_port": "F2", "is_hostname": "F3",
            "is_ip": "F4", "is_ip_prefix": "F5", "is_uri": "F6",
        }.get(library_rule, "UNCLASSIFIED")
    if suite.startswith("standard_rules/"):
        if "/delimited/" in case or "/length_prefixed/" in case:
            return "D1"
        if suite in ("standard_rules/ignore", "standard_rules/ignore_empty", "standard_rules/required"):
            return "P2"
    return "UNCLASSIFIED"


def parse(log):
    summary = re.search(r"(?m)^(?:FAIL|PASS) \(failed: (\d+), skipped: (\d+), passed: (\d+), total: (\d+)\)$", log)
    if not summary:
        raise ValueError("harness の全件終了記録がありません")
    counts = dict(zip(["failed", "skipped", "passed", "total"], map(int, summary.groups())))
    cases = {}
    suite = None
    for block in re.split(r"(?m)(?=^--- (?:FAIL|PASS):|^    --- FAIL:)", log):
        match = re.match(r"--- (?:FAIL|PASS): (.*?) \(", block)
        if match:
            suite = match[1]
        elif block.startswith("    --- FAIL:"):
            if suite is None:
                raise ValueError("suite のない失敗ケースです")
            case = block.splitlines()[0].removeprefix("    --- FAIL: ")
            key = f"{suite}/{case}"
            if key in cases:
                raise ValueError(f"重複ケース: {key}")
            issue = classify(suite, case, block)
            want = re.search(r"(?m)^\s+want: (.*)$", block)
            got = re.search(r"(?m)^\s+got: (.*)$", block)
            if not want or not got:
                raise ValueError(f"期待・実測結果のないケース: {key}")
            cases[key] = {"issue": issue, "expected": want[1], "actual": got[1]}
    if len(cases) != counts["failed"] or sum(counts[k] for k in ["failed", "skipped", "passed"]) != counts["total"]:
        raise ValueError("ケース数と終了記録が一致しません")
    if counts["skipped"]:
        raise ValueError("全件基準に skipped ケースを含められません")
    return {"version": "1.2.2", "command": "mise run conformance:all", "counts": counts,
            "reasons": REASONS, "failures": dict(sorted(cases.items()))}


def compare(current, baseline):
    if current["version"] != baseline["version"] or current["counts"]["total"] != baseline["counts"]["total"]:
        raise ValueError("版または全件数が基準から変わっています")
    regressions = {key for key, result in current["failures"].items()
                   if key not in baseline["failures"] or result != baseline["failures"][key]}
    fixed = baseline["failures"].keys() - current["failures"].keys()
    if regressions:
        raise ValueError("新規・変化した失敗:\n" + "\n".join(sorted(regressions)))
    print(f"新規失敗 0、改善 {len(fixed)}、既知失敗 {len(current['failures'])}")


def case_diff(current, baseline):
    """旧基準との case ID と実測値の差を保存する。"""
    before = baseline["failures"]
    after = current["failures"]
    shared = before.keys() & after.keys()
    actual_changed = {
        key: {"expected": after[key]["expected"], "before": before[key]["actual"], "after": after[key]["actual"]}
        for key in sorted(shared) if before[key]["actual"] != after[key]["actual"]
    }
    reclassified = {
        key: {"before": before[key]["issue"], "after": after[key]["issue"]}
        for key in sorted(shared) if before[key]["issue"] != after[key]["issue"]
    }
    return {
        "version": current["version"],
        "before_counts": baseline["counts"],
        "after_counts": current["counts"],
        "fixed": sorted(before.keys() - after.keys()),
        "new": {key: after[key] for key in sorted(after.keys() - before.keys())},
        "actual_changed": actual_changed,
        "reclassified": reclassified,
    }


def implementation_plan(snapshot):
    """失敗を重複なく、実装可能な作業項目へ対応付ける。"""
    assignments = {}
    items = []

    for item in WORK_ITEMS:
        cases = sorted(
            key for key in snapshot["failures"]
            if snapshot["failures"][key]["issue"] in item["reason_codes"]
        )

        # 解消済みの項目は次の全件実行で計画から外す。
        if not cases:
            continue

        if item["fixture"] not in cases:
            raise ValueError(f"縮小 fixture が対象ケースにありません: {item['id']}")

        for key in cases:
            if key in assignments:
                raise ValueError(f"複数の作業項目に対応したケース: {key}")
            assignments[key] = item["id"]

        items.append({
            "id": item["id"],
            "summary": item["summary"],
            "owners": item["owners"],
            "case_count": len(cases),
            "fixture": item["fixture"],
            "command": fixture_command(item["fixture"]),
        })

    missing = sorted(set(snapshot["failures"]) - set(assignments))
    if missing:
        raise ValueError("原因未分類の失敗:\n" + "\n".join(missing))

    if len(assignments) != snapshot["counts"]["failed"]:
        raise ValueError("作業項目のケース数と失敗件数が一致しません")

    return {
        "version": snapshot["version"],
        "counts": snapshot["counts"],
        "work_items": items,
        "assignments": dict(sorted(assignments.items())),
    }


def fixture_command(case):
    parts = case.split("/")
    suite_parts = 2 if parts[0] in ("library", "standard_rules") else 1
    suite = "/".join(parts[:suite_parts])
    name = "/".join(parts[suite_parts:])
    return (
        "mise run conformance:all -- "
        f"--suite '^{re.escape(suite)}$' --case '^{re.escape(name)}$' --verbose"
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("log", type=Path)
    parser.add_argument("--write", type=Path)
    parser.add_argument("--check", type=Path)
    parser.add_argument("--plan", type=Path,
                        help="原因別の実装計画 JSON を出力する")
    parser.add_argument("--diff-from", type=Path, help="旧 baseline JSON")
    parser.add_argument("--diff-write", type=Path, help="case 単位の差分 JSON")
    args = parser.parse_args()
    if bool(args.diff_from) != bool(args.diff_write):
        parser.error("--diff-from と --diff-write は一緒に指定してください")
    snapshot = parse(args.log.read_text())
    print(json.dumps(snapshot["counts"]))
    print(json.dumps(dict(collections.Counter(v["issue"] for v in snapshot["failures"].values())), sort_keys=True))
    if args.check:
        compare(snapshot, json.loads(args.check.read_text()))
    if args.diff_from:
        diff = case_diff(snapshot, json.loads(args.diff_from.read_text()))
        args.diff_write.write_text(json.dumps(diff, ensure_ascii=False, indent=2) + "\n")
        print(json.dumps({key: len(diff[key]) for key in ("fixed", "new", "actual_changed", "reclassified")}))
    if args.write:
        args.write.write_text(json.dumps(snapshot, ensure_ascii=False, indent=2) + "\n")
    if args.plan:
        plan = implementation_plan(snapshot)
        args.plan.parent.mkdir(parents=True, exist_ok=True)
        args.plan.write_text(json.dumps(plan, ensure_ascii=False, indent=2) + "\n")
        print(json.dumps({item["id"]: item["case_count"] for item in plan["work_items"]}, sort_keys=True))


if __name__ == "__main__":
    main()
