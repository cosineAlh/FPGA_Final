# Final Project Report - AES Secure System Design
AnLH 2018531021

## I. Introduction
The Advanced Encryption Standard (AES), also known as Rijndael, is a block cipher adopted as an encryption standard by the US government. The cipher was developed by two Belgian cryptographers, Joan Daemen and Vincent Rijmen, and submitted to the AES selection process under the name "Rijndael", a portmanteau comprised of the names of the inventors.

AES has a fixed block size of 128 bits and a key size of 128, 192 or 256 bits, whereas Rijndael can be specified with key and block sizes in any multiple of 32 bits, with a minimum of 128 bits and a maximum of 256 bits. AES operates on a 4×4 array of bytes. AES algorithm comprises of various rounds depending on the key size and blck size.
| Key bits | Number of Rounds|
| :----: | :----: |
| 128 bits | 10 |
| 192 bits | 12 |
| 256 bits | 14 |

In this project I have finished **AED-Encryption for 128/192/256 bits**, **AES-Decryption for 128/192/256 bits**. In addition, for encryption part, I realise pipeline architechture and effictively shorten the running time and improve the efficiency.

## II. Encryption Part
For encryption, each round of AES (except the last round) consists of four stages:
- SubBytes - a non-linear substitution step where each byte is replaced with another according to a lookup table (known as S-Box). 
- ShiftRows - a transposition step where each row of the state is shifted cyclically a certain number of steps. 
- MixColumns - a mixing operation which operates on the columns of the state, combining the four bytes in each column using a linear transformation. 
- AddRoundKey - each byte of the state is combined with the round key; each round key is derived from the cipher key using a key schedule.
  

### A. Architechture (Pipeline)
For encryption part, I use pipeline (see the attachment "System_Block_Diagram").

In pipelining, registers are inserted between each combinational processing element, so that each input data block can be processed simultaneously in each processing element. 

For example, the number of rounds of AES-128 encryption is 10, and the architecture of this cipher is fully pipelined, when all data blocks of 10 rounds can be processed simultaneously. For a fully pipelined implementation of AES-128, ten 128-bit data registers are needed. Therefore the next plaintext must be entered after 10 clock cycles, in each clock cycle one new plaintext can be entered to the process of encryption. However,fully pipelined architecture offer the **highest performance**, it use **more area and resources**. 

To implement pipeline, I use a **Controller** to control the rounds of keys, then use **Key** and **RoundKey** to generate key schedule. Instead of waiting for all the round keys are generated, once a round key is generated, it will be send to the part **AddRoundKey** and begin to work while the next round key is generating at the same time.

After the key expansion is over, now encryption process begins.Once the pre round(round 0) is over then the remaining rounds processed in the following manner:

- First, the data from the intermediate register is read and applied to four 4x1 (32 bits) Mux from where the selected data is feed to the input of S-box. This will transform the data to their corresponding transformed data and pass it to Mix Column.
- The Mix column stage gets these 32 bits of data and according to the algorithm multiplies the data with a standard matrix to produce a 32 bit output. 
- This output is applied to the Add Round Key which also has the 32 bits input from the key memory. These two 32 bits inputs are XORed in this module and are get stored in the intermediate Register Bank again for the next round.

In this way, all the four column of the new intermediate matrix are obtained one after the other keeping all the modules of the design busy all the time. 

The proper selection of the module is done by the **Controller**. This Controller also controls the Key Scheduling.

### B. Result
All behav simulation and post-synthesis timing is completed.

utilization_synth report

