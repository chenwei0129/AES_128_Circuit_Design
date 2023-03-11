f0 = open("text/cyphertext_ascii.txt", "r")
f1 = open("../AES_decode/text/cyphertext.txt","w")
f0_ascii = f0.read()
f0_text = ""
for i in range(len(f0_ascii)):
	f0_text += chr(int(f0_ascii[i], 16) + 65)
f1.write(f0_text)

f0.close()
f1.close()
