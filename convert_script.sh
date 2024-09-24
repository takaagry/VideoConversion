#!/bin/bash

set -e

while true; do
    # Clear the terminal to remove previous output
    clear

    # Display the main menu
    echo
    echo "Davinci Resolve Converting Script Menu"
    echo "1. Convert"
    echo "2. Exit"
    echo
    read -p "Choose an option (1 or 2): " choice

    case "$choice" in
        1)
            # Variables to track whether the user wants to change directory or format
            change_dir=false
            change_format=false

            # Start with the user providing a format and directory
            while true; do
                # Only ask for video format if it's the first time or the user requested a change
                if [[ "$change_format" == false ]]; then
                    clear
                    echo "Select the video format you want to search for:"
                    echo "1. mp4"
                    echo "2. mkv"
                    echo "3. mov"
                    echo "4. avi"
                    echo
                    read -p "Enter the number of the format: " format_choice

                    case "$format_choice" in
                        1) video_format="mp4" ;;
                        2) video_format="mkv" ;;
                        3) video_format="mov" ;;
                        4) video_format="avi" ;;
                        *) echo "Invalid option. Please try again."; continue ;;
                    esac

                    change_format=true  # After this, assume they may want to change it
                fi

                # Only ask for directory if it's the first time or the user requested a change
                if [[ "$change_dir" == false ]]; then
                    clear
                    dir=$(kdialog --getexistingdirectory "Select Directory")

                    if [ $? -ne 0 ]; then
                        echo "Directory selection canceled."
                        continue 2 # Go back to the main menu
                    fi
                    change_dir=true  # After this, assume they may want to change it
                fi

                echo
                echo "Checking for video files with .$video_format format in \"$dir\"..."
                echo

                # Find all video files with the selected format
                video_files=("$dir"/*."$video_format")

                # If no matching files, ask whether to change directory or format
                if [ -z "$(ls "$dir"/*."$video_format" 2>/dev/null)" ]; then
                    echo "There are no video files with the .$video_format format in \"$dir\"."
                    echo
                    echo "1. Change directory"
                    echo "2. Change format"
                    echo "3. Go back to main menu"
                    echo
                    read -p "Choose an option (1, 2, or 3): " sub_choice

                    case "$sub_choice" in
                        1)
                            # Change directory, don't ask for format again
                            change_dir=false
                            continue
                            ;;
                        2)
                            # Change format, don't ask for directory again
                            change_format=false
                            continue
                            ;;
                        3)
                            # Go back to main menu
                            break
                            ;;
                        *)
                            echo "Invalid option. Returning to the main menu."
                            break
                            ;;
                    esac
                fi

                # Use kdialog to select multiple files
                selected_files=$(kdialog --title "Select Videos to Convert" --multiple --separate-output --getopenfilename "$dir" "*.$video_format" "Select video files")

                # Check if the user canceled the file selection
                if [ $? -ne 0 ]; then
                    echo "File selection canceled."
                    continue 2 # Go back to the main menu
                fi

                # Display selected files for confirmation
                echo "Selected files for conversion:"
                echo "$selected_files"
                echo

                # Ask for the conversion format
                echo "Select the desired output video format for the selected files:"
                echo "1. mp4"
                echo "2. avi"
                echo "3. mov"
                echo
                read -p "Enter the number of the output format: " output_choice

                case "$output_choice" in
                    1) output_format="mp4" ;;
                    2) output_format="avi" ;;
                    3) output_format="mov" ;;
                    *) echo "Invalid option. Returning to the main menu."; break ;;
                esac

                origdir="$dir/originals"
                shopt -s extglob nullglob

                # Create the originals directory if it doesn't exist
                if [ ! -d "$origdir" ]; then
                    echo "Creating \"$origdir\" directory."
                    mkdir "$origdir"
                fi

                echo

                # Loop over the selected files and convert them
                IFS=$'\n' # Set the Internal Field Separator to newline
                for vid in $selected_files; do
                    # Ensure the video path is quoted to handle spaces
                    noext="${vid%.$video_format}"
                    echo "Converting: \"$vid\" to \"${noext}.$output_format\"..." # Show the file name being converted
                    ffmpeg -i "$vid" -acodec pcm_s16le -vcodec copy "${noext}.$output_format"
                    mv "$vid" "$origdir"
                done

                echo
                echo "Conversion complete. Original videos moved to \"$origdir\"."
                echo
                read -p "Press ENTER to continue: "
                break # Conversion complete, return to main menu

            done
            ;;

        2)
            echo "Exiting the script."
            exit 0
            ;;

    esac
done
