-- LuaSnip snippets with Liquid/Shopify, React, PHP, and Node.js collections
return {
  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    version = "2.*",
    build = "make install_jsregexp",
    dependencies = {
      -- Snippet collections
      "rafamadriz/friendly-snippets",
    },
    opts = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
    },
    config = function(_, opts)
      require("luasnip").setup(opts)
    end,
  },

  -- Connect LuaSnip to nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, { name = "luasnip" })
    end,
  },

  -- Custom Liquid/Shopify snippets
  {
    "L3MON4D3/LuaSnip",
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local c = ls.choice_node
      local d = ls.dynamic_node
      local fmt = require("luasnip.extras.fmt").fmt
      local rep = require("luasnip.extras").rep

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Shopify Liquid snippets
      ls.add_snippets("liquid", {
        -- Section scaffold
        s("section", fmt([[
          {{% section "{}" %}}
          {}
          {{% endsection %}}
        ]], {
          i(1, "section-name"),
          i(0),
        })),

        -- Render tag
        s("render", fmt('{{% render "{}" {} %}}', {
          i(1, "snippet-name"),
          i(0),
        })),

        -- Render with alias
        s("renderas", fmt('{{% render "{}" as {} %}}', {
          i(1, "snippet-name"),
          i(2, "alias"),
        })),

        -- If statement
        s("if", fmt([[
          {{% if {} %}}
            {}
          {{% endif %}}
        ]], {
          i(1, "condition"),
          i(0),
        })),

        -- If/else
        s("ife", fmt([[
          {{% if {} %}}
            {}
          {{% else %}}
            {}
          {{% endif %}}
        ]], {
          i(1, "condition"),
          i(2),
          i(0),
        })),

        -- Unless
        s("unless", fmt([[
          {{% unless {} %}}
            {}
          {{% endunless %}}
        ]], {
          i(1, "condition"),
          i(0),
        })),

        -- For loop
        s("for", fmt([[
          {{% for {} in {} %}}
            {}
          {{% endfor %}}
        ]], {
          i(1, "item"),
          i(2, "collection"),
          i(0),
        })),

        -- For loop with limit
        s("forlimit", fmt([[
          {{% for {} in {} limit: {} %}}
            {}
          {{% endfor %}}
        ]], {
          i(1, "item"),
          i(2, "collection"),
          i(3, "5"),
          i(0),
        })),

        -- Tablerow
        s("tablerow", fmt([[
          {{% tablerow {} in {} %}}
            {}
          {{% endtablerow %}}
        ]], {
          i(1, "item"),
          i(2, "collection"),
          i(0),
        })),

        -- Case/when
        s("case", fmt([[
          {{% case {} %}}
            {{% when {} %}}
              {}
            {{% when {} %}}
              {}
            {{% else %}}
              {}
          {{% endcase %}}
        ]], {
          i(1, "variable"),
          i(2, "value1"),
          i(3),
          i(4, "value2"),
          i(5),
          i(0),
        })),

        -- Capture
        s("capture", fmt([[
          {{% capture {} %}}
            {}
          {{% endcapture %}}
        ]], {
          i(1, "variable"),
          i(0),
        })),

        -- Assign
        s("assign", fmt('{{% assign {} = {} %}}', {
          i(1, "variable"),
          i(0),
        })),

        -- Increment
        s("increment", fmt('{{% increment {} %}}', {
          i(1, "variable"),
        })),

        -- Decrement
        s("decrement", fmt('{{% decrement {} %}}', {
          i(1, "variable"),
        })),

        -- Comment
        s("comment", fmt([[
          {{% comment %}}
            {}
          {{% endcomment %}}
        ]], {
          i(0),
        })),

        -- Raw
        s("raw", fmt([[
          {{% raw %}}
            {}
          {{% endraw %}}
        ]], {
          i(0),
        })),

        -- Liquid output
        s("out", fmt("{{{{ {} }}}}", {
          i(0),
        })),

        -- Liquid output with filter
        s("outf", fmt("{{{{ {} | {} }}}}", {
          i(1),
          i(0),
        })),

        -- Schema block
        s("schema", fmt([[
          {{% schema %}}
          {{
            "name": "{}",
            "settings": [
              {{
                "type": "text",
                "id": "{}",
                "label": "{}",
                "default": "{}"
              }}
            ]
          }}
          {{% endschema %}}
        ]], {
          i(1, "Section Name"),
          i(2, "setting_id"),
          i(3, "Setting Label"),
          i(0, "Default value"),
        })),

        -- Stylesheet tag
        s("stylesheet", fmt('{{{{ "{}" | asset_url | stylesheet_tag }}}}', {
          i(1, "filename.css"),
        })),

        -- Script tag
        s("scripttag", fmt('{{{{ "{}" | asset_url | script_tag }}}}', {
          i(1, "filename.js"),
        })),

        -- Image URL
        s("img", fmt('{{{{ "{}" | img_url: "{}" }}}}', {
          i(1, "image"),
          i(2, "master"),
        })),

        -- Image tag
        s("imgtag", fmt('{{{{ "{}" | img_url: "{}" | img_tag: "{}" }}}}', {
          i(1, "image"),
          i(2, "master"),
          i(3, "alt text"),
        })),

        -- Link
        s("link", fmt('<a href="{{{{ {} }}}}"{}> {} </a>', {
          i(1, "url"),
          i(2, ' class=""'),
          i(0, "text"),
        })),

        -- Form
        s("form", fmt([[
          {{% form "{}", {} %}}
            {}
          {{% endform %}}
        ]], {
          i(1, "type"),
          i(2, "object"),
          i(0),
        })),

        -- Pagination
        s("paginate", fmt([[
          {{% paginate {} by {} %}}
            {}
          {{% endpaginate %}}
        ]], {
          i(1, "collection"),
          i(2, "10"),
          i(0),
        })),
      })
    end,
  },
}
