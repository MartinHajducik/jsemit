
# jsemIT Scripts Repository

This repository contains scripts and configuration files for managing and automating tasks across various platforms, including Linux (Raspberry Pi and general-purpose servers) and Windows. Each subdirectory is organized by platform and specific use case, allowing for easy navigation and maintenance.

## Repository Structure

Below is an overview of the folder structure and the purpose of each directory:

```
jsemIT/
│
├── README.md                       # Overview of the repository, structure, and usage instructions
├── LICENSE                         # License file if applicable
│
├── linux/                          # Scripts for Linux-based systems
│   ├── raspberry-pi/               # Scripts for Raspberry Pi setups
│   │   ├── zabbix-proxy/           # Setup scripts for Raspberry Pi as Zabbix proxies
│   │   │   ├── install.sh          # Main install script for Raspberry Pi Zabbix Proxy
│   │   │   └── config/             # Additional config files for Raspberry Pi Zabbix Proxy setup
│   │   └── general-scripts/        # General-purpose scripts for Raspberry Pi
│   │
│   └── general-linux/              # Scripts for generic Linux configurations and maintenance
│       └── debian-upgrade.sh       # Debian system upgrade script
│
├── windows/                        # Scripts for Windows-based systems
│   ├── adobe/                      # Adobe Acrobat installation and management scripts
│   │   ├── install_adobe.ps1       # PowerShell script for silent installation of Adobe Acrobat
│   │   └── uninstall_adobe.ps1     # PowerShell script for silent uninstallation of Adobe Acrobat
│   │
│   └── general-windows/            # General scripts for Windows setup and configuration
│       └── setup/                  # Directory for miscellaneous Windows setup scripts
│
└── docs/                           # Documentation and guides
    ├── usage-guides/               # Usage guides for each script category
    │   └── raspberry-pi-setup.md   # Guide for Raspberry Pi Zabbix Proxy setup
    │
    └── troubleshooting/            # Troubleshooting documents
        └── zabbix-troubleshooting.md # Troubleshooting guide for Zabbix Proxy
```

## Directory Purpose

- **`linux/`**: Contains scripts for configuring and managing Linux systems, organized into subdirectories for Raspberry Pi-specific and general Linux setups.
  - **`raspberry-pi/zabbix-proxy/`**: Scripts to configure Raspberry Pi devices as Zabbix proxies, useful for monitoring across distributed environments.
  - **`raspberry-pi/general-scripts/`**: General-purpose scripts designed specifically for Raspberry Pi devices.
  - **`general-linux/`**: Scripts intended for general Linux system configuration and maintenance, such as OS upgrades or service management.

- **`windows/`**: Contains scripts for Windows-based systems.
  - **`adobe/`**: PowerShell scripts to silently install or uninstall Adobe Acrobat, intended for efficient deployment across multiple systems.
  - **`general-windows/setup/`**: A placeholder for other general Windows configuration scripts.

- **`docs/`**: Documentation and guides to assist with using and troubleshooting the scripts.
  - **`usage-guides/`**: Detailed guides for setting up specific configurations, such as using a Raspberry Pi as a Zabbix proxy.
  - **`troubleshooting/`**: Troubleshooting documents to address common issues encountered with specific setups, like Zabbix configuration.

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/MartinHajducik/jsemit.git
   cd jsemit
   ```

2. Navigate to the appropriate directory based on your task, for example:
   - **Raspberry Pi Zabbix Proxy setup**: `linux/raspberry-pi/zabbix-proxy/`
   - **Adobe Acrobat installation for Windows**: `windows/adobe/`

3. Follow the specific usage guide in `docs/usage-guides` for detailed setup instructions.

## Contributing

Please ensure any new scripts are placed in the appropriate folder and include a brief description in this README for future reference. Update the relevant documentation in `docs/` if applicable.

---

This structure should make it easy to locate scripts and documentation as well as support the addition of new tools and platforms in the future.
