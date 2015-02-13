ampersand_can_be_encoded() {
  local encoded="$(xml__encode_text "a & b")"

  assertion__equal "a &amp; b" "${encoded}"
}

lesser_than_can_be_encoded() {
  local encoded="$(xml__encode_text "a < b")"

  assertion__equal "a &lt; b" "${encoded}"
}

greater_than_can_be_encoded() {
  local encoded="$(xml__encode_text "a > b")"

  assertion__equal "a &gt; b" "${encoded}"
}

double_quote_than_can_be_encoded() {
  local encoded="$(xml__encode_text "\"this is a quoted text\"")"

  assertion__equal "&quot;this is a quoted text&quot;" "${encoded}"
}

single_quote_than_can_be_encoded() {
  local encoded="$(xml__encode_text "'this is a quoted text'")"

  assertion__equal "&apos;this is a quoted text&apos;" "${encoded}"
}

full_text_can_be_encoded() {
  local encoded="$(xml__encode_text "<body>Wallace & Grmomit</body>")"

  assertion__equal "&lt;body&gt;Wallace &amp; Grmomit&lt;/body&gt;" "${encoded}"
}