```
1. Slice Logic
--------------

+-------------------------+------+-------+-----------+-------+
|        Site Type        | Used | Fixed | Available | Util% |
+-------------------------+------+-------+-----------+-------+
| Slice LUTs*             | 1055 |     0 |     53200 |  1.98 |
|   LUT as Logic          | 1055 |     0 |     53200 |  1.98 |
|   LUT as Memory         |    0 |     0 |     17400 |  0.00 |
| Slice Registers         |  264 |     0 |    106400 |  0.25 |
|   Register as Flip Flop |  264 |     0 |    106400 |  0.25 |
|   Register as Latch     |    0 |     0 |    106400 |  0.00 |
| F7 Muxes                |  256 |     0 |     26600 |  0.96 |
| F8 Muxes                |  128 |     0 |     13300 |  0.96 |
+-------------------------+------+-------+-----------+-------+

2. Memory
---------

+-------------------+------+-------+-----------+-------+
|     Site Type     | Used | Fixed | Available | Util% |
+-------------------+------+-------+-----------+-------+
| Block RAM Tile    |    1 |     0 |       140 |  0.71 |
|   RAMB36/FIFO*    |    0 |     0 |       140 |  0.00 |
|   RAMB18          |    2 |     0 |       280 |  0.71 |
|     RAMB18E1 only |    2 |       |           |       |
+-------------------+------+-------+-----------+-------+

3. DSP
------

+-----------+------+-------+-----------+-------+
| Site Type | Used | Fixed | Available | Util% |
+-----------+------+-------+-----------+-------+
| DSPs      |    0 |     0 |       220 |  0.00 |
+-----------+------+-------+-----------+-------+

4. IO and GT Specific
---------------------

+-----------------------------+------+-------+-----------+--------+
|          Site Type          | Used | Fixed | Available |  Util% |
+-----------------------------+------+-------+-----------+--------+
| Bonded IOB                  |  387 |     0 |       200 | 193.50 |
+-----------------------------+------+-------+-----------+--------+

5. Clocking
-----------

+------------+------+-------+-----------+-------+
|  Site Type | Used | Fixed | Available | Util% |
+------------+------+-------+-----------+-------+
| BUFGCTRL   |    1 |     0 |        32 |  3.13 |
| BUFIO      |    0 |     0 |        16 |  0.00 |
| MMCME2_ADV |    0 |     0 |         4 |  0.00 |
| PLLE2_ADV  |    0 |     0 |         4 |  0.00 |
| BUFMRCE    |    0 |     0 |         8 |  0.00 |
| BUFHCE     |    0 |     0 |        72 |  0.00 |
| BUFR       |    0 |     0 |        16 |  0.00 |
+------------+------+-------+-----------+-------+

6. Specific Feature
-------------------

+-------------+------+-------+-----------+-------+
|  Site Type  | Used | Fixed | Available | Util% |
+-------------+------+-------+-----------+-------+
| BSCANE2     |    0 |     0 |         4 |  0.00 |
| CAPTUREE2   |    0 |     0 |         1 |  0.00 |
| DNA_PORT    |    0 |     0 |         1 |  0.00 |
| EFUSE_USR   |    0 |     0 |         1 |  0.00 |
| FRAME_ECCE2 |    0 |     0 |         1 |  0.00 |
| ICAPE2      |    0 |     0 |         2 |  0.00 |
| STARTUPE2   |    0 |     0 |         1 |  0.00 |
| XADC        |    0 |     0 |         1 |  0.00 |
+-------------+------+-------+-----------+-------+

7. Primitives
-------------

+----------+------+---------------------+
| Ref Name | Used | Functional Category |
+----------+------+---------------------+
| LUT6     |  623 |                 LUT |
| FDRE     |  263 |        Flop & Latch |
| IBUF     |  258 |                  IO |
| MUXF7    |  256 |               MuxFx |
| LUT5     |  197 |                 LUT |
| LUT2     |  156 |                 LUT |
| OBUF     |  129 |                  IO |
| MUXF8    |  128 |               MuxFx |
| LUT4     |   94 |                 LUT |
| LUT3     |   30 |                 LUT |
| RAMB18E1 |    2 |        Block Memory |
| LUT1     |    1 |                 LUT |
| FDSE     |    1 |        Flop & Latch |
| BUFG     |    1 |               Clock |
+----------+------+---------------------+
```

## III. Decryption
In order to implement the decryption algorithm of AES-128, must invert the SubBytes, ShiftRows, and MixColumns operations.

### A. Architechture
For a given key, the subkeys must be used in reverse order to decrypt a ciphertext. Therefore a different keyschedule algorithm is needed, subkeys should be obtained in reverse order. 

And for this part, I do not use pipeline architechture for key expansion, because it is hard to realise...(see "System_Block_Diagram")

### B. Result
All behav simulation and post-synthesis timing is completed.

