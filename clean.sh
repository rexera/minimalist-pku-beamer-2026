#!/usr/bin/env bash
# 清理 LaTeX 编译中间文件 / Clean LaTeX build artifacts
#
# 用法 / Usage:
#   ./clean.sh          清理中间文件，保留 main.pdf（clean intermediates, keep main.pdf）
#   ./clean.sh --deep   连同 main.pdf 一起删除（also remove main.pdf）
set -euo pipefail
cd "$(dirname "$0")"

DEEP="${1:-}"

if command -v latexmk >/dev/null 2>&1; then
  latexmk -c main >/dev/null 2>&1 || true
  if [ "$DEEP" = "--deep" ]; then
    latexmk -C main >/dev/null 2>&1 || true
    rm -f main.bbl  # latexmk -c 有意保留 .bbl（投稿用），--deep 档一并删除
  fi
fi

# 兜底删除 latexmk 可能遗漏的中间文件 / remove any leftovers
rm -f main.aux main.log main.out main.toc main.nav main.snm main.vrb \
      main.xdv main.fls main.fdb_latexmk main.run.xml main.bcf main.synctex.gz
rm -rf preview

# 清理 macOS 元数据文件 / drop macOS metadata
find . -name '.DS_Store' -type f -delete 2>/dev/null || true

echo "已清理编译中间文件 / Build artifacts cleaned."
if [ "$DEEP" = "--deep" ]; then
  echo "main.pdf 已一并删除 / main.pdf removed."
fi
