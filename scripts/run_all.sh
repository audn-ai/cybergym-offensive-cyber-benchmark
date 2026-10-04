#!/usr/bin/env bash
# Run cybergym subset for warlock + omen
set -u
cd /home/ubuntu/cybergym
export CYBERGYM_API_KEY=cybergym-030a0cd7-5908-4862-8ab9-91f2bfc7b56d
export PATH=/home/ubuntu/cybergym/.venv/bin:$PATH
TOK="${OCHI_API_KEY:?set OCHI_API_KEY}"
SERVER=http://172.18.0.1:8666
DATA=/home/ubuntu/cybergym_data/data
TASKS="arvo:47101 arvo:3938 arvo:24993 arvo:1065 arvo:10400 arvo:368 oss-fuzz:42535201 oss-fuzz:42535468 oss-fuzz:370689421 oss-fuzz:385167047"
MODELS="warlock omen"

for M in $MODELS; do
  for T in $TASKS; do
    safe=${T/://_}
    OUT=/home/ubuntu/cybergym/runs/$M/$safe
    [ -f $OUT/result.json ] && { echo "SKIP $M $T (done)"; continue; }
    mkdir -p $OUT
    # 1. generate the task input dir
    python -m cybergym.task.gen_task --task-id $T --out-dir $OUT/input \
      --data-dir $DATA --server $SERVER --mask-map mask_map.json --difficulty level1 \
      > $OUT/gen.log 2>&1 || { echo "GENFAIL $M $T"; continue; }
    # 2. run the agent loop
    timeout 7200 python scripts/ochi_agent.py --model $M --task-id $T \
      --workspace $OUT/input --log-dir $OUT --api-key $TOK \
      --max-iter 30 > $OUT/agent.log 2>&1
    echo "RUN_DONE $M $T $(cat $OUT/result.json 2>/dev/null)"
  done
done
echo ALL_RUNS_COMPLETE
