# SPDX-FileCopyrightText: 2022-2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  self,
  config,
  ...
}:
{
  imports =
    [
      ../agents-common.nix
      ./disk-config.nix
    ]
    ++ (with self.nixosModules; [
      # users who have ssh access to this machine
      user-vjuntunen
      user-flokli
      user-jrautiola
      user-mariia
      user-leivos
      user-hrosten
      user-alextserepov
      user-mikkos
      user-milval
      user-ktu
    ]);

  sops.defaultSopsFile = ./secrets.yaml;
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "testagent-dev";
  services.testagent = {
    variant = "dev";
    hardware = [
      "orin-agx"
      "orin-nx"
      "nuc"
      "lenovo-x1"
      "dell-7330"
    ];
  };

  boot.initrd.availableKernelModules = [
    "vmd"
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.kernelModules = [
    "kvm-intel"
    "sg"
  ];

  # udev rules for test devices serial connections
  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="FTD1BQQS", SYMLINK+="ttyORINNX1", MODE="0666", GROUP="dialout"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="FTD0WF8Y", SYMLINK+="ttyNUC1", MODE="0666", GROUP="dialout"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea71", ATTRS{serial}=="04A629B8AB87AB8111ECB2A38815028", ENV{ID_USB_INTERFACE_NUM}=="01", SYMLINK+="ttyRISCV1", MODE="0666", GROUP="dialout"
  '';

  # Details of the hardware devices connected to this host
  environment.etc."jenkins/test_config.json".text =
    let
      location = config.networking.hostName;
    in
    builtins.toJSON {
      addresses = {
        relay_serial_port = "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_A10KYI3B-if00-port0";
        OrinAGX1 = {
          inherit location;
          serial_port = "/dev/ttyACM0";
          relay_number = 4;
          device_ip_address = "172.18.16.54";
          socket_ip_address = "NONE";
          plug_type = "NONE";
          switch_bot = "NONE";
          usbhub_serial = "0x2954223B";
          ext_drive_by-id = "usb-Samsung_PSSD_T7_S6XNNS0W202677W-0:0";
          threads = 12;
        };
        OrinNX1 = {
          inherit location;
          serial_port = "/dev/ttyORINNX1";
          relay_number = 3;
          device_ip_address = "172.18.16.61";
          socket_ip_address = "NONE";
          plug_type = "NONE";
          switch_bot = "NONE";
          usbhub_serial = "0xEE92E4FD";
          ext_drive_by-id = "usb-Samsung_PSSD_T7_S6XPNS0W606359P-0:0";
          threads = 8;
        };
        NUC1 = {
          inherit location;
          relay_number = 1;
          serial_port = "/dev/ttyNUC1";
          device_ip_address = "172.18.16.16";
          socket_ip_address = "NONE";
          plug_type = "NONE";
          switch_bot = "NONE";
          usbhub_serial = "0x029CEAF3";
          ext_drive_by-id = "usb-Samsung_PSSD_T7_S6XNNS0W201129V-0:0";
          threads = 8;
        };
        LenovoX1-1 = {
          inherit location;
          serial_port = "NONE";
          device_ip_address = "172.18.16.17";
          socket_ip_address = "NONE";
          plug_type = "NONE";
          switch_bot = "LenovoX1-dev";
          usbhub_serial = "0x99EB9D84";
          ext_drive_by-id = "usb-Samsung_PSSD_T7_S6XPNS0W606188E-0:0";
          threads = 20;
        };
        Dell7330 = {
          inherit location;
          serial_port = "NONE";
          device_ip_address = "172.18.16.23";
          socket_ip_address = "NONE";
          plug_type = "NONE";
          switch_bot = "Dell7330-dev";
          usbhub_serial = "5AC2B4AD";
          ext_drive_by-id = "usb-Samsung_PSSD_T7_S6XNNS0W500904J-0:0";
          threads = 8;
        };
      };
    };
}
