local ls = require("luasnip")
local types = require("luasnip.util.types")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras.fmt").rep
local ai = require("luasnip.nodes.absolute_indexer")

ls.config.set_config({
    history = true,
    -- Update more often, :h events for more info.
    updateevents = "TextChanged,TextChangedI",
    -- Snippets aren't automatically removed if their text is deleted.
    -- `delete_check_events` determines on which events (:h events) a check for
    -- deleted snippets is performed.
    -- This can be especially useful when `history` is enabled.
    delete_check_events = "TextChanged",
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "●", "GruvboxOrange" } },
            },
        },
        [types.insertNode] = {
            active = {
                virt_text = { { "●", "GruvboxBlue" } },
            },
        },
    },
})

ls.snippets = {
    all = {
        s("trig", c(1, {
            t("Ugh boring, a text node"),
            i(nil, "At least I can edit something now..."),
            f(function(args) return "Still only counts as text!!" end, {})
        })),
        s(
            'table_def',
            fmt(
                [[
                {{
                    "tableReference": {{
                    "projectId": "{}",
                    "datasetId": "{}",
                    "tableId": "{}"
                    }},
                    "externalDataConfiguration": {{
                    "autodetect": false,
                    "schema": {{
                        "fields": []
                    }},
                    "sourceUris": ["{}"],
                    {}
                    }}
                }}
                ]],
                {
                i(1),
                i(2),
                i(3),
                i(4, 'sheets'),
                d(5, function(args)
                    if string.match(args[1][1], 'sheets') then
                        return sn(nil,
                                    fmt([[
                                        "googleSheetsOptions": {{
                                        "skipLeadingRows": "1",
                                        "range": "{}"
                                        }}
                                        ]], { i(1) }
                                    )
                        )
                    else
                        return sn(nil,
                                    fmt([[
                                        "hivePartitioningOptions": {{
                                        "mode": "CUSTOM",
                                        "sourceUriPrefix": "gs://dotdash-dataops-data-pr/raw/{}/{}/{{dt:DATE}}/{{perspective:STRING}}/",
                                        "requirePartitionFilter": true
                                        }}
                                        ]], { rep(ai[2]) , rep(ai[3]) }
                                    )
                        )
                    end
                    end,
                    {4,2,3}
                )
                }
            )
        )
    },
    json = {
        ls.parser.parse_snippet(
            'gs_table_def',
            [[
{
"tableReference": {
"projectId": "$1",
"datasetId": "$2",
"tableId": "$3"
},
"externalDataConfiguration": {
"autodetect": false,
"schema": {
"fields": [
{ "name": "year", "type": "STRING" },
{ "name": "month", "type": "STRING" },
{ "name": "reach", "type": "STRING" }
]
},
"sourceUris": [
"https://docs.google.com/spreadsheets/d/$4/"
],
"googleSheetsOptions": {
"skipLeadingRows": "1",
"range": "$5"
},
"sourceFormat": "GOOGLE_SHEETS",
"ignoreUnknownValues": true
}
}
]]
        )
    }
}

require("luasnip/loaders/from_vscode").lazy_load()
