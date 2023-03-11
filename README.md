# AES Circuit Design

## Using AES algorithm to encrypt/decrypt the message.

## THere are three versions of the circuit, the functions are the same, just difference from their architecture.

* V1\
A typical AES circuit, and the module "key expansion" is a combinational circuit, generate 10 keys at a time. Thereforw we need a MUX to select a key to use.

* V2\
Modify V1 "key expansion" module, to reduce the hardware resource.

* V3\
Modify V2 "key epansion" and "mixcolumns"/"inv_mixcolumns"
