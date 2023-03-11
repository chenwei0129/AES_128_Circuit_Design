f0 = open("text/plaintext.txt", "r")
f1 = open("text/plaintext_ascii.txt","w")
f0_text = f0.read()
f0_ascii = ""
for i in range(len(f0_text)):
	str_ascii = str(hex(ord(f0_text[i])))[2:]
	if(len(str_ascii)==1):
		f0_ascii += ("0" + str_ascii)
	else:
		f0_ascii += str_ascii
	if len(f0_ascii)==32:
		f1.write(f0_ascii + "\n")
		f0_ascii = ""
f1.write(f0_ascii)

f0.close()
f1.close()
