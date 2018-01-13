if get(b:, 'loaded_fixjson', 0) || &cp
    finish
endif
let b:loaded_fixjson = 1

let s:var = 'fixjson_fix_on_save'
if get(b:, s:var, get(g:, s:var, 1))
    augroup plugin-fixjson-autosave
        autocmd!
        autocmd BufWritePre <buffer> call fixjson#format()
    augroup END
endif
unlet s:var

command! -nargs=0 -buffer -bar FixJson call fixjson#format()
command! -nargs=0 -buffer -bar FixJSON call fixjson#format()
command! -nargs=0 -buffer -bar FixJsonUpdateCommand call fixjson#npm#install()
