# Excelファイル1とファイル2のパスを設定
$excelFile1Path = "C:\Users\root\Downloads\test1.xlsx"
$excelFile2Path = "C:\Users\root\Downloads\test2.xlsx"
$newExcelFile2Path = $excelFile2Path.Substring(0, $excelFile2Path.Length - 5) + "_processed.xlsx"

# Excelアプリケーションを起動して、ファイル1とファイル2を開く
$excel = New-Object -ComObject Excel.Application
$workbook1 = $excel.Workbooks.Open($excelFile1Path)
$workbook2 = $excel.Workbooks.Open($excelFile2Path)

# ワークシートの最初のシートを選択
$worksheet1 = $workbook1.Worksheets.Item(1)
$worksheet2 = $workbook2.Worksheets.Item(1)

# ファイル1の6行目以下の「D列:Command」、「F列:Id」、「H列:Compliance Id」、「N列:Namespace」のデータを取得
$file1Data = @{}
$excelFile1RowMax = $worksheet1.UsedRange.Item($worksheet1.UsedRange.Count).Row
#Write-Host "[DEBUG] Excel1 rows:$excelFile1RowMax"
for ($row = 6; $row -le $excelFile1RowMax; $row++) {
  $command = $worksheet1.Cells.Item($row, 4).Value2
  $id = $worksheet1.Cells.Item($row, 6).Value2
  $image = $worksheet1.Cells.Item($row, 7).Value2
  $compId = $worksheet1.Cells.Item($row, 8).Value2
  $namespace = $worksheet1.Cells.Item($row, 14).Value2
  
  $file1Data["$command-$id-$image-$compId-$namespace"] = $true
  #Write-Host ("[DEBUG]" + [string]$row + ": $command-$id-$image-$compId-$namespace")
}

# ファイル2の6行目以下を検索して、一致する行の「Q列：静観対応」にsuppressedを記載
$excelFile2RowMax = $worksheet2.UsedRange.Item($worksheet2.UsedRange.Count).Row
#Write-Host "[DEBUG] Excel2 rows:$excelFile2RowMax"
for ($row = 6; $row -le $excelFile2RowMax; $row++) {
  $command = $worksheet2.Cells.Item($row, 4).Value2
  $id = $worksheet2.Cells.Item($row, 6).Value2
  $image = $worksheet2.Cells.Item($row, 7).Value2
  $compId = $worksheet2.Cells.Item($row, 8).Value2
  $namespace = $worksheet2.Cells.Item($row, 14).Value2
  
  $key = "$command-$id-$image-$compId-$namespace"
  #Write-Host ("[DEBUG]" + [string]$row + ": $command-$id-$image-$compId-$namespace")
  
  if ($file1Data.ContainsKey($key)) {
    #$worksheet2.Rows.Item($row).Delete()
    $worksheet2.Cells.Item($row, 17).Value2 = "suppressed"
  }
}

# ファイル2を別名で保存して閉じる
$workbook2.SaveAs($newExcelFile2Path)
$workbook2.Close()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($worksheet2) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook2) | Out-Null

# ファイル1とExcelアプリケーションを閉じる
$workbook1.Close()
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($worksheet1) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook1) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
