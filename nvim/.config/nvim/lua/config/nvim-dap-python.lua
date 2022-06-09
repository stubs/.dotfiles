local dap_python = require('dap-python')
dap_python.test_runner = 'pytest'
dap_python.setup('~/.virtualenvs/debugpy/bin/python')

-- custom configs for venvs
table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'curator debugger',
  program = '${file}',
  python = '/Users/agonzalez/.virtualenvs/curator/bin/python'
})

table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'aqueduct debugger',
  program = '${file}',
  python = '/Users/agonzalez/.virtualenvs/aqueduct/bin/python'
})

table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'temp debugger',
  program = '${file}',
  python = '/Users/agonzalez/.virtualenvs/async_test_env/bin/python'
})
