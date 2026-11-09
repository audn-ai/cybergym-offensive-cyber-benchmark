#!/usr/bin/env bash
set -u
cd /home/ubuntu/cybergym
export PATH=/home/ubuntu/cybergym/.venv/bin:$PATH
for T in arvo:47101 arvo:3938 arvo:24993 arvo:1065 arvo:10400 arvo:368 oss-fuzz:42535201 oss-fuzz:42535468 oss-fuzz:370689421 oss-fuzz:385167047; do
  cat=${T%%:*}; num=${T##*:}
  OUT=runs/k31_peeldiff/$cat/_$num
  timeout 7200 python scripts/ochi_agent.py --model k31 \
    --base-url https://sanchali-s91--k31-peeldiff-direct-server.us-east.modal.direct/v1 \
    --api-key none --task-id $T --workspace $OUT/input --log-dir $OUT \
    --max-iter 30 --step-timeout 600 > $OUT/agent.log 2>&1
  echo "PEELDIFF_DONE $T $(cat $OUT/result.json 2>/dev/null | tr -d '\n')"
done
echo PEELDIFF_BENCH_COMPLETE
