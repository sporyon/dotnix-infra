{ inputs, modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = [
    config.dotnix.polkadot-validator.package
    pkgs.curl
    pkgs.gitMinimal
    pkgs.tmux
  ];

  # Validator configuration.
  dotnix.polkadot-validator.enable = true;
  dotnix.polkadot-validator.name = "sporyon-dotnix-westend";
  dotnix.polkadot-validator.chain = "westend";

    nixpkgs.overlays = [
      inputs.dotnix-core.overlays.default
    ];

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEDBG730UeBKvJvSWWH7baDmYTPPQzvSGLzogkwiw0U5AAAABHNzaDo="
    
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQDFR//RnCvEZAt0F6ExDsatKZ/DDdifanuSL360mqOhaFieKI34RoOwfQT9T+Ga52Vh5V2La6esvlph686EdgzeKLvDoxEwFM9ZYFBcMrNzu4bMTlgE7YUYw5JiORyXNfznBGnme6qpuvx9ibYhUyiZo99kM8ys5YrUHrP2JXQJMezDFZHxT4GFMOuSdh/1daGoKKD6hYL/jEHX8CI4E3BSmKK6ygYr1fVX0K0Tv77lIi5mLXucjR7CytWYWYnhM6DC3Hxpv2zRkPgf3k0x/Y1hrw3V/r0Me5h90pd2C8pFaWA2ZoUT/fmyVqvx1tZPYToU/O2dMItY0zgx2kR0yD+6g7Aahz3R+KlXkV8k5c8bbTbfGnZWDR1ZlbLRM9Yt5vosfwapUD90MmVkpmR3wUkO2sUKi80QfC7b4KvSDXQ+MImbGxMaU5Bnsq1PqLN95q+uat3nlAVBAELkcx51FlE9CaIS65y4J7FEDg8BE5JeuCNshh62VSYRXVSFt8bk3f/TFGgzC8OIo14BhVmiRQQ503Z1sROyf5xLX2a/EJavMm1i2Bs2TH6ROKY9z5Pz8hT5US0r381V8oG7TZyLF9HTtoy3wCYsgWA5EmLanjAsVU2YEeAA0rxzdtYP8Y2okFiJ6u+M4HQZ3Wg3peSodyp3vxdYce2vk4EKeqEFuuS82850DYb7Et7fmp+wQQUT8Q/bMO0DreWjHoMM5lE4LJ4ME6AxksmMiFtfo/4Fe2q9D+LAqZ+ANOcv9M+8Rn6ngiYmuRNd0l/a02q1PEvO6vTfXgcl4f7Z1IULHPEaDNZHCJS1K5RXYFqYQ6OHsTmOm7hnwaRAS97+VFMo1i5uvTx9nYaAcY7yzq3Ckfb67dMBKApGOpJpkvPgfrP7bgBO5rOZXM1opXqVPb09nljAhhAhyCTh1e/8+mJrBo0cLQ/LupQzVxGDgm3awSMPxsZAN45PSWz76zzxdDa1MMo51do+VJHfs7Wl0NcXAQrniOBYL9Wqt0qNkn1gY5smkkISGeQ/vxNap4MmzeZE7b5fpOy+2fpcRVQLpc4nooQzJvSVTFz+25lgZ6iHf45K87gQFMIAri1Pf/EDDpL87az+bRWvWi+BA2kMe1kf+Ay1LyMz8r+g51H0ma0bNFh6+fbWMfUiD9JCepIObclnUJ4NlWfcgHxTf17d/4tl6z4DTcLpCCk8Da77JouSHgvtcRbRlFV1OfhWZLXUsrlfpaQTiItv6TGIr3k7+7b66o3Qw/GQVs5GmYifaIZIz8n8my4XjkaMBd0SZfBzzvFjHMq6YUP9+SbjvReqofuoO+5tW1wTYZXitFFBfwuHlXm6w77K5QDBW6olT7pat41/F5eGxLcz"
  ];

  system.stateVersion = "24.05";
}
