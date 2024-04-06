#!/usr/bin/env bash

regex_filename='^[a-zA-Z]+\.[a-z]+$'
regex_message='^[A-Z ]+$'

display_menu() {
    echo "0. Exit
1. Create a file
2. Read a file
3. Encrypt a file
4. Decrypt a file
Enter an option:"
}

create_file() {
    echo "Enter the filename:"
    read filename
    if [[ "$filename" =~ $regex_filename ]]; then
        echo "Enter a message:"
        read message
        if [[ "$message" =~ $regex_message ]]; then
            echo "$message" > "$filename"
            echo -e "The file was created successfully!\n"
        else
            echo -e "This is not a valid message!\n"
        fi
    else
        echo -e "File name can contain letters and dots only!\n"
    fi
}

read_file() {
    echo "Enter the filename:"
    read filename
    if [[ -f "$filename" ]]; then
        echo "File content:"
        cat "$filename"
	echo ""
    else
        echo -e "File not found!\n"
    fi
}

encrypt_file() {
    echo "Enter the filename:"
    read filename
    if [[ -f "$filename" ]]; then
        echo "Enter password:"
        read password
        openssl enc -aes-256-cbc -e -pbkdf2 -nosalt -in "$filename" -out "${filename}.enc" -pass pass:"$password" &>/dev/null
        exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            echo -e "Fail\n"
        else
            rm "$filename"
            echo -e "Success\n"
        fi
    else
        echo -e "File not found!\n"
    fi
}

decrypt_file() {
    echo "Enter the filename:"
    read filename
    if [[ -f "$filename" ]]; then
        echo "Enter password:"
        read password
        openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -in "$filename" -out "${filename::-4}" -pass pass:"$password" &>/dev/null
        exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            echo -e "Fail\n"
        else
            rm "$filename"
            echo -e "Success\n"
        fi
    else
        echo -e "File not found!\n"
    fi
}

echo -e "Welcome to the Enigma!\n"
while true; do
    display_menu
    read option
    case "$option" in

        0)
            echo "See you later!"
            break;;
        1)
            create_file;;
        2)
            read_file;;
        3)
            encrypt_file;;
        4)
            decrypt_file;;
        *)
            echo -e "Invalid option!\n";;
    esac
done