let s:root_dir = expand('<sfile>:p:h:h:h')
let s:is_windows = has('win32') || has('win64')
let s:pathsep = s:is_windows ? '\' : '/'
let s:cmd_path = join([s:root_dir, 'node_modules', '.bin', 'fixjson'], s:pathsep) 

function! fixjson#npm#local_command() abort
    if !filereadable(s:cmd_path)
        call fixjson#npm#install()
    endif
    return s:cmd_path
endfunction

function! fixjson#npm#install() abort
    if !executable('npm')
        throw "'npm' command is required to install 'fixjson' command"
    endif
    echo "Installing fixjson using npm at '" . s:root_dir . "'..."
    let cmd = 'cd ' . shellescape(s:root_dir) . ' && npm install --no-package-lock fixjson'
    let out = system(cmd)
    if v:shell_error || !filereadable(s:cmd_path)
        throw printf("Failed to install fixjson by '%s': %s", cmd, out)
    endif
    echo 'Done! Installed fixjson to ' . s:cmd_path
endfunction
