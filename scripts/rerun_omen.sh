#!/usr/bin/env bash
set -u
cd /home/ubuntu/cybergym
export PATH=/home/ubuntu/cybergym/.venv/bin:$PATH
TOK="${OCHI_API_KEY:?set OCHI_API_KEY}"
for T in arvo:47101 arvo:3938 arvo:24993 arvo:1065 arvo:10400 arvo:368 oss-fuzz:42535201 oss-fuzz:42535468 oss-fuzz:370689421 oss-fuzz:385167047; do
  cat=${T%%:*}; num=${T##*:}
  OUT=runs/omen_rerun/$cat/_$num
  mkdir -p $OUT
  timeout 7200 python scripts/ochi_agent.py --model omen --task-id $T \
    --workspace runs/omen/$cat/_$num/input --log-dir $OUT --api-key $TOK \
    --max-iter 30 --step-timeout 600 > $OUT/agent.log 2>&1
  echo "RUN_DONE $T $(cat $OUT/result.json 2>/dev/null)"
done
echo Omen_RERUN_COMPLETE
