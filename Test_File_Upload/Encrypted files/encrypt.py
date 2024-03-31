from cryptography.fernet import Fernet

# Generate a key using:
key = Fernet.generate_key()
def encrypt_file(filename, key):
    with open(filename, 'rb') as file:
        data = file.read()

   # key = Fernet.generate_key()
    fernet = Fernet(key)
    encrypted_data = fernet.encrypt(data)

    with open(filename + '.encrypted', 'wb') as file:
        file.write(encrypted_data)


# Replace 'your_file.txt' with the name of your file and 'your_key_here' with your generated key
encData = encrypt_file('TestMedical.sol', key)

print("encrypted Data: ", encData)
print("key: ", key)