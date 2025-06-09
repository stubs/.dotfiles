require('venv-selector').setup({
    settings = {
        search = {
            cwd = false,
            virtualenvs = {
                command = "fd '/bin/python$' ~/.virtualenvs/*/bin --full-path -a",
            }
        },
    },
})

