
" Returns 1 when a cabal file exists in the current directory, and 0 otherwise.
function! haskell#CabalFileExists() abort

    return len(glob('*.cabal')) > 0

endfunction

" Given a module name, attempt to find the file it corresponds to
function! haskell#FindImport(modname, ix)

    let l:fname=substitute(a:modname,'\.','/','g')
    let l:dirs=split(&path, ',')
    let l:suff=split(&suffixesadd, ',')

    for dir in split(&path, ',')
        for suffix in split(&suffixesadd, ',')

            let l:matches=globpath(l:dir, l:fname . l:suffix, 0, 1)
            if len(l:matches) > 0
                execute 'edit ' . get(l:matches, a:ix)
                return
            endif

        endfor
    endfor

    echoerr 'Unable to find module: ' . a:modname

endfunction

" Setup the include and includeexpr options to parse import declarations
function! haskell#FollowImports() abort

    setlocal include=\\s*import\\s\\+\\(qualified\\s\\+\\)\\?\\zs[^\ \\t]\\+\\ze
    nnoremap gf :call haskell#FindImport(expand('<cfile>'), 0)<Cr>
    setlocal suffixes+=.hi,.o
    setlocal suffixesadd=.hs,.hsc,.y,.x
    setlocal path=.,*

endfunction
