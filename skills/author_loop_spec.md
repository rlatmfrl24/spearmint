# Skill: Author a Loop Specification

Use this skill when no existing loop in `loops/` fits the requested work.

## Steps

1. Read `docs/22_LOOP_ENGINEERING.md`.
2. Copy `loops/templates/loop_spec_template.md`.
3. Choose one loop class from `config/loops.yaml`.
4. Define a verifiable goal.
5. Declare verification level.
6. Define named terminal states.
7. Define memory path.
8. Add safety constraints.
9. Add files that must be updated if the loop changes contracts.
10. Add the new loop to `docs/23_LOOP_LIBRARY.md`.

## Checks

- The loop has trigger, goal, verification, stopping rule, and memory.
- The loop has at least one deterministic or rule-based check if it is expected to run autonomously.
- A model judge is never the same agent that produced the output.
- Failed verification cannot end as success.
