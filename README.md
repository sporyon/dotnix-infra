# How to deploy dotnix on Hetzner.
This Guide documents a simple installation of a polkadot validator using dotnix and nixos anywhere on a target machine running x86_64-linux with [kexec](https://man7.org/linux/man-pages/man8/kexec.8.html) support.
In our example we are installing Dotnix on a Hetzner dedicated server.

## Prerequisites
- A Flake
- A disk configuration file see [disko](link)
- A target machine reachable with ssh, and either root rights or password-less-sudo, meeting the minimum [requirements](https://wiki.polkadot.network/docs/maintain-guides-how-to-validate-polkadot)


## Steps to deploy NixOS

As a first step we would need to create the flake we want to deploy on server.
1. Ensure flakes are enabled, see [NixOS-Manual](https://wiki.nixos.org/wiki/Flakes#enable-flakes)
2. Initialize a flake:
- You can either copy our [example](link)
or initalise the flake manually
 
    nix flake init

3. You also need to generate the hardware-configuration.nix file in case you are using a dedicated machine, using nixos-generate-config

To get nixos-generate-config on our machine we will utilize kexec

SSH into your machine

4. set a secure root password.

    passwd

4. in case you dont know the IP ( why is this needed if one uses ssh he knows the IP )

    ip addr

This will show the IP adress assigned to your network interfaces including the IP of the installer.

5. Since our machine doesnt come with an operating system we will use Kexec to load a new kernel from the currently running kernel in the rescue shell.
After running kexec the NixOS installer exists in the memory. 
   
    curl -L https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz | tar -xzf- -C /root
    /root/kexec/run

6. Generate the nessecary hardware config on your server

    nixos-generate-config --no-filesystems --dir /mnt

7. scp the file to your local directory

    scp root@116.202.216.60:/mnt/hardware-configuration.nix hardware-configuration.nix

8. Generate a configuration.nix like this one and add your ssh key.
Generate a file called disk-config.nix you find examples [here](disko-doku)

9. Generate the lock file.

    nix flake lock

10. Now you can run NixOS anywhere to install your System onto the Server
Run nixos anywhere 

 nix run github:nix-community/nixos-anywhere -- --flake /PATH/dotnix-infra/#dotnix-infra root@<ip address>


Now lets say you made some changes to your flake.nix rebuilding is just as easy

Rebuilding from your local machine

    nixos-rebuild switch --flake <URL to your flake> --target-host "root@<ip address>"

Rebuilding from the server itself

    nixos-rebuild switch --flake <URL to your flake>

Updating the System.
Update the flake from your local machine

    nix flake update

Rebuild from your local machine 

    nixos-rebuild switch --flake <URL to your flake> --target-host "root@<ip address>"
