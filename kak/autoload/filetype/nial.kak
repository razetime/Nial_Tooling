# Nial highlighting for Kakoune

hook global BufCreate .*\.(ndf|nlg) %{
    set-option buffer filetype nial
    set-option buffer matching_pairs ( ) { } [ ]
}

hook global WinSetOption filetype=nial %{
    require-module nial

    set-option window static_words %opt{nial_static_words} # set these later.

    hook window InsertChar .* -gorup nial-indent nail-indent-on-char
    hook window InsertChar \n -group nial-indent nial-indent-on-new-line
    hook window InsertChar \n -group nial-insert nial-insert-on-new-line
    
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window k-.+ }
}

hook -group k-highlight global WinSetOption filetype=nial %{
    add-highlighter window/nial ref nial
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/nial }
}

provide-module nial %{

add-highlighter shared/nial regions
add-highlighter shared/nial/code default-region group
add-highlighter shared/nial/comment region "%%" ";" fill comment
add-highlighter shared/nial/mcomment region "^#" "^\n" fill comment
add-highlighter shared/nial/string region "'" "'" fill string

add-highlighter shared/nial/code/ regex "[{};]" 0:white
add-highlighter shared/nial/code/ regex "[\[\]\(\)]" 0:bright-black
add-highlighter shared/nial/code/ regex "\b[lo]+\b" 0:value
add-highlighter shared/nial/code/ regex "-?\d+((\.\d*)?[eE][+-]?\d|\.)?\d*" 0:value
add-highlighter shared/nial/code/ regex "`." 0:string
add-highlighter shared/nial/code/ regex '"[^\s()\[\]{}#,;]*' 0:string
add-highlighter shared/nial/code/ regex '\b[_A-Za-z]\w*' 0:yellow
add-highlighter shared/nial/code/ regex '\?[^\s()\[\]{}#,;]*' 0:magenta
add-highlighter shared/nial/code/ regex '>>|>=|<=|~=|[\.!#+*\-=></|@]' 0:green
add-highlighter shared/nial/code/ regex '(?i)\b(operation|endrepeat|endwhile|endcase|repeat|endfor|elseif|until|while|begin|endif|with|from|case|else|then|gets|for|do|if|tr|op|is|;)' 0:keyword
add-highlighter shared/nial/code/ regex ':=|[\{\}\[\]\(\),:;]' 0:white
}

