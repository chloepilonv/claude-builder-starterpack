---
name: nebius
description: Nebius AI Cloud operations. Provision GPU instances, run jobs, manage storage, monitor costs. Examples — /nebius provision A100 | /nebius run ./sim.py | /nebius status | /nebius stop | /nebius logs job-abc123
disable-model-invocation: false
---

# Nebius AI Cloud Operations

Invoke the `nebius-agent` subagent to perform Nebius infrastructure operations.

**Usage examples:**
```
/nebius provision gpu for physnemo         # Spin up a GPU instance
/nebius run ./scripts/run_sim.py           # Execute a script on the instance
/nebius status                             # Check instance and job status
/nebius logs job-abc123                    # Tail job logs
/nebius download outputs                   # Pull results from storage
/nebius stop                               # Stop instance (save costs)
/nebius setup environment pytorch cuda     # Configure the instance environment
/nebius estimate cost A100 8hours          # Get cost estimate before provisioning
```

Pass `$ARGUMENTS` directly to nebius-agent.

This skill can be called standalone or from within an MVP build phase when compute is needed.