utilization_synth report
```
1. Slice Logic
--------------

+-------------------------+-------+-------+-----------+-------+
|        Site Type        |  Used | Fixed | Available | Util% |
+-------------------------+-------+-------+-----------+-------+
| Slice LUTs*             | 10981 |     0 |     53200 | 20.64 |
|   LUT as Logic          | 10981 |     0 |     53200 | 20.64 |
|   LUT as Memory         |     0 |     0 |     17400 |  0.00 |
| Slice Registers         |   161 |     0 |    106400 |  0.15 |
|   Register as Flip Flop |   161 |     0 |    106400 |  0.15 |
|   Register as Latch     |     0 |     0 |    106400 |  0.00 |
| F7 Muxes                |  2732 |     0 |     26600 | 10.27 |
| F8 Muxes                |  1324 |     0 |     13300 |  9.95 |
+-------------------------+-------+-------+-----------+-------+

2. Memory
---------

+----------------+------+-------+-----------+-------+
|    Site Type   | Used | Fixed | Available | Util% |
+----------------+------+-------+-----------+-------+
| Block RAM Tile |    0 |     0 |       140 |  0.00 |
|   RAMB36/FIFO* |    0 |     0 |       140 |  0.00 |
|   RAMB18       |    0 |     0 |       280 |  0.00 |
+----------------+------+-------+-----------+-------+

3. DSP
------

+-----------+------+-------+-----------+-------+
| Site Type | Used | Fixed | Available | Util% |
+-----------+------+-------+-----------+-------+
| DSPs      |    0 |     0 |       220 |  0.00 |
+-----------+------+-------+-----------+-------+

4. IO and GT Specific
---------------------

+-----------------------------+------+-------+-----------+--------+
|          Site Type          | Used | Fixed | Available |  Util% |
+-----------------------------+------+-------+-----------+--------+
| Bonded IOB                  |  387 |     0 |       200 | 193.50 |
+-----------------------------+------+-------+-----------+--------+

5. Clocking
-----------

+------------+------+-------+-----------+-------+
|  Site Type | Used | Fixed | Available | Util% |
+------------+------+-------+-----------+-------+
| BUFGCTRL   |    1 |     0 |        32 |  3.13 |
| BUFIO      |    0 |     0 |        16 |  0.00 |
| MMCME2_ADV |    0 |     0 |         4 |  0.00 |
| PLLE2_ADV  |    0 |     0 |         4 |  0.00 |
| BUFMRCE    |    0 |     0 |         8 |  0.00 |
| BUFHCE     |    0 |     0 |        72 |  0.00 |
| BUFR       |    0 |     0 |        16 |  0.00 |
+------------+------+-------+-----------+-------+

6. Specific Feature
-------------------

+-------------+------+-------+-----------+-------+
|  Site Type  | Used | Fixed | Available | Util% |
+-------------+------+-------+-----------+-------+
| BSCANE2     |    0 |     0 |         4 |  0.00 |
| CAPTUREE2   |    0 |     0 |         1 |  0.00 |
| DNA_PORT    |    0 |     0 |         1 |  0.00 |
| EFUSE_USR   |    0 |     0 |         1 |  0.00 |
| FRAME_ECCE2 |    0 |     0 |         1 |  0.00 |
| ICAPE2      |    0 |     0 |         2 |  0.00 |
| STARTUPE2   |    0 |     0 |         1 |  0.00 |
| XADC        |    0 |     0 |         1 |  0.00 |
+-------------+------+-------+-----------+-------+

7. Primitives
-------------

+----------+------+---------------------+
| Ref Name | Used | Functional Category |
+----------+------+---------------------+
| LUT6     | 8595 |                 LUT |
| MUXF7    | 2732 |               MuxFx |
| LUT2     | 1405 |                 LUT |
| MUXF8    | 1324 |               MuxFx |
| LUT5     |  706 |                 LUT |
| LUT4     |  579 |                 LUT |
| LUT3     |  364 |                 LUT |
| IBUF     |  258 |                  IO |
| FDCE     |  161 |        Flop & Latch |
| OBUF     |  129 |                  IO |
| CARRY4   |    8 |          CarryLogic |
| LUT1     |    2 |                 LUT |
| BUFG     |    1 |               Clock |
+----------+------+---------------------+

```
## IV. Other Operations

### A. init . py
I use init . py to change input file from hex to binary, the output files are named by **input_xxx** and **input_xxxD**, xxx means bits.

### B. test . py
I use test . py to compare the output file from testbench with reference result, and output the comparing result to files named by **AES_results_xx**, xx means encryption or decryption.

### C. testE . sh/testD . sh
These two shell code is to call ghdl to run vhdl codes.

### D. grade . py
The main function to call all programs above in order.

## V. References
[1] "FPGA Implementation of AES Encryption and Decryption".Sounak Samanta B.E. III Yr, Electronics & Communication Engg,Sardar Vallabhbhai National Institute of Technology, Surat.