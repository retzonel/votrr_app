#!/bin/bash
# ─────────────────────────────────────────────
# Votrr — Folder Scaffold Script
# Run this from INSIDE your votrr/ project root
# ─────────────────────────────────────────────

dirs=(
  "lib/app"
  "lib/core/constants"
  "lib/core/errors"
  "lib/core/extensions"
  "lib/core/theme"
  "lib/core/utils"
  "lib/features/auth/data"
  "lib/features/auth/domain"
  "lib/features/auth/presentation/providers"
  "lib/features/biometric/data"
  "lib/features/biometric/presentation/providers"
  "lib/features/home/data"
  "lib/features/home/domain"
  "lib/features/home/presentation/providers"
  "lib/features/voting/data"
  "lib/features/voting/domain"
  "lib/features/voting/presentation/providers"
  "lib/features/results/data"
  "lib/features/results/presentation/providers"
  "lib/features/profile/data"
  "lib/features/profile/presentation/providers"
  "lib/shared/widgets"
  "lib/shared/models"
  "lib/services"
  "assets/images"
  "assets/icons"
)

for dir in "${dirs[@]}"; do
  mkdir -p "$dir"
  echo "✓ $dir"
done

echo ""
echo "Votrr scaffold complete."
