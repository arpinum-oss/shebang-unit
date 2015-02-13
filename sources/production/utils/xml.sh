xml__encode_text() {
  local encoded=${1//\&/\&amp\;}
  encoded=${encoded//\</\&lt\;}
  encoded=${encoded//\>/\&gt\;}
  encoded=${encoded//\"/\&quot\;}
  encoded=${encoded//\'/\&apos\;}
  system__print "${encoded}"
}
