# 32-bit MIPS processor

Semester long design project by 
Wyatt Lien, Fahim Ghani, Jesse Coma, and Sundeep Kaler

Abstract
An FPGA (Field Programmable Gate Array) was programmed to work as a 32-bit-
processor loosely based on the R2000 microprocessor chip set. This processor is a CPU
(Central Processing Unit) that interprets instructions from the MIPS (Microprocessor
without Interlocked Pipeline Stages) I instruction set. The processor is fully pipelined
and supports some data forwarding. The program is written in VHDL (Very high speed
IC Hardware Description Language). The processor was implemented on a Diligent
Nexys 4 FPGA. The processor was tested using a MIPS assembly program that counts
instances of a number in an array. The test program was successful, and made use of
various branch, load, store, arithmetic, and jump type instructions.



file hierarchy:  

impmlementation  
---datapath.vhd  
-------gpr.vhd  
-------control  
-------ALU.vhd  
---memory_unit.vhd  
