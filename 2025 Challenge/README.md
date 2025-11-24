MATLAB
======

[MATLAB](https://www.mathworks.com/products/matlab.html) _(**MAT**rix **LAB**oratory)_ is a proprietary multi-paradigm programming language and numeric computing environment developed by [MathWorks](https://www.mathworks.com/). MATLAB allows matrix manipulations, plotting of functions and data, implementation of algorithms, creation of user interfaces, and interfacing with programs written in other languages.

This project forms part of the CHPC Student Cluster competition, where participants will apply Parallel computing techniques in the MATLAB environment to speed up their code execution. This problem has been put forward as part of a collaboration between MathWorks, Opti-Num Solutions and the CHPC.

# Installation Instructions

Team Captains have been provided with the URL, Activation Key and Licensing information required to download, install and activate their MATLAB deployments.

1. Use the link provided to navigate to the MATLAB CHPC Workshop Workspace:
   <p align="center"><img alt="Matlab CHPC Workshop Workspace" src="./resources/CHPC_license_page.png" width=600 /></p>

1. You will be prompted to login or create a MathWorks account. Please do so in order to link your account with the provided license.

1. You DO NOT need to download the installer here as you will be using MATLAB Product Manager to do the installation on your head node.

1. Install all of the [dependencies](https://github.com/mathworks-ref-arch/container-images/blob/main/matlab-deps/r2024b/ubuntu24.04/base-dependencies.txt) required to run the MATLAB installer:
   * DNF / YUM
     ```bash
     # RHEL, Rocky, Alma, CentOS Stream
     sudo dnf install alsa-lib.x86_64 cairo.x86_64 cairo-gobject.x86_64 cups-libs.x86_64 gdk-pixbuf2.x86_64 glib2.x86_64 glibc.x86_64 glibc-langpack-en.x86_64 glibc-locale-source.x86_64 gtk3.x86_64 libICE.x86_64 libXcomposite.x86_64 libXcursor.x86_64 libXdamage.x86_64 libXfixes.x86_64 libXft.x86_64 libXinerama.x86_64 libXrandr.x86_64 libXt.x86_64 libXtst.x86_64 libXxf86vm.x86_64 libcap.x86_64 libdrm.x86_64 libglvnd-glx.x86_64 libsndfile.x86_64 libtool-ltdl.x86_64 libuuid.x86_64 libwayland-client.x86_64 make.x86_64 mesa-libgbm.x86_64 net-tools.x86_64 nspr.x86_64 nss.x86_64 nss-util.x86_64 pam.x86_64 pango.x86_64 procps-ng.x86_64 sudo.x86_64 unzip.x86_64 which.x86_64 zlib.x86_64
     ```
   * APT
     ```bash
     # Debian, Ubuntu
     sudo apt install libasound2t64 libcairo2 libcairo-gobject2 libcups2 libgdk-pixbuf-2.0-0 libglib2.0-0 libc6 language-pack-en locales libgtk-3-0 libice6 libxcomposite1 libxcursor1 libxdamage1 libxfixes3 libxft2 libxinerama1 libxrandr2 libxt6 libxtst6 libxxf86vm1 libcap2 libdrm2 libgl1 libsndfile1 libltdl7 libuuid1 libwayland-client0 libgbm1 net-tools libnspr4 libnss3 libpam0g libpango-1.0-0 procps sudo unzip which zlib1g
     ```
   * Pacman
     ```bash
     # Arch
     sudo pacman -S alsa-lib cairo cups gdk-pixbuf2 glib2 glibc glibc-locales gtk3 libice libxcomposite libxcursor libxdamage libxfixes libxft libxinerama libxrandr libxt libxtst libxxf86vm libcap libdrm libglvnd libsndfile libtool make mesa-utils net-tools nspr nss pam pango procps-ng sudo unzip which zlib
     ```
1. X11 Forwarding needs to be configured and enabled on both the client and the server side:
   On your **head node**
   * Enable `X11Forwarding`, by editing `/etc/ssh/sshd_conf` and setting the following option:
     ```conf
     ...
     X11Forwarding yes
     ...
     ```
   * Install `xauth`
     * DNF / YUM
     ```bash
     # RHEL, Rocky, Alma, CentOS Stream
     sudo dnf update -y
     sudo dnf install xauth
     ```
     * APT
     ```bash
     # Debian, Ubuntu
     sudo apt update
     sudo apt install xauth
     ```
     * Pacman
     ```bash
     # Arch
     sudo pacman -Syu
     sudo pacman -S xorg-xauth
     ```
   * Reload your SSH server configuration
     ```bash
     sudo systemctl reload sshd
     ```
1. Open a new terminal on your local workstation and `ssh` onto your head node with the following option(s):
   ```bash
   # The -X switch enables the option ForwardX11
   ssh -X -i <PATH-TO-KEY> <USER>@<HEADNODE_IP>
   ```

> [!WARNING]
> Should you have issues with how the MATLAB GUI is rendered on your local workstation or receive a number of errors, you can try remedy these by enabling the `ForwardX11Trusted` option `-Y` switch, which will prevent your `ssh` connection from being subjected to [X11 Security Extensions](https://www.x.org/wiki/Development/Documentation/Security/).

## Install MATLAB, Simulink and Associated Toolboxes

1. On your **head node**, from a new terminal, use wget to download the latest version of mpm.
   ```
   wget https://www.mathworks.com/mpm/glnxa64/mpm
   ```
1. Give executable permissions to the downloaded file so that you can run mpm.
   ```
   chmod +x mpm
   ```
1. Install products and support packages for the latest MATLAB release by specifying installation options in an input file.
1. From the [mpm-input-files](https://github.com/mathworks-ref-arch/matlab-dockerfile/tree/main/mpm-input-files/R2025b) folder, download a copy of the mpm_input_r2025b.txt file.
1. In the downloaded file, configure the MATLAB installation by uncommenting lines that start with a single # for the following products:
   * MATLAB
   * MATLAB Coder
   * MATLAB Compiler
   * MATLAB Compiler SDK
   * Optimization Toolbox
   * Parallel Computing Toolbox
   <p align="center"><img alt="Matlab 2024B Linux Installation" src="./resources/CHPC_Select_Toolboxes.png" width=600 /></p>
1. Save the file

1. Install the products and support package using mpm install. Specify the full path to the input file you downloaded and updated.

   ```
   ./mpm install --inputfile=/path/to/file/mpm_input_r2025b.txt
   ```
You have successfully installed MATLAB!

> [!WARNING]
> You are **STRONGLY** advised to install your MATLAB installations to a local, non-shared location. This will ensure that the License is correctly installed and configured for each the nodes in your cluster.

## Activate your license

1. The activation client is located here:
   ```
   /usr/local/MATLAB/R20XXy/bin/glnxa64/MathWorksProductAuthorizer.sh
   ```
Once you have launched the MathWorks activation client:
1. Log into your MathWorks account
1. Select the license provided to you from the list of licenses you would like to activate
1. Confirm the activation information
1. Click "finish" to complete the activation process.





