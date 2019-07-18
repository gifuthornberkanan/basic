function Template-CSV () {
    param(
        [switch]$Prompt,

        [string]$InputFile,

        [string]$OutputFile,

        [string]$AddColumn
    )
    
    $Path = "C:\Users\$ENV:USERNAME\Documents\WindowsPowerShell"
    if (!$InputFile) {
        $InputFile = "new.csv"
    }
    if (!$OutputFile) {
        $OutputFile = "out.csv"
    }
    if ($Prompt) {
        $csvpath = Read-Host -Prompt "Enter path to CSV file."
    }
    else {
        $csvfile = $(Get-ChildItem -Path $Path -Filter $InputFile -Recurse -Force)
        $csvpath = "$Path\$csvfile"
    }
    $csvobjin = Import-Csv -Path $csvpath
    
    ## The following line will add a column to the CSV.
    if ($AddColumn) {
        $csvobject = $csvobjin | Select-Object *,@{Name="$($AddColumn)";Expression={'setvalue'}}
    }

    ForEach ($row in $csvobject) {
        Write-Host $row.name
        $row.tree = "oak"
    }

    ## On the line below you can delete the different properties or change their order if you
    ## want your output to be different from your input.
    $csvobjout = $($csvobject | Select-Object -Property name, date, tree, place, favorite)
    ## If you don't want to mess with the columns then comment the line above and uncomment:
    #$csvobjout = $csvobject

    $outpath = ".\$OutputFile"
    $csvobjout | Export-Csv -Path $outpath -Force -NoTypeInformation# -Append
    Write-Host "The CSV has been imported, modified, and exported."
}