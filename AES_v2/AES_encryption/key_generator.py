import random
import math
f1 = open("text/key.txt","w")
f2 = open("../AES_decode/text/key.txt","w")
key = random.randint(0, math.pow(2, 128))
f1.write(str(hex(key))[2:])
f2.write(str(hex(key))[2:])
f1.close()
f2.close()
