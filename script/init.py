import os
import sys

test_case1 = open("./eval/AES_testcases_128.txt","r")
test_case2 = open("./eval/AES_testcases_192.txt","r")
test_case3 = open("./eval/AES_testcases_256.txt","r")
input_file1 = open("./sim/input_128.txt","w")
input_file2 = open("./sim/input_192.txt","w")
input_file3 = open("./sim/input_256.txt","w")
input_file4 = open("./sim/input_128D.txt","w")
input_file5 = open("./sim/input_192D.txt","w")
input_file6 = open("./sim/input_256D.txt","w")

lines1 = test_case1.readlines()[2:]
lines2 = test_case2.readlines()[2:]
lines3 = test_case3.readlines()[2:]

# for 128 bits
for line1 in lines1:
   vector_line1 = line1.split()
   flag1 = vector_line1[0]
   plain_text1 = vector_line1[1]
   Ciphertext1 = vector_line1[3]
   key1 = vector_line1[2]

   text_bin1 = bin(int(plain_text1,16))[2:]
   for n in range(128-len(text_bin1)):
      text_bin1 = "0"+text_bin1
   key_bin1 = bin(int(key1,16))[2:]
   for n in range(128-len(key_bin1)):
      key_bin1 = "0"+key_bin1
   cip_bin1 = bin(int(Ciphertext1,16))[2:]
   for n in range(128-len(cip_bin1)):
	   cip_bin1 = "0"+cip_bin1

   if flag1=='0':
      input_file1.write(text_bin1+" "+key_bin1+"\n")
   else:
      input_file4.write(cip_bin1+" "+key_bin1+"\n")

# for 192 bits
for line2 in lines2:
   vector_line2 = line2.split()
   flag2 = vector_line2[0]
   plain_text2 = vector_line2[1]
   Ciphertext2 = vector_line2[3]
   key2 = vector_line2[2]

   text_bin2 = bin(int(plain_text2,16))[2:]
   for n in range(128-len(text_bin2)):
      text_bin2 = "0"+text_bin2
   key_bin2 = bin(int(key2,16))[2:]
   for n in range(192-len(key_bin2)):
      key_bin2 = "0"+key_bin2
   cip_bin2 = bin(int(Ciphertext2,16))[2:]
   for n in range(128-len(cip_bin2)):
	   cip_bin2 = "0"+cip_bin2

   if flag2=='0':
      input_file2.write(text_bin2+" "+key_bin2+"\n")
   else:
      input_file5.write(cip_bin2+" "+key_bin2+"\n")

# for 256 bits
for line3 in lines3:
   vector_line3 = line3.split()
   flag3 = vector_line3[0]
   plain_text3 = vector_line3[1]
   Ciphertext3 = vector_line3[3]
   key3 = vector_line3[2]

   text_bin3 = bin(int(plain_text3,16))[2:]
   for n in range(128-len(text_bin3)):
      text_bin3 = "0"+text_bin3
   key_bin3 = bin(int(key3,16))[2:]
   for n in range(256-len(key_bin3)):
      key_bin3 = "0"+key_bin3
   cip_bin3 = bin(int(Ciphertext3,16))[2:]
   for n in range(128-len(cip_bin3)):
	   cip_bin3 = "0"+cip_bin3

   if flag3=='0':
      input_file3.write(text_bin3+" "+key_bin3+"\n")
   else:
      input_file6.write(cip_bin3+" "+key_bin3+"\n")
