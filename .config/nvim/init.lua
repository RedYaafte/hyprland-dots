-- CONFIGURACIÓN ULTRA MINIMALISTA
vim.opt.number = true        -- Números de línea
vim.opt.cursorline = true    -- Resaltar línea actual
vim.opt.ruler = true         -- Mostrar línea:columna abajo
vim.opt.colorcolumn = "80,120"  -- Guías de columna

-- Configuración cuando se abre un archivo Markdown
vim.api.nvim_create_autocmd('FileType', {
  group = markdown_group,
  pattern = { 'markdown', 'md', 'mkd', 'mkdn', 'mdwn' },
  callback = function()
    -- Configuraciones básicas de Vim
    vim.opt_local.wrap = true           -- Ajuste de línea
    vim.opt_local.linebreak = true      -- Romper en palabras completas
    vim.opt_local.spell = true          -- Corrector ortográfico
    vim.opt_local.spelllang = 'es,en'   -- Idiomas del corrector
    vim.opt_local.textwidth = 80        -- Ancho máximo de texto
    vim.opt_local.colorcolumn = '72'    -- Guía para commit messages
    
    -- Sangría automática
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
    
    -- Configurar formato de párrafos
    vim.opt_local.formatoptions = vim.opt_local.formatoptions
      + 't'  -- Auto-wrap usando textwidth
      + 'c'  -- Auto-wrap comentarios
      + 'q'  -- Permitir formato con 'gq'
      + 'r'  -- Insertar comentarios después de <Enter>
      + 'n'  -- Reconocer listas numeradas
      + 'j'  -- Eliminar comentarios al unir líneas
  end
})


-- ====================
-- MEJORES COLORES
-- ====================
-- Color del número de línea actual
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#FFD700', bold = true })

-- Color de las guías de columna
vim.api.nvim_set_hl(0, 'ColorColumn', {
  bg = '#1e1e2e'     -- Color oscuro
})

-- ====================
-- BARRA DE ESTADO PERSONALIZADA
-- ====================
-- Configuración minimalista de statusline (sin plugins)
vim.opt.statusline = ""
  .. "%f"               -- Nombre del archivo
  .. " %m"              -- Modificado [+]
  .. " %r"              -- Solo lectura [RO]
  .. "%="               -- Separador (empuja todo a la derecha)
  .. "%y"               -- Tipo de archivo
  .. " %l:%c"           -- Línea:Columna
  .. " [%L]"            -- Total de líneas
  .. " %P"              -- Porcentaje en el archivo

