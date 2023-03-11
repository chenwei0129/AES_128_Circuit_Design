f0 = open("text/cyphertext.txt", "r")
f1 = open("text/cyphertext_ascii.txt","w")
f0_text = f0.read()
f0_ascii = ""
for i in range(len(f0_text)):
	str_ascii = str(hex(ord(f0_text[i]) - 65))[2:]
	f0_ascii += str_ascii
	if len(f0_ascii)==32:
		f1.write(f0_ascii + "\n")
		f0_ascii = ""
f1.write(f0_ascii)

f0.close()
f1.close()
