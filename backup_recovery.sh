#!/bin/bash

#Backup funktion
perform_backup() {
    read -p "Ange fil eller mapp-källa för backup: " source_dir
    read -p "Ange fil eller mapp-destination för backup: " target_dir

    # Kolla om fil eller mapp existerar
    if [ ! -d "$source_dir" ]; then
        echo "Källdestination existerar inte eller är felaktig. Korrigera din inmatning."
        exit 1
    fi


    #Backa upp filer från källa till destination
    echo "Backar upp filer från $source_dir till $target_dir..."
    rsync -av --backup --suffix=_backup "$source_dir/" "$target_dir/"
    echo "Backup fullständigt färdigställd"
}


#Återställnings funktion
perform_recovery() {
    read -p "Ange återställningsmapp: " recovery_dir

    # Kolla om återställningsmapp existerar
    if [ ! -d "$recovery_dir" ]; then
        echo "Återställningsmapp existerar inte eller är felaktig. Korrigera din inmatning."
        exit 1
    fi

    read -p "Välj ett av följande tre återställnings-direktiv (1/2/3):
1. Skapa kopior av existerande filer.
2. Skriv över existerande filer.
3. Skippa existerande filer.
Ange ditt val: " recovery_option

    case $recovery_option in
    1)
        echo "Skapar kopior av existerande filer..."
        rsync -avp --backup --suffix=_recovered $recovery_dir $source_dir
        ;;
    2)
        echo "Skriver över existerande filer..."
        rsync -avp $recovery_dir $source_dir
        ;;
    3)
        echo "Skippar existerande filer..."
        rsync -avp --ignore-existing $recovery_dir $source_dir
        ;;
    *)
        echo "Ogiltig inmatning. Var god välj 1, 2 eller 3."
        exit 1
        ;;
    esac

    echo "Återställning klar"
}


#Huvudskript

read -p "Vill du göra en backup eller återställa filer? (backup/återställa): " action

case $action in
"backup")
    perform_backup
    ;;
"återställa")
    perform_recovery
    ;;
*)
    echo "Ogiltig inmatning. Var god välj 'backup' eller 'återställa'."
    exit 1
    ;;
esac