### Create the project from tcl 

```
vivado -source build-project.tcl
```

The `src` folder contains the RTL code. 
The `IP`  folder contains the xci file.
The `util` folder contains the xillybus ngc file and other utility
The `src/constraints` folder contains the xdc file
The `src/xillybus` folder contains the xillybus RTL code.
The `src/clock` folder contains PLL RTL code


### Device in the project
```
crw-rw-rw- 1 root root 241, 3 Jan 30 22:09 /dev/xillybus_auxcmd1_membank_16
crw-rw-rw- 1 root root 241, 4 Jan 30 22:09 /dev/xillybus_auxcmd2_membank_16
crw-rw-rw- 1 root root 241, 5 Jan 30 22:09 /dev/xillybus_auxcmd3_membank_16
crw-rw-rw- 1 root root 241, 1 Jan 30 22:09 /dev/xillybus_control_regs_16
crw-rw-rw- 1 root root 241, 0 Jan 30 22:09 /dev/xillybus_neural_data_32
crw-rw-rw- 1 root root 241, 2 Jan 30 22:09 /dev/xillybus_status_regs_16
```
-------------------

To be continued...

