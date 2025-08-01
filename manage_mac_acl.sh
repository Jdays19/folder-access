#!/usr/bin/env bash

FOLDER_GROUP="folderaccess"

show_menu() {
  echo
  echo "1) View folder ACLs"
  echo "2) View user group memberships"
  echo "3) Add a user (grant access)"
  echo "4) Remove a user (revoke access)"
  echo "5) Bulk add users from CSV"
  echo "6) Bulk remove users from CSV"
  echo "0) Exit"
}

view_acls() {
  echo
  printf "%-11s %-10s %-10s %s\n" "Permissions" "Owner" "Group" "Name"
  printf "%-11s %-10s %-10s %s\n" "-----------" "----------" "----------" "----"
  ls -le "$1" | awk '{ name=""; for(i=9;i<=NF;i++) name = name $i (i<NF?" ":""); printf "%-11s %-10s %-10s %s\n", $1, $3, $4, name }'
}

view_user_groups() {
  if groups=$(id -Gn "$1" 2>/dev/null); then
    IFS=' ' read -r -a arr <<<"$groups"
    echo
    printf "%-30s\n" "Group Name"
    printf "%-30s\n" "------------------------------"
    for g in "${arr[@]}"; do
      printf "%-30s\n" "$g"
    done
  else
    echo "User '$1' not found"
  fi
}

add_user() {
  sudo dseditgroup -o edit -a "$2" -t user $FOLDER_GROUP
  echo "Access granted: $2 → $FOLDER_GROUP"
}

remove_user() {
  if sudo dseditgroup -o edit -d "$2" -t user $FOLDER_GROUP 2>/dev/null; then
    echo "Access revoked: $2 from $FOLDER_GROUP"
  else
    echo "No access entry for $2 in $FOLDER_GROUP"
  fi
}

bulk_add() {
  local csv="$2"
  local added=0

  while IFS= read -r user; do
    user="${user//$'\r'/}"           # strip CR
    [[ -z "$user" ]] && continue     # skip blank lines
    if sudo dseditgroup -o edit -a "$user" -t user "$FOLDER_GROUP"; then
      ((added++))
    fi
  done < <(tail -n +2 "$csv")

  echo "$added users added → $FOLDER_GROUP"
}

bulk_remove() {
  local csv="$2"
  local removed=0

  while IFS= read -r user; do
    user="${user//$'\r'/}"
    [[ -z "$user" ]] && continue
    if sudo dseditgroup -o edit -d "$user" -t user "$FOLDER_GROUP"; then
      ((removed++))
    fi
  done < <(tail -n +2 "$csv")

  echo "$removed users removed → $FOLDER_GROUP"
}


read -rp "Folder path: " folder
while true; do
  show_menu
  read -rp "Select an option: " opt
  echo
  case $opt in
    1) view_acls     "$folder" ;;
    2)
      read -rp "User (short name): " user
      echo
      view_user_groups "$user"
      ;;
    3)
      read -rp "User (short name): " user
      echo
      add_user        "$folder" "$user"
      ;;
    4)
      read -rp "User (short name): " user
      echo
      remove_user     "$folder" "$user"
      ;;
    5)
      read -rp "CSV path: " csv
      bulk_add   "$folder" "$csv"
      ;;
    6)
      read -rp "CSV path: " csv
      bulk_remove "$folder" "$csv"
      ;;
    0) break ;;
    *) echo "Invalid option" ;;
  esac
done
