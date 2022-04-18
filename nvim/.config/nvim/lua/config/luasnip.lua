local ls = require("luasnip")
local types = require("luasnip.util.types")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.config.set_config({
    history = true,
    -- Update more often, :h events for more info.
    updateevents = "TextChanged,TextChangedI",
    -- Snippets aren't automatically removed if their text is deleted.
    -- `delete_check_events` determines on which events (:h events) a check for
    -- deleted snippets is performed.
    -- This can be especially useful when `history` is enabled.
    enable_autosnippets = true,
    delete_check_events = "TextChanged",
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "●", "TSException" } },
            },
        },
        [types.insertNode] = {
            active = {
                virt_text = { { "●", "DapUIModifiedValue" } },
            },
        },
    },
})

ls.add_snippets("json", {
    s('dd_table_def',
        fmt(
          [[
            {{
              "tableReference": {{
                "projectId": "about-dss-01",
                "datasetId": "{}",
                "tableId": "{}"
              }},
              "externalDataConfiguration": {{
                "autodetect": false,
                "schema": {{
                  "fields": [
                    {}
                  ]
                }},
                "sourceUris": [
                  "gs://{}/*"
                ],
                "hivePartitioningOptions": {{
                  "mode": "CUSTOM",
                  "sourceUriPrefix": "gs://{}/{{application:STRING}}/{{dt:DATE}}/{{perspective:STRING}}/",
                  "requirePartitionFilter": true
                }},
                "sourceFormat": "{}",
                "compression": "GZIP",
                "ignoreUnknownValues": true
              }}
            }}
          ]],
          {
            i(1),
            i(2),
            c(3, {
                    sn(1, { t('{"mode": "'), i(1, "NULLABLE"), t('", "name": "'), i(2), t('", "type": "STRING"}') }),
                    t('{"mode": "{}", "name": "{}", "type": "INT64"}'),
                    t('{"fields": [], "mode": "{}", "name": "{}", "type": "RECORD"}'),
                 }
            ),
            i(4),
            rep(4),
            c(5, { t('NEWLINE_DELIMITED_JSON'), t('GOOGLE_SHEETS'), t('CSV') })
          }
        )
    )
})


ls.add_snippets("python", {
    s(
        "dd_py_sub_class",
        fmt(
            [[
              class {}({}):

                  perspectives = ['1d']

                  def __init__(self, application, dt, perspective, source='{}'):
                      super({}, self).__init__(
                          application=application, dt=dt, perspective=perspective, source=source
                      )

                  def filename(self):
                      # TODO
                      pass

                  def table(self):
                      # TODO
                      pass
            ]],
            {
                i(1),
                i(2, 'DownloadedLakeIntegration'),
                i(3),
                rep(1),
            }
        )
    )
})

require("luasnip/loaders/from_vscode").lazy_load()
