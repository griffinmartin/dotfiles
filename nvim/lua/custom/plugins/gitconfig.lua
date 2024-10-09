return {
    -- Git blame plugin configuration
    {
        "f-person/git-blame.nvim",
        event = "VeryLazy",  -- Load the plugin lazily
        opts = {
            enabled = true,  -- Enable the plugin
            message_template = " <summary> • <date> • <author> • <<sha>>",
            date_format = "%m-%d-%Y %H:%M:%S",
            virtual_text_column = 1,
        },
    },
}