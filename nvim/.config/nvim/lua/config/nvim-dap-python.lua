local dap_python = require('dap-python')
dap_python.test_runner = 'pytest'
dap_python.setup('~/.virtualenvs/debugpy/bin/python')

-- custom configs for venvs
table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'curator debugger',
  program = '${file}',
  python = '/Users/aaron.gonzalez/.virtualenvs/curator-dev/bin/python'
})

table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'aqueduct debugger',
  program = '${file}',
  python = '/Users/aaron.gonzalez/.virtualenvs/aqueduct-dev/bin/python'
})

table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'conductor debugger',
  program = '${file}',
  python = '/Users/aaron.gonzalez/.virtualenvs/conductor-dev/bin/python'
})
