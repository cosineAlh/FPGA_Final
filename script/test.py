import os

check_file1 = open("./eval/AES_testcases_128.txt","r")
check_file2 = open("./eval/AES_testcases_192.txt","r")
check_file3 = open("./eval/AES_testcases_256.txt","r")
output_file1 = open("./sim/output_128.txt","r")
output_file2 = open("./sim/output_192.txt","r")
output_file3 = open("./sim/output_256.txt","r")
output_file4 = open("./sim/output_128D.txt","r")
output_file5 = open("./sim/output_192D.txt","r")
output_file6 = open("./sim/output_256D.txt","r")
result1 = open("./eval/AES_results_encryption_128.txt","w")
result2 = open("./eval/AES_results_encryption_192.txt","w")
result3 = open("./eval/AES_results_encryption_256.txt","w")
result4 = open("./eval/AES_results_decryption_128.txt","w")
result5 = open("./eval/AES_results_decryption_192.txt","w")
result6 = open("./eval/AES_results_decryption_256.txt","w")

check_lines1 = check_file1.readlines()[2:]
out_lines1 = output_file1.readlines()
out_lines4 = output_file4.readlines()
check_lines2 = check_file2.readlines()[2:]
out_lines2 = output_file2.readlines()
out_lines5 = output_file5.readlines()
check_lines3 = check_file3.readlines()[2:]
out_lines3 = output_file3.readlines()
out_lines6 = output_file6.readlines()
out_idx1 = 0
out_idx2 = 0
out_idx3 = 0
out_idx4 = 0
out_idx5 = 0
out_idx6 = 0

# for 128 bits
for i in range(len(check_lines1)):
        flag1 = check_lines1[i].split()[0]
        
        correct_hex1 = check_lines1[i].split()[3]
        correct1 = bin(int(correct_hex1,16))[2:]
        for n in range(128-len(correct1)):
                correct1 = "0"+correct1

        correct_hex4 = check_lines1[i].split()[1]
        correct4 = bin(int(correct_hex4,16))[2:]
        for m in range(128-len(correct4)):
                correct4 = "0"+correct4

        if flag1 == '0':
                out1 = out_lines1[out_idx1].split()[0]
                #print(out_idx1)
                if out1 == correct1:
                        result1.write("P\n")
                else:
                        result1.write("F\n")
                out_idx1=out_idx1+1
                
                result4.write("N\n")
        else:
                out4 = out_lines4[out_idx4].split()[0]
                if out4 == correct4:
                        result4.write("P\n")
                else:
                        result4.write("F\n")
                out_idx4=out_idx4+1

                result1.write("N\n")

# for 192 bits
for i in range(len(check_lines2)):
        flag2 = check_lines2[i].split()[0]

        correct_hex2 = check_lines2[i].split()[3]
        correct2 = bin(int(correct_hex2,16))[2:]
        for n in range(128-len(correct2)):
                correct2 = "0"+correct2

        correct_hex5 = check_lines2[i].split()[1]
        correct5 = bin(int(correct_hex5,16))[2:]
        for m in range(128-len(correct5)):
                correct5 = "0"+correct5
        
        if flag2 == '0':
                out2 = out_lines2[out_idx2].split()[0]
                if out2 == correct2:
                        result2.write("P\n")
                else:
                        result2.write("F\n")
                out_idx2=out_idx2+1

                result5.write("N\n")
        else:
                out5 = out_lines5[out_idx5].split()[0]
                if out5 == correct5:
                        result5.write("P\n")
                else:
                        result5.write("F\n")
                out_idx5=out_idx5+1

                result2.write("N\n")

# for 256 bits
for i in range(len(check_lines3)):
        flag3 = check_lines3[i].split()[0]

        correct_hex3 = check_lines3[i].split()[3]
        correct3 = bin(int(correct_hex3,16))[2:]
        for n in range(128-len(correct3)):
                correct3 = "0"+correct3
        
        correct_hex6 = check_lines3[i].split()[1]
        correct6 = bin(int(correct_hex6,16))[2:]
        for m in range(128-len(correct6)):
                correct6 = "0"+correct6

        if flag3 == '0':
                out3 = out_lines3[out_idx3].split()[0]
                if out3 == correct3:
                        result3.write("P\n")
                else:
                        result3.write("F\n")
                out_idx3=out_idx3+1

                result6.write("N\n")
        else:
                out6 = out_lines6[out_idx6].split()[0]
                if out6 == correct6:
                        result6.write("P\n")
                else:
                        result6.write("F\n")
                out_idx6=out_idx6+1

                result3.write("N\n")
