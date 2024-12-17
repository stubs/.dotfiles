require('venv-selector').setup({
    settings = {
        search = {
            cwd = false,
            virtualenvs = {
                command = "$FD /bin/python$ ~/.virtualenvs --full-path -a -L",
            }
        },
    },
})

