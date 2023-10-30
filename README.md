# Low-latency neural signal processor
Paper: https://www.biorxiv.org/content/10.1101/2023.09.14.557854v1.full.pdf

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
SPI device files
```
crwxr--r-- 1 chongxi chongxi 234,  6 Nov 18 18:31 /dev/xillybus_auxcmd1_membank_16
crwxr--r-- 1 chongxi chongxi 234,  7 Nov 18 18:31 /dev/xillybus_auxcmd2_membank_16
crwxr--r-- 1 chongxi chongxi 234,  8 Nov 18 18:31 /dev/xillybus_auxcmd3_membank_16
crwxr--r-- 1 chongxi chongxi 234,  5 Nov 18 18:31 /dev/xillybus_control_regs_16
crwxr--r-- 1 chongxi chongxi 234, 10 Nov 18 18:31 /dev/xillybus_status_regs_16
crwxr--r-- 1 chongxi chongxi 234, 11 Nov 18 18:31 /dev/xillybus_neural_data_32
```

PC-NSP communication device files
```
crwxr--r-- 1 chongxi chongxi 234,  0 Nov 18 18:31 /dev/xillybus_write_32
crwxr--r-- 1 chongxi chongxi 234, 12 Nov 18 18:31 /dev/xillybus_mem_16
crwxr--r-- 1 chongxi chongxi 234,  1 Nov 18 18:31 /dev/xillybus_mua_32
crwxr--r-- 1 chongxi chongxi 234,  4 Nov 18 18:31 /dev/xillybus_template_32
crwxr--r-- 1 chongxi chongxi 234,  9 Nov 18 18:31 /dev/xillybus_thr_32
```

NSP real-time processing device files
```
crwxr--r-- 1 chongxi chongxi 234,  3 Nov 18 18:31 /dev/xillybus_spk_info_32
crwxr--r-- 1 chongxi chongxi 234,  2 Nov 18 18:31 /dev/xillybus_spk_wav_32
crwxr--r-- 1 chongxi chongxi 234, 13 Nov 18 18:31 /dev/xillybus_fet_clf_32
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
### User-defined memory

`/dev/xillybus_mem_16` is a user-defined free 16-bits RAM block. FPGA designer can build advance functions based on the content in this memory. 

Use `spiketag.fpga.memory_api.read_mem_16(i)` and `spiketag.fpga.memory_api.wrte_mem_16(i, v)` to read and write into `i`th memory slot, each slot can hold a 16-bits number. 

