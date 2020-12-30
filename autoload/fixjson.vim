let s:V = vital#fixjson#new()
let s:P = s:V.import('Async.Promise')
let s:J = s:V.import('System.Job')

let s:is_windows = has('win32') || has('win64')

function! s:echoerr(msg) abort
    echohl ErrorMsg
    echomsg type(a:msg) == type('') ? a:msg : string(a:msg)
    echohl None
endfunction

function! s:ensure_command() abort
    if exists('g:fixjson_executable')
        if !executable(g:fixjson_executable)
            throw printf("g:fixjson_executable is set to '%s' but it's not executable", g:fixjson_executable)
        endif
        return g:fixjson_executable
    endif
    if executable('fixjson')
        return 'fixjson'
    endif
    return fixjson#npm#local_command()
endfunction

function! s:replace_buf(lines) abort
    let saved = winsaveview()
    try
        silent %delete _
        call setline(1, a:lines)
    finally
        call winrestview(saved)
    endtry
endfunction

function! s:build_command() abort
    let cmd = [s:ensure_command()]
    if s:is_windows
        let cmd = ['cmd', '/c'] + cmd
    endif
    if exists('g:fixjson_indent_size') && type(g:fixjson_indent_size) == type(0)
        let cmd += ['-i', g:fixjson_indent_size]
    endif
    if &buftype ==# ''
        let file = bufname('%')
        let cmd += ['--stdin-filename', file]
    endif
    return cmd
endfunction

function! fixjson#format_sync() abort
    try
        let cmd = join(map(s:build_command(), 'shellescape(v:val)'), ' ')
        let out = system(cmd, getline(1, '$'))
        if v:shell_error
            throw printf("Failed to format. Command '%s' failed: %s", cmd, out)
        endif
        call s:replace_buf(split(out, "\n"))
    catch
        call s:echoerr(v:exception)
    endtry
endfunction

function! s:on_stdout(data) abort dict
    let self.stdout[-1] .= a:data[0]
    call extend(self.stdout, a:data[1:])
endfunction

function! s:on_stderr(data) abort dict
    let self.stderr[-1] .= a:data[0]
    call extend(self.stderr, a:data[1:])
endfunction

function! s:on_exit(status) abort dict
    if line('$') != self.line_before || (!self.modified && &l:modified)
        call self.reject('fixjson: The file was changed before formatting finished')
        return
    endif
    if a:status == 0
        " fixjson adds a newline at the end of output. But we don't need it
        " because vim cares about it. So remove the last newline.
        if len(self.stdout) > 0 && self.stdout[-1] ==# ''
            let self.stdout = self.stdout[:-2]
        endif
        call self.resolve(self.stdout)
    else
        call self.reject(join(self.stderr, "\n"))
    endif
endfunction

function! s:start_format_job(resolve, reject) abort
    let stdin = getline(1, '$')
    let job = s:J.start(s:build_command(), {
            \   'stdout': [''],
            \   'stderr': [''],
            \   'resolve': a:resolve,
            \   'reject': a:reject,
            \   'modified': &l:modified,
            \   'line_before': line('$'),
            \   'on_stdout': function('s:on_stdout'),
            \   'on_stderr': function('s:on_stderr'),
            \   'on_exit': function('s:on_exit'),
            \ })
    call job.send(stdin)
    call job.close()
endfunction

function! s:apply_to_buf(should_save, lines) abort
    call s:replace_buf(a:lines)
    if !a:should_save
        return
    endif
    if &buftype ==# ''
        noautocmd write!
    else
        set nomodified
    endif
endfunction

function! fixjson#format_async(should_save) abort
    if !s:P.is_available() || !s:J.is_available()
        throw 'fixjson: Async format is not available'
    endif
    return s:P.new(function('s:start_format_job'))
            \.then(function('s:apply_to_buf', [a:should_save]))
            \.catch(function('s:echoerr'))
endfunction

function! fixjson#format(should_save) abort
    try
        call fixjson#format_async(a:should_save)
    catch /^fixjson: Async format is not available$/
        call fixjson#format_sync()
    endtry
endfunction
