function! s:ensure_command() abort
    if executable('fixjson')
        return 'fixjson'
    endif
    return fixjson#npm#local_command()
endfunction

function! fixjson#format() abort
    try
        let bin = s:ensure_command()
        let file = bufname('%')
        let cmd = printf('%s --stdin-filename %s', shellescape(bin), shellescape(file))
        let out = system(cmd, getline(1, '$'))
        if v:shell_error
            throw 'Failed to format. Command failed: ' . out
        endif
        let saved = winsaveview()
        %delete _
        call setline(1, split(out, "\n"))
    catch
        echohl ErrorMsg
        echomsg v:exception
        echohl None
    finally
        if exists('l:saved')
            call winrestview(saved)
        endif
    endtry
endfunction
