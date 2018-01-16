let s:V = vital#fixjson#new()
let s:P = s:V.import('Async.Promise')
let s:J = s:V.import('System.Job')

function! s:echoerr(msg) abort
    echohl ErrorMsg
    echomsg type(a:msg) == type('') ? a:msg : string(a:msg)
    echohl None
endfunction

function! s:ensure_command() abort
    if executable('fixjson')
        return 'fixjson'
    endif
    return fixjson#npm#local_command()
endfunction

function! fixjson#format_sync() abort
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
        call s:echoerr(v:exception)
    finally
        if exists('l:saved')
            call winrestview(saved)
        endif
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
        call self.resolve(self.stdout)
    else
        call self.reject(join(self.err, "\n"))
    endif
endfunction

function! s:start_format_job(resolve, reject) abort
    let cmd = s:ensure_command()
    let stdin = getline(1, '$')
    let job = s:J.start([cmd], {
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

function! s:apply_to_buf(lines) abort
    let saved = winsaveview()
    try
        %delete _
        call setline(1, a:lines)
        if empty(&buftype)
            noautocmd write!
        else
            set nomodified
        endif
    finally
        call winrestview(saved)
    endtry
endfunction

function! fixjson#format_async() abort
    if !s:P.is_available() || !s:J.is_available()
        throw 'fixjson: Async format is not available'
    endif
    return s:P.new(function('s:start_format_job'))
            \.then(function('s:apply_to_buf'))
            \.catch({err -> s:echoerr(err)})
endfunction

function! fixjson#format() abort
    try
        call fixjson#format_async()
    catch /^fixjson: Async format is not available$/
        call fixjson#format_sync()
    endtry
endfunction
