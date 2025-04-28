return {
    "nvimdev/dashboard-nvim",
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()

        local db = require('dashboard')

        db.setup({
            theme = 'doom',
            config = {
                header = {
                    "                                            ",
                    "                                            ",
                    "                                            ",
                    "                                            ",
                    "  ▓▓▓▓▓    ▓▓▓▓▓                            ",
                    "  ▓▓▓▓▓▓   ▓▓▓▓                             ",
                    "   ▓▓▓▓▓▓  ▓▓▓                              ",
                    "   ▓▓▓▓▓▓▓ ▓▓▓   ▓▓▓▓▓  ▓▓▓▓  ▓▓▓▓▓ ▓▓▓▓▓▓  ",
                    "   ▓▓▓ ▓▓▓▓▓▓▓  ▓▓     ▓▓  ▓▓ ▓▓  ▓▓ ▓▓     ",
                    "   ▓▓▓  ▓▓▓▓▓▓  ▓▓     ▓▓  ▓▓ ▓▓  ▓▓ ▓▓▓▓▓  ",
                    "   ▓▓▓   ▓▓▓▓▓  ▓▓     ▓▓  ▓▓ ▓▓  ▓▓ ▓▓     ",
                    "  ▓▓▓▓    ▓▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓  ▓▓▓▓▓ ▓▓▓▓▓▓  ",
                    " ▓▓▓▓▓     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ",
                    "                                            ",
                    "           ▓▓▓▓▓▓▓▓▓▓▓                      ",
                    "                                            ",
                    "                                            ",
                    "                                            ",
                    "                                            ",
                },
                center = {
                    {
                        icon = '  ',
                        icon_hl = 'Title',
                        desc = 'New File',
                        desc_hl = 'String',
                        key = 'n',
                        key_hl = 'Number',
                        key_format = ' %s',
                        action = 'enew',
                    },
                    {
                        icon = '  ',
                        desc = 'Find file',
                        key = 'p',
                        key_hl = 'Number',
                        key_format = ' %s',
                        action = 'Telescope find_files',
                    },
                    {
                        icon = '  ',
                        desc = 'Recent files',
                        key = 'f',
                        key_hl = 'Number',
                        key_format = ' %s',
                        action = 'Telescope oldfiles',
                    },
                },
                footer = {
                    "                                         ",
                    "                                         ",
                    "                                         ",
                    "                                         ",
                    "                                         ",
                    "                                         ",
                    "                                         ",
                    "                                         ",
                    "..Your new best code editor! by tocodando.."
                },
            }
        })

        -- Apply custom highlights
        vim.cmd("highlight DashboardHeader guifg=#46c27e")
        vim.cmd("highlight DashboardFooter guifg=#3f6196")
    end
}

