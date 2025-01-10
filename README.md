# BitLocker Recovery Key Backup Script

This PowerShell script retrieves and saves BitLocker recovery keys for all fixed drives on a system.

## Functionality

1. **Administrator Check:**  Ensures the script runs with administrator privileges. If not, it relaunches itself as administrator using a batch file (`start.bat`).
2. **Drive Enumeration:** Identifies all fixed drives in the system.
3. **BitLocker Status Check:** Checks if BitLocker is enabled on each drive.
4. **Recovery Key Retrieval:** If BitLocker is enabled, the script retrieves the recovery key.
5. **Key Saving:** Saves the recovery key to a file named with the current date and time (e.g., `2025-01-09_15-30-45.rkey`).
6. **Loop and Keypress:** Enters an infinite loop, sending a keypress every 5 seconds (likely for keeping a session active).

## Requirements

* **PowerShell:** This script requires PowerShell to execute.
* **Administrator Privileges:**  The script needs to be run with administrator privileges to access BitLocker information.

## Usage

1. **Run `start.bat`:**  Execute the `start.bat` file. You will be prompted to confirm running the script with administrator privileges.
