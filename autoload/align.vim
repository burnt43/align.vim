" TEST
function! align#AlignChar(type, char)
  if a:type ==# 'V'
    let start_line      = line("'<")
    let end_line        = line("'>")
    let current_line    = start_line
    let max_column      = 0
    let lines_with_char = {}

    " alter the pattern if it needs to be escaped in very magic
    if a:char ==# '='
      let pattern = '\v\='
    else
      let pattern = '\v' . a:char
    end

    " loop to find what is the right-most char
    while current_line <= end_line
      call cursor(current_line, 1) 
      let matched_line_number = search(pattern, '', end_line)

      if matched_line_number == current_line
        let lines_with_char[current_line] = 1

        let matched_col = col('.')
        if matched_col > max_column
          let max_column = matched_col
        endif
      else
        let lines_with_char[current_line] = 0
      endif
      
      let current_line += 1
    endwhile

    " loop to add whitespace
    let current_line = start_line

    while current_line <= end_line
      if lines_with_char[current_line]
        call cursor(current_line, 1)
        call search(pattern, '', end_line)

        let matched_col = col('.')
        silent execute "normal! i" . repeat(' ', max_column - matched_col) . "\<esc>"
      endif

      let current_line += 1
    endwhile
  end
endfunction
