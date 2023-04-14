Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "Uninstall UWP Apps and Features"
$form.Size = New-Object System.Drawing.Size(510, 330)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(20, 20)
$label.Size = New-Object System.Drawing.Size(460, 60)
$label.Text = "Select the UWP app or feature you want to uninstall, or click the 'Uninstall All' button to uninstall all UWP apps and features."
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.CheckedListBox
$listBox.Location = New-Object System.Drawing.Point(20, 80)
$listBox.Size = New-Object System.Drawing.Size(460, 150)
$form.Controls.Add($listBox)

$packages = Get-AppxPackage -AllUsers
foreach ($package in $packages) {
    [void] $listBox.Items.Add($package.Name)
}

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(20, 240)
$button.Size = New-Object System.Drawing.Size(150, 30)
$button.Text = "Uninstall Selected"
$button.Add_Click({
    $selectedItems = $listBox.CheckedItems
    if ($selectedItems) {
        foreach ($selectedItem in $selectedItems) {
            $result = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to uninstall $selectedItem?", "Confirm Uninstall", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
            if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                Write-Host "Uninstalling $selectedItem..."
                Get-AppxPackage $selectedItem -AllUsers | Remove-AppxPackage -AllUsers
                [void] $listBox.Items.Remove($selectedItem)
                Write-Host "$selectedItem has been uninstalled."
            }
        }
    }
})
$form.Controls.Add($button)

$buttonAll = New-Object System.Windows.Forms.Button
$buttonAll.Location = New-Object System.Drawing.Point(330, 240)
$buttonAll.Size = New-Object System.Drawing.Size(150, 30)
$buttonAll.Text = "Uninstall All"
$buttonAll.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to uninstall all UWP apps and features?", "Confirm Uninstall", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Write-Host "Uninstalling all UWP apps and features..."
        Get-AppxPackage -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
        $listBox.Items.Clear()
        Write-Host "All UWP apps and features have been uninstalled."
    }
})
$form.Controls.Add($buttonAll)

$form.ShowDialog() | Out-Null

