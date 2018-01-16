if get(b:, 'loaded_fixjson', 0) || &cp
    finish
endif
let b:loaded_fixjson = 1

if get(b:, 'fixjson_fix_on_save', get(g:, 'fixjson_fix_on_save', 1))
    augroup plugin-fixjson-autosave
        autocmd BufWritePre <buffer>
            \   if get(b:, 'fixjson_fix_on_save', get(g:, 'fixjson_fix_on_save', 1))
            \ |     call fixjson#format()
            \ | endif
    augroup END
endif

command! -nargs=0 -buffer -bar FixJson call fixjson#format()
command! -nargs=0 -buffer -bar FixJSON call fixjson#format()
command! -nargs=0 -buffer -bar FixJsonUpdateCommand call fixjson#npm#install()
