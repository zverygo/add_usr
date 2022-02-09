

Add-Type -assembly System.Windows.Forms

$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Add User to AD'
$main_form.Width = 600
$main_form.Height = 400
$main_form.AutoSize = $true

#---------------------------------------------------

$LabelName = New-Object System.Windows.Forms.Label
$LabelName.Text = "Name"
$LabelName.Location  = New-Object System.Drawing.Point(10,10)
$LabelName.AutoSize = $true
$main_form.Controls.Add($LabelName)

$LabelSurname = New-Object System.Windows.Forms.Label
$LabelSurname.Text = "Surname"
$LabelSurname.Location  = New-Object System.Drawing.Point(10,30)
$LabelSurname.AutoSize = $true
$main_form.Controls.Add($LabelSurname)

$LabelMobilePhone = New-Object System.Windows.Forms.Label
$LabelMobilePhone.Text = "MobilePhone"
$LabelMobilePhone.Location  = New-Object System.Drawing.Point(10,50)
$LabelMobilePhone.AutoSize = $true
$main_form.Controls.Add($LabelMobilePhone)

$LabelPassword = New-Object System.Windows.Forms.Label
$LabelPassword.Text = "Password"
$LabelPassword.Location  = New-Object System.Drawing.Point(10,70)
$LabelPassword.AutoSize = $true
$main_form.Controls.Add($LabelPassword)

$LabelChangePW = New-Object System.Windows.Forms.Label
$LabelChangePW.Text = "Need change password after first logon"
$LabelChangePW.Location  = New-Object System.Drawing.Point(10,90)
$LabelChangePW.AutoSize = $true
$main_form.Controls.Add($LabelChangePW)

$LabelGroup = New-Object System.Windows.Forms.Label
$LabelGroup.Text = "Add to group"
$LabelGroup.Location  = New-Object System.Drawing.Point(10,110)
$LabelGroup.AutoSize = $true
$main_form.Controls.Add($LabelGroup)

$LabelLocation = New-Object System.Windows.Forms.Label
$LabelLocation.Text = "Location"
$LabelLocation.Location  = New-Object System.Drawing.Point(10,130)
$LabelLocation.AutoSize = $true
$main_form.Controls.Add($LabelLocation)

#---------------------------------------------------

$FirstName = New-Object System.Windows.Forms.TextBox
$FirstName.Location = New-Object System.Drawing.Size(140,10)
$FirstName.Size = New-Object System.Drawing.Size(120,23)
$main_form.Controls.Add($FirstName)

$Surname = New-Object System.Windows.Forms.TextBox
$Surname.Location = New-Object System.Drawing.Size(140,30)
$Surname.Size = New-Object System.Drawing.Size(120,23)
$main_form.Controls.Add($Surname)

$MobilePhone = New-Object System.Windows.Forms.TextBox
$MobilePhone.Location = New-Object System.Drawing.Size(140,50)
$MobilePhone.Size = New-Object System.Drawing.Size(120,23)
$main_form.Controls.Add($MobilePhone)

$Password = New-Object System.Windows.Forms.MaskedTextBox
$password.PasswordChar = '*'
$Password.Location = New-Object System.Drawing.Size(140,70)
$Password.Size = New-Object System.Drawing.Size(120,23)
$main_form.Controls.Add($Password)

#---------------------------------------------------

$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(400,10)
$Button.Size = New-Object System.Drawing.Size(120,23)
$Button.Text = "AddUser"
$main_form.Controls.Add($Button)

#----------------------------------------------------

$CheckBoxChangePW = New-Object System.Windows.Forms.CheckBox
$CheckBoxChangePW.Location = New-Object System.Drawing.Size(400,90)
$CheckBoxChangePW.Size = New-Object System.Drawing.Size(15,15)
$CheckBoxChangePW.Checked = $true
$main_form.Controls.Add($CheckBoxChangePW)


$ButtonClose = New-Object System.Windows.Forms.Button
$ButtonClose.Location = New-Object System.Drawing.Size(400,40)
$ButtonClose.Size = New-Object System.Drawing.Size(120,23)
$ButtonClose.Text = "Close"
$main_form.Controls.Add($ButtonClose)

$ButtonClose.Add_Click(
{
	$main_form.Close()
}
)

#-----------------------------------------------------

$ComboBox = New-Object System.Windows.Forms.ComboBox
$ComboBox.Width = 200
$groups = Get-ADGroup -SearchBase "OU=Groups,OU=Kiev_Volmi1,DC=volmigames,DC=local" -filter * -Properties SamAccountName
Foreach ($group in $groups)
{
	$ComboBox.Items.Add($group.SamAccountName);
}
$ComboBox.Location  = New-Object System.Drawing.Point(140,110)
$main_form.Controls.Add($ComboBox)

#-----------------------------------------------------

$ComboBoxLocation = New-Object System.Windows.Forms.ComboBox
$ComboBoxLocation.Width = 200
$ComboBoxLocation.DataSource = @('Home','Office')
$ComboBoxLocation.Location  = New-Object System.Drawing.Point(140,130)
$main_form.Controls.Add($ComboBoxLocation)

<#
$ButtonClose = New-Object System.Windows.Forms.Button
$ButtonClose.Location = New-Object System.Drawing.Size(400,70)
$ButtonClose.Size = New-Object System.Drawing.Size(120,23)
$ButtonClose.Text = "Test"
$main_form.Controls.Add($ButtonClose)


$ButtonClose.Add_Click(
{
	if ($ComboBox.Text -eq "2D")
	{
		Write-Host "stepan"
	}
	if ($ComboBox.Text -eq "3D")
	{
		Write-Host "nazar"
	}
}
)
#>

$Button.Add_Click(

{
	$FirstName = $FirstName.Text
	$Surname = $Surname.Text
	$MobilePhone = $MobilePhone.Text

	$Name = $FirstName + ' ' + $Surname
	$login = $name.Chars(0) + '.' + $Surname
	$email = $login + "@volmigames.com"
	$securePass = ConvertTo-SecureString $Password.Text -AsPlainText -Force

#NO TABS!!!
	New-ADUser `
	-Name $Name `
	-DisplayName $Name `
	-GivenName $FirstName `
	-Surname $Surname `
	-SamAccountName $login.ToLower() `
	-UserPrincipalName $email `
	-Path "OU=Kiev_USERs,OU=Kiev_Volmi1,DC=volmigames,DC=local" `
	-AccountPassword $securePass `
	-Enabled $true `
	-MobilePhone $MobilePhone `
	-OfficePhone $MobilePhone `
	-EmailAddress $email.ToLower() `
	-ChangePasswordAtLogon $CheckBox.Checked

	Add-ADGroupMember `
	-Identity $ComboBox.Text `
	-Members $login
	
	if ($ComboBoxLocation.Text -eq "Office")
	{
	Add-ADGroupMember `
	-Identity "WiFi" `
	-Members $login
	}
}

)

#----------------------------------------------------

$main_form.ShowDialog()

