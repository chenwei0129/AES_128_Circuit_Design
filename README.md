# AES-128 Circuit Design

## Using AES-128 algorithm to encrypt/decrypt the message.

## There are three versions of the circuit, the functions are the same, just difference from their architecture.

* V1\
A typical AES circuit, and the module "key expansion" is a combinational circuit, generate 10 keys at a time. Therefore we need a MUX to select a key to use.

* V2\
Modify V1 "key expansion" module from combinational circuit to sequential circuit, to reduce the hardware resources.

* V3
  * According to paper[1], modifing V2 "key expansion" and "mixcolumns"/"inv_mixcolumns" modules to improve the performance of the circuit.
  * Use a RAM in testbench(simulation) to store the subbytes, which are used in the "subbyte" module.

# How to use
## encrypt, in the folder "AES_encryption"
    1. Use key_generator.py to generate a key, which is 128bits. The key will be stored at "text/key.txt".
    
    2. Prepare the message in english to be encrypted at "text/plaintext.txt".
    
    3. Use plaintext_ascii.py to transfer the message into ascii code, it will be "text/plaintext_ascii.txt".
    
    4. Use AES circuit to encrypt the ascii code by iverilog or ncverilog. The encrypted ascii code will be "text/cyphertext_ascii.txt".
    
    5. Use ascii_cyphertext.py to transfer the encrypted ascii code into a alphabet message, which will be stored at "../AES_decryption/text/cyphertext.txt"
    
## decrypt, in the folder "AES_decryption"
    1. The key used when encrypt will stored at "AES_decryption/text/key.txt", too.
    
    2. Use cyphertext_ascii.py to transfer the encrypted alphabet message into encrypted ascii code, it will be "text/cyphertext_ascii.txt".
    
    3. Use AES circuit to decrypt the ascii code by iverilog or ncverilog. The decrypted ascii code will be "text/plaintext_acii.txt".
    
    4. Use ascii_plaintext.py to transfer the decrypted ascii code into a original message, which will be stored at "text/plaintext.txt"
    

# Reference
[1] Zhu, Yuwen, Hongqi Zhang, and Yibao Bao. "Study of the AES realization method on the reconfigurable hardware." 2013 International Conference on Computer Sciences and Applications. IEEE, 2013.
