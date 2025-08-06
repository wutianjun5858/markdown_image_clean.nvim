-- markdown_image_clean.nvim
-- Neovim 插件：清理 Markdown 文件中未引用的图片

if vim.g.loaded_markdown_image_clean then
  return
end
vim.g.loaded_markdown_image_clean = 1

-- 创建用户命令
vim.api.nvim_create_user_command('MarkdownImageClean', function(opts)
  local dir = opts.args and opts.args ~= "" and opts.args or nil
  require('markdown_image_clean').clean_images(dir)
end, {
  nargs = '?',
  desc = '清理 Markdown 文件中未引用的图片',
  complete = 'dir'
})

vim.api.nvim_create_user_command('MarkdownImageAnalyze', function(opts)
  local dir = opts.args and opts.args ~= "" and opts.args or nil
  require('markdown_image_clean').analyze_images(dir)
end, {
  nargs = '?',
  desc = '分析 Markdown 文件中的图片引用情况',
  complete = 'dir'
})
