
# Raspberry Pi Zabbix PROXY/AGENT Setup Guide

This guide provides quick steps to set up Raspbian on your Raspberry Pi and configure Zabbix PROXY and AGENT2 using our custom `install.sh` script.

## 1. Install Raspbian Using Raspberry Pi Imager

To install Raspbian on a Raspberry Pi, follow the official Raspberry Pi guide to use the Raspberry Pi Imager tool:

- **Raspbian Installation Guide**: [Install Raspberry Pi OS using Raspberry Pi Imager](https://www.raspberrypi.org/documentation/computers/getting-started.html#installing-the-operating-system)

### Recommended Installation and Setup Steps

1. **Choose OS Image**  
   Go to **Raspberry Pi OS (Other)** and select **Raspberry Pi OS Lite (64-bit)**.

2. **Edit Settings**  
   Click the gear icon to adjust settings:
   
   - **Set Hostname**: Use `zabbix-proxy-<YOURPROXYLOCATION_OR_CUSTOMERNAME>` (e.g., `zabbix-proxy-company1`).
   - **Set Username and Password**: Choose a username and password for your system (these will be used for SSH access and other system logins).
   - **Set Locale Settings**: 
     - **Timezone**: Set to `Europe/Prague`
     - **Keyboard Layout**: Set to `cz` (Czech layout)
   
3. **Enable Services**  
   - **Enable SSH**: Check **User password authentication** to allow SSH access with the user password.

4. **Save and Apply Settings**  
   - Confirm by selecting **Yes** when asked, "Would you like to apply OS customization settings?"

5. **Confirm Write to SD Card**  
   - Accept the prompt that all data on the media will be erased, and select **Yes** to proceed.

Follow these steps to complete the Raspbian setup. Once installed, your Raspberry Pi will be ready for further configuration using the `install.sh` script.


## 2. Download and Run the `install.sh` Script

Once Raspbian is installed and your Raspberry Pi is powered on, use the following one-liner command to download and run our `install.sh` configuration script:

```bash
sudo su - root
curl -sSL https://raw.githubusercontent.com/MartinHajducik/jsemit/refs/heads/main/linux/raspberry-pi/zabbix-proxy/install.sh?token=GHSAT0AAAAAACXJTY4KDRYI47IGMEX2GD4WZZU2WVA | sudo bash
```

This command will:
- Switch to root user
- Download the `install.sh` script from the repository.
- Execute it with `sudo` permissions to configure your Raspberry Pi.
