Param(
  [string]$ProjectDir = "$PSScriptRoot\apresentacao",
  [string]$DocsDir = "$PSScriptRoot\docs"
)

$ErrorActionPreference = 'Stop'

$siteDir = Join-Path $ProjectDir '_site'

# Limpa outputs antigos no root docs (mantém index.html, que redireciona)
$toRemoveInDocs = @(
  (Join-Path $DocsDir 'apresentacao.html'),
  (Join-Path $DocsDir 'apresentacao_files'),
  (Join-Path $DocsDir 'assets'),
  (Join-Path $DocsDir 'Figuras')
)
foreach ($p in $toRemoveInDocs) {
  if (Test-Path $p) {
    Remove-Item -LiteralPath $p -Recurse -Force
  }
}

# Renderiza para apresentacao/_site
Push-Location $ProjectDir
try {
  quarto render 'apresentacao.qmd'
}
finally {
  Pop-Location
}

# Copia output atual para docs/
if (-not (Test-Path $DocsDir)) {
  New-Item -ItemType Directory -Path $DocsDir | Out-Null
}
Copy-Item -Path (Join-Path $siteDir '*') -Destination $DocsDir -Recurse -Force

# Remove build local (opcional, mantém repo limpo)
if (Test-Path $siteDir) {
  Remove-Item -LiteralPath $siteDir -Recurse -Force
}

Write-Host "OK: docs atualizado a partir de $siteDir" -ForegroundColor Green
