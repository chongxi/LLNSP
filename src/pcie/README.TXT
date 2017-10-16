README file for a custom Xillybus IP core bundle
================================================

Core ID: 9376 ("SPI_Xike_Xillybus_INT" by chongxi.lai@gmail.com)
Target: Revision B for Xilinx Kintex-7

This is a kit for modifying the demo bundle into the custom configuration
(which is detailed below). Please follow the three steps below (unless you've
used Vivado's block design tool to connect to Xillybus' IP core, following
the Block Design Flow for non-HDL users).

(1) Replace the existing xillybus.v and xillybus_core.v files with the ones
    in this bundle.

(2) Replace the xillybus_core.ngc file in the demo bundle's core/ subdirectory
    with the one in this bundle.

(3) Edit xillydemo.v (or xillydemo.vhd) to reflect the desired application
    of this custom IP core. The template.v (or template.vhd) file in the
    "instantiation templates" directory of this bundle contains the signal
    outline and instantiation format. Note that unlike its xillydemo.*
    counterpart, there is no application logic (e.g. loopback FIFOs) in
    the instantiation templates. It's however recommended to follow the
    spirit of the xillydemo.* examples when attaching the application logic
    to the core.

To modify a design other than the demo bundle, equivalent actions should be
taken on the design's hierarchy. It's recommended to first delete the
xillybus_core.ngc file, and attempt to build the project, just to verify
that the build fails as the file is missing. Only then add the new
replacement.

The device files and their attributes are listed below. These are detected
automatically by the host's driver, so there is no specific driver for the
IP core attached.

NOTE: The DMA buffers mentioned are allocated on the host's RAM, not from
      resources on the FPGA.

------- /dev/xillybus_write_32 or \\.\xillybus_write_32

  Downstream (host to FPGA):
    Data width: 32 bits
    DMA buffers: 1024 x 256 kB = 256 MB
    Flow control: Asynchronous
    Seekable: No
    FPGA RAM for DMA acceleration: 8 segments x 512 bytes = 4 kB

------- /dev/xillybus_mua_32 or \\.\xillybus_mua_32

  Upstream (FPGA to host):
    Data width: 32 bits
    DMA buffers: 1024 x 128 kB = 128 MB
    Flow control: Asynchronous, select() and non-blocking read() supported (on Linux)
    Seekable: No

------- /dev/xillybus_spk_wav_32 or \\.\xillybus_spk_wav_32

  Upstream (FPGA to host):
    Data width: 32 bits
    DMA buffers: 256 x 128 kB = 32 MB
    Flow control: Asynchronous, select() and non-blocking read() supported (on Linux)
    Seekable: No

------- /dev/xillybus_spk_info_32 or \\.\xillybus_spk_info_32

  Upstream (FPGA to host):
    Data width: 32 bits
    DMA buffers: 64 x 128 kB = 8 MB
    Flow control: Asynchronous, select() and non-blocking read() supported (on Linux)
    Seekable: No

------- /dev/xillybus_template_32 or \\.\xillybus_template_32

  Upstream (FPGA to host):
    Data width: 32 bits
    DMA buffers: 4 x 8 kB = 32 kB
    Flow control: Synchronous
    Seekable: Yes, with 16 address bits

  Downstream (host to FPGA):
    Data width: 32 bits
    DMA buffers: 4 x 8 kB = 32 kB
    Flow control: Synchronous
    Seekable: Yes, with 16 address bits
    FPGA RAM for DMA acceleration: 2 segments x 512 bytes = 1 kB

------- /dev/xillybus_control_regs_16 or \\.\xillybus_control_regs_16

  Upstream (FPGA to host):
    Data width: 16 bits
    DMA buffers: 4 x 4 kB = 16 kB
    Flow control: Synchronous
    Seekable: Yes, with 5 address bits

  Downstream (host to FPGA):
    Data width: 16 bits
    DMA buffers: 4 x 4 kB = 16 kB
    Flow control: Synchronous
    Seekable: Yes, with 5 address bits
    FPGA RAM for DMA acceleration: 2 segments x 512 bytes = 1 kB

------- /dev/xillybus_auxcmd1_membank_16 or \\.\xillybus_auxcmd1_membank_16

  Downstream (host to FPGA):
    Data width: 16 bits
    DMA buffers: 4 x 4 kB = 16 kB
    Flow control: Synchronous
    Seekable: Yes, with 16 address bits
    FPGA RAM for DMA acceleration: 2 segments x 512 bytes = 1 kB

------- /dev/xillybus_auxcmd2_membank_16 or \\.\xillybus_auxcmd2_membank_16

  Downstream (host to FPGA):
    Data width: 16 bits
    DMA buffers: 4 x 4 kB = 16 kB
    Flow control: Synchronous
    Seekable: Yes, with 16 address bits
    FPGA RAM for DMA acceleration: 2 segments x 512 bytes = 1 kB

------- /dev/xillybus_auxcmd3_membank_16 or \\.\xillybus_auxcmd3_membank_16

  Downstream (host to FPGA):
    Data width: 16 bits
    DMA buffers: 4 x 4 kB = 16 kB
    Flow control: Synchronous
    Seekable: Yes, with 16 address bits
    FPGA RAM for DMA acceleration: 2 segments x 512 bytes = 1 kB

------- /dev/xillybus_thr_32 or \\.\xillybus_thr_32

  Upstream (FPGA to host):
    Data width: 32 bits
    DMA buffers: 4 x 4 kB = 16 kB
    Flow control: Synchronous
    Seekable: Yes, with 16 address bits

  Downstream (host to FPGA):
    Data width: 32 bits
    DMA buffers: 4 x 4 kB = 16 kB
    Flow control: Synchronous
    Seekable: Yes, with 16 address bits
    FPGA RAM for DMA acceleration: 2 segments x 512 bytes = 1 kB

------- /dev/xillybus_status_regs_16 or \\.\xillybus_status_regs_16

  Upstream (FPGA to host):
    Data width: 16 bits
    DMA buffers: 4 x 4 kB = 16 kB
    Flow control: Synchronous
    Seekable: Yes, with 5 address bits

------- /dev/xillybus_neural_data_32 or \\.\xillybus_neural_data_32

  Upstream (FPGA to host):
    Data width: 32 bits
    DMA buffers: 1024 x 128 kB = 128 MB
    Flow control: Asynchronous, select() and non-blocking read() supported (on Linux)
    Seekable: No

------- /dev/xillybus_mem_16 or \\.\xillybus_mem_16

  Upstream (FPGA to host):
    Data width: 16 bits
    DMA buffers: 4 x 4 kB = 16 kB
    Flow control: Synchronous
    Seekable: Yes, with 5 address bits

  Downstream (host to FPGA):
    Data width: 16 bits
    DMA buffers: 4 x 4 kB = 16 kB
    Flow control: Synchronous
    Seekable: Yes, with 5 address bits
    FPGA RAM for DMA acceleration: 2 segments x 512 bytes = 1 kB

------- /dev/xillybus_fet_clf_32 or \\.\xillybus_fet_clf_32

  Upstream (FPGA to host):
    Data width: 32 bits
    DMA buffers: 128 x 128 kB = 16 MB
    Flow control: Asynchronous, select() and non-blocking read() supported (on Linux)
    Seekable: No

