while IFS= read -r line; do
  echo "Setting $line"
  echo "$line" >> "$GITHUB_ENV"
  value="${line#*=}"
  upper_case_key="${line%%=*}"
  lower_case_key=$(echo "$upper_case_key" | tr '[:upper:]' '[:lower:]')
  echo "Setting TF_ENV_$lower_case_key=$value"
  echo "TF_ENV_$lower_case_key=$value" >> "$GITHUB_ENV"
done < production.env