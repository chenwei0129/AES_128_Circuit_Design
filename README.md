# AES Circuit Design

## Using AES algorithm to encrypt/decrypt the message.

## THere are three versions of the circuit, the functions are the same, just difference from their architecture.

* V1\
A typical AES circuit, and the module "key expansion" is a combinational circuit, generate 10 keys at a time. Thereforw we need a MUX to select a key to use.

* V2\
Modify V1 "key expansion" module, to reduce the hardware resource.

* V3\
  * According to paper[1], modifing V2 "key expansion" and "mixcolumns"/"inv_mixcolumns" modules to improve the performance of the circuit.
  * Use a RAM in testbench(simulation) to store the subbytes, which are use in the "subbyte" module.

# Reference
[1] Zhu, Yuwen, Hongqi Zhang, and Yibao Bao. "Study of the AES realization method on the reconfigurable hardware." 2013 International Conference on Computer Sciences and Applications. IEEE, 2013.
