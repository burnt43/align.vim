function! align#AlignChar(type, char)
  if a:type ==# 'V'
    let start_line      = line("'<")
    let end_line        = line("'>")
    let current_line    = start_line
    let max_column      = 0
    let column_number_by_line = {}

    " alter the pattern if it needs to be escaped in very magic
    if a:char ==# '='
      let pattern = '\v\s\=\s'
    else
      let pattern = '\v' . a:char
    end

    " loop to find what is the right-most char
    while current_line <= end_line
      " see if the line we're on has the pattern and get the column is appears
      let match_column_number = matchstrpos(getline(current_line), pattern)[1]

      if match_column_number !=# -1
        " store the column number into a dictionary
        let column_number_by_line[current_line] = match_column_number

        " set the max_column
        if match_column_number > max_column
          let max_column = match_column_number
        endif
      else
        " put 0 as the column number so this evaluates to false
        let column_number_by_line[current_line] = 0
      endif
      
      let current_line += 1
    endwhile

    " loop to add whitespace
    let current_line = start_line

    while current_line <= end_line
      " check if we found the pattern on this line
      if column_number_by_line[current_line]

        " set the cursor to where the pattern starts and add spaces to align
        " it with the max column
        call cursor(current_line, column_number_by_line[current_line])
        silent execute "normal! i" . repeat(' ', max_column - column_number_by_line[current_line]) . "\<esc>"
      endif

      let current_line += 1
    endwhile
  end
endfunction
