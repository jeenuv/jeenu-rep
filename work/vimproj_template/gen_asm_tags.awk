# Filter lines that declare a symbol using ENTRY(blah)
match($0,"^ENTRY\\(([a-zA-Z0-9_]+)\\)", mm) {
  # Capture the actual tag from ENTRY() macro
  print mm[1] "\t" FILENAME "\t" FNR ";\""
  next
}

# Filter lines with .macro or .equ
/\.(macro|equ)/ {
  # The second field contains the name, but possibly others than a trailing comma
  # for example:
  #   .macro addruart,foo,bar,blah
  # So we take the second field and pick everything up until the first non-alnum
  if (match($2, "^([a-zA-Z0-9_]+)", mm)) {
    print mm[1] "\t" FILENAME "\t" FNR ";\""
    next
  }
}
