#############################################
#                                           #
#        Script by Artem Veber, 2022        #
#                                           # 
#############################################


function add-new-user {

    echo "Введите имя пользователя: "
    $user_name = Read-Host #Считать имя пользователя

    echo "Введите пароль: "
    $password = Read-Host -AsSecureString #Считать пароль в безопасном виде

    echo "Введите описание пользователя(оставить пустым если не требуется): "
    $desc = Read-Host

    echo "Введите полное имя пользователя(оставить пустым если не требуется): "
    $full_name = Read-Host

    echo "Добавить пользователя в группу Администраторы?: (да/нет)"
    $user_group = Read-Host

    echo "Требовать смены пароля через время?: (да/нет)"
    $pass_change = Read-Host
    
    echo "Запретить пользователю менять пароль?: (да/нет)"
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

    if ( $user_may_change_password = 'да' )
    {
        Set-LocalUser -Name $user_name -UserMayChangePassword 0
    }
    elseif ( $user_may_change_password = 'нет')
    {
        Set-LocalUser -Name $user_name -UserMayChangePassword 1
    }
    else
    {
        Write-Warning "Неизвестный ответ. Выставлено значение по умолчанию."
    }

    pause

    echo ""
}

function enable-default-admin {
    
    Enable-LocalUser "Администратор"
            echo "Пользователь Администратор включен"
    pause
    
    echo ""
}

function change-password 
{
    

    echo "Введите имя учетной записи у которой нужно изменить пароль:"
    $user_name = Read-Host

    $message = "Введите новый пароль для пользователя "+ $user_name + ":"
    
    echo $message
    $new_pass = Read-Host -AsSecureString

    Set-LocalUser -Name $user_name -Password $new_pass 

    pause

    echo ""    
}

function dns-loopback {
 Get-DnsClient
    
    echo "Введите индекс сетевого адаптера:"
    $index_net_adapter = Read-Host

    Set-DnsClientServerAddress -InterfaceIndex $index_net_adapter -ServerAddresses 127.0.0.1
}


$infinity = 0
while ( $infinity -eq 0)
{

echo "1 Создать нового пользователя"
echo "2 Включить встроенную учетную запись администратора"
echo "3 Задать пароль для учетной записи"
echo "4 Вывести список всех пользователей"
echo "5 Выключить интернерт на ПК"
echo "0 Выход"
echo "Выберите пункт: "

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
    change-password
}


if ( $user_choice -eq 4)
{
    
    return Get-LocalUser | select Name
    echo ""
    
}   

if ( $user_choice -eq 5 )
{
   
   dns-loopback

} 

if ( $user_choice -eq 0 )
{
    echo "До свидания!"
    $infinity++
}



}

