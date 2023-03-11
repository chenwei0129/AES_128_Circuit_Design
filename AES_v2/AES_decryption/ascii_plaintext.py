f0 = open("text/plaintext_ascii.txt", "r")
f1 = open("text/plaintext.txt","w")
f0_ascii = f0.read()
f0_text = ""
i = 0
while(i<(len(f0_ascii)-1)):
	text = int(f0_ascii[i:i+2], 16)
	if text != 0:
		f0_text += chr(int(f0_ascii[i:i+2], 16))
	i = i + 2
f1.write(f0_text)

f0.close()
f1.close()
