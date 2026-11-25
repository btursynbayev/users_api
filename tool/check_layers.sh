#!/bin/bash
set -e

fail=0

http_files=$(grep -rl "package:http" lib/ 2>/dev/null \
  | grep -v -e 'core/api' -e '_repository\.dart' || true)
if [ -n "$http_files" ]; then
  echo "❌ package:http found outside core/api or *_repository.dart:"
  echo "$http_files"
  fail=1
fi

material_files=$(grep -rl "package:flutter/material" lib/ 2>/dev/null \
  | grep -e '_model\.dart' -e '_repository\.dart' -e 'core/api' || true)
if [ -n "$material_files" ]; then
  echo "❌ flutter/material found in model/repository/core/api:"
  echo "$material_files"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "✅ Layer check passed."
fi
exit "$fail"