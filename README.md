# Folder Access Management Script

A Bash script to manage folder access on macOS using a dedicated system group.

## Background

This script is adapted from a project I developed during my previous internship. The original Windows PowerShell version replaced a manual process of checking folder permissions and adding users one by one, significantly reducing the time spent resolving access tickets. The current version has been updated to fit macOS.

## Features

- View folder ACL entries

- View a user’s system group memberships

- Grant or revoke access for a single user

- Bulk add or remove users via a CSV file


## Run the script and follow the menu prompts:

./manage_mac_acl.sh

## Menu options:
<img width="466" height="242" alt="image" src="https://github.com/user-attachments/assets/1611daa6-1df8-4236-b57b-eda83fd6a3bd" />

## Examples

**Option 1** simply lists everything inside the folder and shows, in plain columns, who owns each item and what they’re allowed to do with it (read, write or execute). It lets you see exactly who can open, change, or run it. That way you can catch mistakes, keep your data secure, and fix access problems before they block someone (or let someone in who shouldn’t be):<br>

<img width="740" height="410" alt="image" src="https://github.com/user-attachments/assets/b5b1aff6-1adc-43ba-821c-0ee54e395e87" />

***

**Option 2** shows all the system groups a given user belongs to. Since folder access is granted by adding users to the folderaccess group, this lets you verify they’ve actually been given (or removed from) permission. <br>

<img width="470" height="480" alt="image" src="https://github.com/user-attachments/assets/93e6f87b-0c2b-41c2-84d8-43d3944f9c46" />

***

**Option 3**: Grants a user access by adding them to the `folderaccess` group. Once added, they can read and write that folder.

**Option 4:** Revokes a user’s access by removing them from `folderaccess`. Once removed, they lose read/write permissions.

<br><img width="608" height="386" alt="image" src="https://github.com/user-attachments/assets/8e853d23-1d77-4cd9-a28c-c32778d8fdca" /><br>
<br><img width="462" height="448" alt="image" src="https://github.com/user-attachments/assets/143a352a-f162-400d-9847-c5a8599c8029" /><br>


- Here, we see after access is revoked, the group is no longer a part of the user's group memberships.

***

**Option 5:** Bulk-add users from a CSV. You point it at your CSV (with a `UserName` header and one username per line), and the script loops through every entry, adding each user to the `folderaccess` group and then prints how many were granted access.

**Option 6:** Bulk-remove users from a CSV. Works the same way but removes each listed user from `folderaccess`, revoking their folder access and then prints how many were revoked.

<img width="830" height="794" alt="image" src="https://github.com/user-attachments/assets/30223de3-f278-442b-b939-29f45a11afd7" />





