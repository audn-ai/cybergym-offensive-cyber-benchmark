#!/usr/bin/env bash
set -u
cd /home/ubuntu/cybergym
export PATH=/home/ubuntu/cybergym/.venv/bin:$PATH
for T in arvo:47101 arvo:3938 arvo:24993 arvo:1065 arvo:10400 arvo:368 oss-fuzz:42535201 oss-fuzz:42535468 oss-fuzz:370689421 oss-fuzz:385167047; do
  cat=${T%%:*}; num=${T##*:}
  OUT=runs/k31_grpo/$cat/_$num
  timeout 7200 python scripts/ochi_agent.py --model k31-grpo-1m \
    --base-url https://sanchali-s91--k31-grpo-infer-1m-server.us-east.modal.direct/v1 \
    --api-key none --task-id $T --workspace $OUT/input --log-dir $OUT \
    --max-iter 30 --step-timeout 600 > $OUT/agent.log 2>&1
  echo "K31GRPO_DONE $T $(cat $OUT/result.json 2>/dev/null | tr -d '\n')"
done
echo K31GRPO_BENCH_COMPLETE
