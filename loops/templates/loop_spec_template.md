# Loop Spec Template

## id

`<loop_id>`

## name

`<human_readable_name>`

## trigger

Manual, scheduled, or event-driven.

## class

`source_implementation | documentation_sync | data_pipeline | ai_judgment | execution_or_trading`

## goal

A verifiable target. Avoid vague goals.

## scope

Allowed files, modules, docs, layers, and feature gates.

## inputs

Required docs, config, source files, tests, tickets, and decisions.

## steps

1. Read required docs.
2. Inspect relevant files.
3. Plan minimal change.
4. Implement.
5. Verify.
6. Repair if verification fails.
7. Sync docs and memory.
8. Stop with terminal state.

## verification

- verification_level:
- required_checks:
- optional_checks:
- forbidden_shortcuts:

## stopping_rule

Define success, no-op, blocked, stalled, exhausted, and escalated for this loop.

## memory

Where to write loop memory and what fields to include.

## safety_constraints

What must never happen in this loop.

## files_to_update

List files that must be updated if affected.

## handoff_summary

Required final summary format.
