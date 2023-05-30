#!/bin/bash

directory="./sources/stock-increase-lambda"

output_file="stock_increase_lambda.zip"

cd "$directory" || exit

zip -r "$output_file" ./*

mv "$output_file" ../../"$output_file"