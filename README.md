### Create the project from tcl 

```
vivado -source build-project.tcl
```

- The `src` folder contains the RTL code. 
- The `IP`  folder contains the xci file.
- The `util` folder contains the xillybus ngc file and other utility
- The `src/constraints` folder contains the xdc file
- The `src/xillybus` folder contains the xillybus RTL code.
- The `src/clock` folder contains PLL RTL code
- The `src/spi` folder contains SPI firmware with two interface module

### Device in the project
SPI part
```
crw-rw-rw- 1 root root 241,  6 Mar  8 17:24 /dev/xillybus_auxcmd1_membank_16
crw-rw-rw- 1 root root 241,  7 Mar  8 17:24 /dev/xillybus_auxcmd2_membank_16
crw-rw-rw- 1 root root 241,  8 Mar  8 17:24 /dev/xillybus_auxcmd3_membank_16
crw-rw-rw- 1 root root 241,  5 Mar  8 17:24 /dev/xillybus_control_regs_16
crw-rw-rw- 1 root root 241, 10 Mar  8 17:24 /dev/xillybus_status_regs_16
crw-rw-rw- 1 root root 241, 11 Mar  8 17:24 /dev/xillybus_neural_data_32
```
Xike Part
```
crw-rw-rw- 1 root root 241, 12 Mar  8 17:24 /dev/xillybus_mem_16
crw-rw-rw- 1 root root 241,  1 Mar  8 17:24 /dev/xillybus_mua_32
crw-rw-rw- 1 root root 241,  2 Mar  8 17:24 /dev/xillybus_spk_realtime_32
crw-rw-rw- 1 root root 241,  3 Mar  8 17:24 /dev/xillybus_spk_sort_32
crw-rw-rw- 1 root root 241,  4 Mar  8 17:24 /dev/xillybus_template_32
crw-rw-rw- 1 root root 241,  9 Mar  8 17:24 /dev/xillybus_thr_32
crw-rw-rw- 1 root root 241,  0 Mar  8 17:24 /dev/xillybus_write_32
```
-------------------

### Signal flow
Two pathway: 
```
INTAN -> SPI -> Xillybus
INTAN -> SPI -> Xike -> Xillybus
two interfaces module are located in `src/spi` folder
```

-------------------

To be continued...

