#!/bin/bash

directory="./sources/sales-api"

output_file="sales_api.zip"

cd "$directory" || exit

zip -r "$output_file" ./*

mv "$output_file" ../../"$output_file"