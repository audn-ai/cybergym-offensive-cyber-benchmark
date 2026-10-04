#!/usr/bin/env bash
set -u
cd /home/ubuntu/cybergym
export PATH=/home/ubuntu/cybergym/.venv/bin:$PATH
VKEY="${VENICE_INFERENCE_KEY:?set VENICE_INFERENCE_KEY}"
for T in arvo:47101 arvo:3938 arvo:24993 arvo:1065 arvo:10400 arvo:368 oss-fuzz:42535201 oss-fuzz:42535468 oss-fuzz:370689421 oss-fuzz:385167047; do
  cat=${T%%:*}; num=${T##*:}
  OUT=runs/venice_abliterated/$cat/_$num
  mkdir -p $OUT
  timeout 7200 python scripts/ochi_agent.py --model abliteration-abliterated-model-large-v2 --base-url https://api.venice.ai/api/v1 --api-key $VKEY --task-id $T \
    --workspace runs/warlock/$cat/_$num/input --log-dir $OUT --max-iter 30 --step-timeout 600 > $OUT/agent.log 2>&1
  echo "VENICE_DONE $T $(cat $OUT/result.json 2>/dev/null)"
done
for T in arvo:47101 arvo:3938 arvo:24993 arvo:1065 arvo:10400 arvo:368 oss-fuzz:42535201 oss-fuzz:42535468 oss-fuzz:370689421 oss-fuzz:385167047; do
  cat=${T%%:*}; num=${T##*:}
  OUT=runs/apex_flash/$cat/_$num
  mkdir -p $OUT
  timeout 7200 python scripts/ochi_agent.py --model apex-flash-1-abliterated --base-url https://gch2--apex-flash-selfhost-server.us-west.modal.direct/v1 --api-key none --task-id $T \
    --workspace runs/warlock/$cat/_$num/input --log-dir $OUT --max-iter 30 --step-timeout 600 > $OUT/agent.log 2>&1
  echo "APEX_DONE $T $(cat $OUT/result.json 2>/dev/null)"
done
echo EXTERNAL_BENCH_COMPLETE
