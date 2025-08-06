-- markdown_image_clean.nvim 配置模块
local M = {}

-- 默认配置选项
M.defaults = {
  -- 默认图片目录
  default_image_dir = 'imgs',
  
  -- 是否显示详细信息
  verbose = true,
  
  -- 支持的图片文件扩展名
  image_extensions = { 'png', 'jpg', 'jpeg', 'gif', 'svg', 'webp', 'bmp', 'tiff' },
  
  -- 是否在删除前确认
  confirm_delete = true,
  
  -- 键映射配置
  keymaps = {
    -- 分析图片引用
    analyze = '<leader>mia',
    -- 清理未引用的图片
    clean = '<leader>mic',
  },
  
  -- 是否启用默认键映射
  enable_default_keymaps = true,
  
  -- 删除文件时是否显示进度
  show_progress = true,
  
  -- 是否在分析后自动显示结果窗口
  auto_show_results = true,
}

-- 当前配置
M.options = nil  -- 先设为 nil

-- 初始化配置
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.defaults, opts or {})
  
  -- 设置默认键映射
  if M.options.enable_default_keymaps then
    M.setup_keymaps()
  end
end

-- 设置键映射
function M.setup_keymaps()
  local opts = { noremap = true, silent = true }
  
  if M.options.keymaps.analyze then
    vim.keymap.set('n', M.options.keymaps.analyze, function()
      require('markdown_image_clean').analyze_images()
    end, vim.tbl_extend('force', opts, { desc = '分析 Markdown 图片引用' }))
  end
  
  if M.options.keymaps.clean then
    vim.keymap.set('n', M.options.keymaps.clean, function()
      require('markdown_image_clean').clean_images()
    end, vim.tbl_extend('force', opts, { desc = '清理未引用的图片' }))
  end
end

-- 获取配置
function M.get()
  -- 如果 setup 从未被调用，返回默认配置
  if M.options == nil then
    return M.defaults
  end
  return M.options
end

-- 分析图片引用情况
function M.analyze_images(image_dir)
  -- 调试信息
  print("=== 配置调试 ===")
  local cfg = config.get()
  print("config模块状态:", cfg and "存在" or "不存在")
  if cfg then
    print("cfg内容:", vim.inspect(cfg))
    print("default_image_dir:", cfg.default_image_dir)
  else
    print("配置获取失败!")
  end
  print("传入参数 image_dir:", image_dir)
  print("===============")
  
  image_dir = image_dir or (cfg and cfg.default_image_dir) or 'imgs'  -- 添加兜底值
  print("最终使用的 image_dir:", image_dir)
end

return M
