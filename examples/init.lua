-- markdown_image_clean.nvim 配置示例

-- 基本配置
require('markdown_image_clean').setup()

-- 自定义配置示例 1: 博客项目配置
require('markdown_image_clean').setup({
  default_image_dir = 'static/images',  -- Hugo/Jekyll 风格的图片目录
  verbose = true,
  confirm_delete = true,
  image_extensions = { 'png', 'jpg', 'jpeg', 'gif', 'svg', 'webp' },
})

-- 自定义配置示例 2: 文档项目配置  
require('markdown_image_clean').setup({
  default_image_dir = 'assets',
  verbose = false,  -- 安静模式
  confirm_delete = false,  -- 自动删除 (谨慎使用)
  keymaps = {
    analyze = '<leader>doc_analyze',
    clean = '<leader>doc_clean',
  },
})

-- 自定义配置示例 3: 多格式支持
require('markdown_image_clean').setup({
  default_image_dir = 'media',
  image_extensions = { 
    'png', 'jpg', 'jpeg', 'gif', 'svg', 'webp', 
    'bmp', 'tiff', 'avif', 'heic'  -- 扩展支持
  },
  keymaps = {
    analyze = '<C-m>a',  -- Ctrl+M+A
    clean = '<C-m>c',    -- Ctrl+M+C  
  },
})

-- 禁用默认键映射的配置
require('markdown_image_clean').setup({
  enable_default_keymaps = false,  -- 禁用默认键映射
})

-- 然后自定义键映射
vim.keymap.set('n', '<leader>mda', function()
  require('markdown_image_clean').analyze_images()
end, { desc = 'Markdown: 分析图片引用' })

vim.keymap.set('n', '<leader>mdc', function()
  require('markdown_image_clean').clean_images()
end, { desc = 'Markdown: 清理未引用图片' })

-- 为特定项目创建专用命令
vim.api.nvim_create_user_command('BlogImageClean', function()
  require('markdown_image_clean').clean_images('static/images')
end, { desc = '清理博客图片' })

vim.api.nvim_create_user_command('DocsImageClean', function()
  require('markdown_image_clean').clean_images('docs/assets')
end, { desc = '清理文档图片' })
