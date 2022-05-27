#############################################
#                                           #
#        Script by Artem Veber, 2022        #
#                                           # 
#############################################


function add-new-user {

    Write-Output "Введите имя пользователя: "
    $user_name = Read-Host #Считать имя пользователя

    Write-Output "Введите пароль: "
    $password = Read-Host -AsSecureString #Считать пароль в безопасном виде

    Write-Output "Введите описание пользователя(оставить пустым если не требуется): "
    $desc = Read-Host

    Write-Output "Введите полное имя пользователя(оставить пустым если не требуется): "
    $full_name = Read-Host

    Write-Output "Добавить пользователя в группу Администраторы?: (да/нет)"
    $user_group = Read-Host

    Write-Output "Требовать смены пароля через время?: (да/нет)"
    $pass_change = Read-Host
    
    Write-Output "Запретить пользователю менять пароль?: (да/нет)"
    $user_may_change_password = Read-Host   

    New-LocalUser -Name $user_name -Password $password -Description $desc -FullName $full_name #создаём пользователя с именем $user_name и паролем $password

    if ( $user_group -eq 'да')
    {
        Add-LocalGroupMember -Group "Администраторы" -Member $user_name
    }
    elseif ($user_group-eq 'нет')
    {
        Add-LocalGroupMember -Group "Пользователи" -Member $user_name
    }
    else
    {
        Write-Warning "Неизвестный ответ. Пользователь не добавлен ни в какие группы"
    }

    if ($pass_change -eq 'да')
    {
       
        Set-LocalUser -Name $user_name -PasswordNeverExpires 0 
    }
    elseif ($pass_change -eq 'нет')
    {
        Set-LocalUser -Name $user_name -PasswordNeverExpires 1
    }
    else
    {
        Write-Warning "Неизвестный ответ. Выставлено значение по умолчанию."
    }

    if ( $user_may_change_password -eq 'да' )
    {
        Set-LocalUser -Name $user_name -UserMayChangePassword 0
    }
    elseif ( $user_may_change_password -eq 'нет')
    {
        Set-LocalUser -Name $user_name -UserMayChangePassword 1
    }
    else
    {
        Write-Warning "Неизвестный ответ. Выставлено значение по умолчанию."
    }

    pause

    Write-Output ""
}

function enable-default-admin {
    
    Enable-LocalUser "Администратор"
            Write-Output "Пользователь Администратор включен"
    pause
    
    Write-Output ""
}

function change_password 
{
    

    Write-Output "Введите имя учетной записи у которой нужно изменить пароль:"
    $user_name = Read-Host

    $message = "Введите новый пароль для пользователя "+ $user_name + ":"
    
    Write-Output $message
    $new_pass = Read-Host -AsSecureString

    Set-LocalUser -Name $user_name -Password $new_pass 

    pause

    Write-Output ""    
}

function dns_loopback {
 Get-DnsClient
    
    Write-Output "Введите индекс сетевого адаптера:"
    $index_net_adapter = Read-Host

    Set-DnsClientServerAddress -InterfaceIndex $index_net_adapter -ServerAddresses 127.0.0.1
}

function date_time()
{
    return (Get-Date -UFormat "%Y-%m-%d_%I-%M-%S").tostring()
}

function delete_files
{
    Write-Output "Введите путь откуда надо удалить файлы: "
    $path_for_delete = Read-Host



    Remove-Item $path_for_delete -Force -Recurse
}

$infinity = 0
while ( $infinity -eq 0)
{

Write-Output "1 Создать нового пользователя"
Write-Output "2 Включить встроенную учетную запись администратора"
Write-Output "3 Задать пароль для учетной записи"
Write-Output "4 Вывести список всех пользователей"
Write-Output "5 Выключить интернерт на ПК"
Write-Output "6 Удалить файлы из папки"
Write-Output "0 Выход"
Write-Output "Выберите пункт: "

$user_choice = Read-Host
if ($user_choice -eq 1)
{
    add-new-user
}

if ( $user_choice -eq 2 )
{
   enable-default-admin
}

if ( $user_choice -eq 3 )
{
    change_password
}


if ( $user_choice -eq 4)
{
    
    return Get-LocalUser | Select-Object Name
    Write-Output ""
    
}   

if ( $user_choice -eq 5 )
{
   
   dns_loopback

} 

if ( $user_choice -eq 6 )
{
   delete_files
}

if ( $user_choice -eq 0 )
{
    Write-Output "До свидания!"
    $infinity++
}



}

