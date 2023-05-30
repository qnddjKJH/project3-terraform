#!/bin/bash

# 스크립트 1 실행
echo "Executing Script 1..."
./scripts/compress-sales_api.sh

# 스크립트 2 실행
echo "Executing Script 2..."
./scripts/compress-stock_lambda.sh

# 스크립트 3 실행
echo "Executing Script 3..."
./scripts/compress-stock_increase_lambda.sh

echo "All scripts executed."
