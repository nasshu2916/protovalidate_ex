"""失敗管理が不完全なログや新規失敗を許容しないことを確認する。"""
import importlib.util
import json
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location("snapshot", Path(__file__).parents[1] / "scripts/conformance_snapshot.py")
snapshot = importlib.util.module_from_spec(spec)
spec.loader.exec_module(snapshot)

LOG = '''--- FAIL: standard_rules/string (failed: 1, skipped: 0, passed: 1, total: 2)
    --- FAIL: uuid/invalid
        want: validation error (1 violation)
         got: valid
FAIL (failed: 1, skipped: 0, passed: 1, total: 2)
'''


class SnapshotTest(unittest.TestCase):
    def test_incomplete_log_is_rejected(self):
        with self.assertRaises(ValueError):
            snapshot.parse(LOG.split("\nFAIL (")[0])

    def test_count_and_skips_are_checked(self):
        for text in [LOG.replace("failed: 1, skipped: 0, passed: 1, total: 2)", "failed: 2, skipped: 0, passed: 0, total: 2)"),
                     LOG.replace("skipped: 0, passed: 1", "skipped: 1, passed: 0")]:
            with self.assertRaises(ValueError):
                snapshot.parse(text)

    def test_new_failure_and_changed_result_are_rejected(self):
        baseline = snapshot.parse(LOG)
        for log in [LOG.replace("uuid/invalid", "email/invalid"), LOG.replace("got: valid", "got: runtime error: broken")]:
            with self.assertRaises(ValueError):
                snapshot.compare(snapshot.parse(log), baseline)

    def test_same_result_and_improvement_are_accepted(self):
        baseline = snapshot.parse(LOG)
        snapshot.compare(snapshot.parse(LOG), baseline)
        snapshot.compare(snapshot.parse("PASS (failed: 0, skipped: 0, passed: 2, total: 2)\n"), baseline)

    def test_implementation_plan_rejects_unclassified_failure(self):
        baseline = snapshot.parse(LOG)
        with self.assertRaisesRegex(ValueError, "原因未分類"):
            snapshot.implementation_plan(baseline)

    def test_fixture_command_uses_full_nested_suite(self):
        command = snapshot.fixture_command("library/is_email/invalid/trailing_dot")
        self.assertIn("--suite '^library/is_email$'", command)
        self.assertIn("--case '^invalid/trailing_dot$'", command)

    def test_saved_baseline_has_one_assignment_per_failure_and_real_fixtures(self):
        baseline_path = Path(__file__).parents[1] / "priv/conformance/baseline.json"
        baseline = json.loads(baseline_path.read_text())
        plan = snapshot.implementation_plan(baseline)
        saved_plan_path = Path(__file__).parents[1] / "priv/conformance/implementation-plan.json"
        saved_plan = json.loads(saved_plan_path.read_text())

        self.assertEqual(saved_plan, plan)
        self.assertEqual(plan["counts"]["failed"], len(plan["assignments"]))
        self.assertEqual(
            plan["counts"]["failed"],
            sum(item["case_count"] for item in plan["work_items"]),
        )
        self.assertNotIn("PREDEFINED_REGISTRY_HARNESS", {item["id"] for item in plan["work_items"]})

        for item in plan["work_items"]:
            self.assertIn(item["fixture"], plan["assignments"])
            self.assertTrue(item["owners"])
            self.assertGreater(item["case_count"], 0)
            self.assertIn("--suite", item["command"])
            self.assertIn("--case", item["command"])

    def test_resolved_items_are_omitted_from_plan(self):
        current = snapshot.parse("PASS (failed: 0, skipped: 0, passed: 2, total: 2)\n")
        plan = snapshot.implementation_plan(current)
        self.assertEqual([], plan["work_items"])
        self.assertEqual({}, plan["assignments"])


if __name__ == "__main__":
    unittest.main()
