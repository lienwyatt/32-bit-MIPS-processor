# 32-bit MIPS processor  

Semester long design project by 
Wyatt Lien, Fahim Ghani, Jesse Coma, and Sundeep Kaler

## Project Summary
In this project an FPGA was programmed to work as a 32-bit CPU. The CPU design is based loosely on the R2000 microprocessor and interprets instructions from the MIPS I instruction set. The processor is fully pipelined and supports data forwarding. All code is written in VHDL. The processor was implemented on a Digilent Nexys 4 FPGA. The processor was tested using a MIPS assembly program that made use of various branch, load, store, arithmetic, and jump type instructions.

![Datapath](https://user-images.githubusercontent.com/31666811/212496047-78ab888c-589c-4722-9355-b6a92463c516.png)

## file hierarchy:   

impmlementation  
---datapath.vhd  
-------gpr.vhd  
-------control  
-------ALU.vhd  
---memory_unit.vhd  
