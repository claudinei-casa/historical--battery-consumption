#!/bin/bash

diretorio_atual=$(pwd)

read -p "Verique se o modo debug usb está ativo e precione qualquer tecla para continuar..."
adb kill-server

adb devices

adb shell dumpsys batterystats --reset
echo ""
read -p "Desconecte seu dispositivo, realize os testes que desejar e após reconectar aperte qualquer tecla para continuar"

adb devices

echo " "
read -p "Se seu dispositivo estiver na lista acima aperte qualquer tecla caso contrario pressione Crtl + C..."
echo " "

echo "Seus arquivos estão sendo gerados..."
adb shell dumpsys batterystats >batterystats.txt
adb bugreport >bugreport.zip

existe_diretorio=$(ls -l bugreport* | wc -l)

if [ $existe_diretorio -ne 0 ]; then
    name_folder=$(ls bugreport-* | cut -d'-' -f2,3,4,5,6,7,8)
else
    echo "ERRO bugreport.zip não encontrado."
    exit
fi

if [ -d "./$name_folder" ]; then

    echo "diretorio já existe!"

else
    echo "criando pasta..."
    mkdir $name_folder
    echo "movendo arquivos..."
    mv bugreport* ./$name_folder
    mv batterystats.txt ./$name_folder
fi
echo ""
echo "Pronto!!! seu arquivo está em $diretorio_atual"
start https://bathist.ef.lc/

exit
