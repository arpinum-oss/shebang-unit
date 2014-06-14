function ampersand_can_be_encoded() {
  local encoded="$(xml__encode_text "a & b")"

  assertion__equal "a &amp; b" "${encoded}"
}

function lesser_than_can_be_encoded() {
  local encoded="$(xml__encode_text "a < b")"

  assertion__equal "a &lt; b" "${encoded}"
}

function greater_than_can_be_encoded() {
  local encoded="$(xml__encode_text "a > b")"

  assertion__equal "a &gt; b" "${encoded}"
}

function double_quote_than_can_be_encoded() {
  local encoded="$(xml__encode_text "\"this is a quoted text\"")"

  assertion__equal "&quot;this is a quoted text&quot;" "${encoded}"
}

function single_quote_than_can_be_encoded() {
  local encoded="$(xml__encode_text "'this is a quoted text'")"

  assertion__equal "&apos;this is a quoted text&apos;" "${encoded}"
}

function full_text_can_be_encoded() {
  local encoded="$(xml__encode_text "<body>Wallace & Grmomit</body>")"

  assertion__equal "&lt;body&gt;Wallace &amp; Grmomit&lt;/body&gt;" "${encoded}"
}