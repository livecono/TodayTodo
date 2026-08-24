Add-Type -AssemblyName System.Drawing

$blueTop = [System.Drawing.Color]::FromArgb(104, 196, 235)
$blueBottom = [System.Drawing.Color]::FromArgb(174, 229, 247)
$white = [System.Drawing.Color]::White
$fontPath = 'C:\Windows\Fonts\malgun.ttf'

function New-IconPng([string]$path, [int]$size) {
  $bitmap = New-Object System.Drawing.Bitmap($size, $size)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $backgroundBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(0, 0)),
    (New-Object System.Drawing.Point(0, $size)),
    $blueTop,
    $blueBottom
  )
  $graphics.FillRectangle($backgroundBrush, 0, 0, $size, $size)

  $titleFont = New-Object System.Drawing.Font($fontPath, ($size * 0.16), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $title = ([char]0xC624) + ([char]0xB298) + ' ' + ([char]0xD560) + ' ' + ([char]0xC77C)
  $titleSize = $graphics.MeasureString($title, $titleFont)
  $titleX = ($size - $titleSize.Width) / 2
  $graphics.DrawString($title, $titleFont, (New-Object System.Drawing.SolidBrush($white)), $titleX, ($size * 0.2))

  $subtitleFont = New-Object System.Drawing.Font($fontPath, ($size * 0.065), [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $subtitle = ([char]0xD38C) + ([char]0xD2B8) + ' ' + ([char]0xD0A4) + ([char]0xC6B0) + ([char]0xAE30) + ' ' + ([char]0xC2A4) + ([char]0xC988) + ([char]0xCF00) + ([char]0xC904) + ([char]0xB7EC)
  $subtitleSize = $graphics.MeasureString($subtitle, $subtitleFont)
  $subtitleX = ($size - $subtitleSize.Width) / 2
  $graphics.DrawString($subtitle, $subtitleFont, (New-Object System.Drawing.SolidBrush($white)), $subtitleX, ($size * 0.68))

  $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $graphics.Dispose()
  $bitmap.Dispose()
}

function New-AppLogoPng([string]$path, [int]$size) {
  $bitmap = New-Object System.Drawing.Bitmap($size, $size)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

  $topLeft = [System.Drawing.Color]::FromArgb(89, 143, 194)
  $bottomRight = [System.Drawing.Color]::FromArgb(37, 174, 132)
  $topRight = [System.Drawing.Color]::FromArgb(24, 178, 126)
  $bottomLeft = [System.Drawing.Color]::FromArgb(123, 83, 238)
  for ($y = 0; $y -lt $size; $y++) {
    $verticalRatio = $y / [double]($size - 1)
    $left = [System.Drawing.Color]::FromArgb([int]($topLeft.R + (($bottomLeft.R - $topLeft.R) * $verticalRatio)), [int]($topLeft.G + (($bottomLeft.G - $topLeft.G) * $verticalRatio)), [int]($topLeft.B + (($bottomLeft.B - $topLeft.B) * $verticalRatio)))
    $right = [System.Drawing.Color]::FromArgb([int]($topRight.R + (($bottomRight.R - $topRight.R) * $verticalRatio)), [int]($topRight.G + (($bottomRight.G - $topRight.G) * $verticalRatio)), [int]($topRight.B + (($bottomRight.B - $topRight.B) * $verticalRatio)))
    $rowGradient = New-Object System.Drawing.Drawing2D.LinearGradientBrush((New-Object System.Drawing.Point(0, $y)), (New-Object System.Drawing.Point($size, $y)), $left, $right)
    $graphics.FillRectangle($rowGradient, 0, $y, $size, 1)
    $rowGradient.Dispose()
  }

  $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
  $titleFont = New-Object System.Drawing.Font($fontPath, ($size * 0.19), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $title = ([char]0xC624) + ([char]0xB298) + ' ' + ([char]0xD560) + ' ' + ([char]0xC77C)
  $titleSize = $graphics.MeasureString($title, $titleFont)
  $graphics.DrawString($title, $titleFont, $white, (($size - $titleSize.Width) / 2), ($size * 0.35))

  $subtitleFont = New-Object System.Drawing.Font($fontPath, ($size * 0.065), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $subtitle = ([char]0xD38E) + ' ' + ([char]0xD0A4) + ([char]0xC6B0) + ([char]0xAE30) + ' ' + ([char]0xC2A4) + ([char]0xCF00) + ([char]0xC904) + ([char]0xB7EC)
  $subtitleSize = $graphics.MeasureString($subtitle, $subtitleFont)
  $graphics.DrawString($subtitle, $subtitleFont, $white, (($size - $subtitleSize.Width) / 2), ($size * 0.62))

  $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $white.Dispose()
  $graphics.Dispose()
  $bitmap.Dispose()
}

$root = Join-Path $PSScriptRoot 'android\app\src\main\res'
New-AppLogoPng (Join-Path $root 'drawable\today_todo_icon_foreground.png') 432
foreach ($density in @('mdpi','hdpi','xhdpi','xxhdpi','xxxhdpi')) {
  $size = switch ($density) {
    'mdpi' { 48 }
    'hdpi' { 72 }
    'xhdpi' { 96 }
    'xxhdpi' { 144 }
    'xxxhdpi' { 192 }
  }
  New-AppLogoPng (Join-Path $root "mipmap-$density\ic_launcher.png") $size
  New-AppLogoPng (Join-Path $root "mipmap-$density\ic_launcher_round.png") $size
}
