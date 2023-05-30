#!/bin/bash

directory="./sources/stock-lambda"

output_file="stock_lambda.zip"

cd "$directory" || exit

zip -r "$output_file" ./*

mv "$output_file" ../../"$output_file"