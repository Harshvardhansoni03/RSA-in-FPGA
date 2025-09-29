# 🔐 RSA Algorithm Implementation on FPGA (Nexys-4 DDR)

## 🚀 Project Overview
This project implements the **RSA Cryptographic Algorithm (Encryption and Decryption)** using **Verilog HDL** on a **Xilinx Artix-7 FPGA (Digilent Nexys-4 DDR board)**.  

The main focus is on **hardware acceleration of modular exponentiation (M^e mod n)**, the core operation of RSA public-key cryptography.  

As a real-world application, the **message (M)** used for encryption is the Wi-Fi security key of a pre-defined network.

---

## ✨ Key Features
- **Hardware Acceleration**: Modular exponentiation implemented using the Square-and-Multiply algorithm in hardware (`rsa_core.v`).  
- **Sequential Pipeline**: Encryption and Decryption cores (`rsa_enc` & `rsa_dec`) integrated for full cryptographic flow.  
- **Modular Design**: Parameterized `rsa_core` for scalability to larger key sizes.  
- **Data Pre-processing**: Python script extracts a real Wi-Fi key and generates a synthesizable Verilog ROM (`wifi_key_rom.v`).  
- **Visualization**: Real-time display of plaintext, ciphertext, and decrypted message on the **8-digit 7-segment display**.

---

## 🛠️ Hardware & Tools Requirements
- **FPGA Board**: Digilent Nexys-4 DDR (Xilinx Artix-7 XC7A100T)  
- **Development Environment**: Xilinx Vivado Design Suite (v2020 or later recommended)  
- **Pre-processing Tool**: Python 3.x (for running `gen_wifi_keyrom.py`)  
- **Constraints**: Nexys-4 DDR XDC file (pin assignments for clock, switches, and display)

---

## 🧱 Architecture and Data Flow
The design follows a modular architecture with `top.v` acting as the **controller and pipeline manager**.

### Cryptographic Parameters
| Parameter         | Value                | Description                     |
|-------------------|----------------------|---------------------------------|
| **Key Width**     | 17 bits              | Parameter `WIDTH` in `rsa_core` |
| **Modulus (n)**   | `17'd67591`          | Public/Private modulus          |
| **Public Exp (e)**| `17'd17`             | Used in encryption              |
| **Private Exp (d)**| `17'd47345`          | Used in decryption              |
| **Message**       | `rishit15`           | Wi-Fi key (packed as 64’h7269736869743135) |

