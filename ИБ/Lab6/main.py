import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

# ----------------- Enigma Settings -----------------
rotors = ("BETA", "GAMMA", "V")
reflector = "B"
ringSettings = "LFV"
ringPositions = "LFV"
plugboard = "AY BR CU DH EQ FS GL IP JX KN MO TZ VW"
rotorStep = {"I": 0, "II": 2, "III": 2}



# ---------------------------------------------------

def caesarShift(str, amount):
    output = ""

    for i in range(0, len(str)):
        c = str[i]
        code = ord(c)
        if ((code >= 65) and (code <= 90)):
            c = chr(((code - 65 + amount) % 26) + 65)
        output = output + c

    return output


def encode(plaintext):
    global rotors, reflector, ringSettings, ringPositions, plugboard
    # Enigma Rotors and reflectors
    rotor1 = "LEYJVCNIXWPBQMDRTAKZGFUHOS"
    rotor1Notch = "Q"
    rotor2 = "FSOKANUERHMBTIYCWLQPZXVGJD"
    rotor2Notch = "E"
    rotor3 = "VZBRGITYUPSDNHLXAWMJQOFECK"
    rotor3Notch = "V"

    rotorDict = {"BETA": rotor1, "GAMMA": rotor2, "V": rotor3}
    rotorNotchDict = {"BETA": rotor1Notch, "GAMMA": rotor2Notch, "V": rotor3Notch}

    reflectorB = {"A": "Y", "Y": "A", "B": "R", "R": "B", "C": "U", "U": "C", "D": "H", "H": "D", "E": "Q", "Q": "E",
                  "F": "S", "S": "F", "G": "L", "L": "G", "I": "P", "P": "I", "J": "X", "X": "J", "K": "N", "N": "K",
                  "M": "O", "O": "M", "T": "Z", "Z": "T", "V": "W", "W": "V"}

    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    rotorANotch = False
    rotorBNotch = False
    rotorCNotch = False

    if reflector == "B":
        reflectorDict = reflectorB

    # A = Left,  B = Mid,  C=Right
    rotorA = rotorDict[rotors[0]]
    rotorB = rotorDict[rotors[1]]
    rotorC = rotorDict[rotors[2]]
    rotorANotch = rotorNotchDict[rotors[0]]
    rotorBNotch = rotorNotchDict[rotors[1]]
    rotorCNotch = rotorNotchDict[rotors[2]]

    rotorALetter = ringPositions[0]
    rotorBLetter = ringPositions[1]
    rotorCLetter = ringPositions[2]

    rotorASetting = ringSettings[0]
    offsetASetting = alphabet.index(rotorASetting)
    rotorBSetting = ringSettings[1]
    offsetBSetting = alphabet.index(rotorBSetting)
    rotorCSetting = ringSettings[2]
    offsetCSetting = alphabet.index(rotorCSetting)

    rotorA = caesarShift(rotorA, offsetASetting)
    rotorB = caesarShift(rotorB, offsetBSetting)
    rotorC = caesarShift(rotorC, offsetCSetting)

    if offsetASetting > 0:
        rotorA = rotorA[26 - offsetASetting:] + rotorA[0:26 - offsetASetting]
    if offsetBSetting > 0:
        rotorB = rotorB[26 - offsetBSetting:] + rotorB[0:26 - offsetBSetting]
    if offsetCSetting > 0:
        rotorC = rotorC[26 - offsetCSetting:] + rotorC[0:26 - offsetCSetting]

    ciphertext = ""

    # Converplugboard settings into a dictionary
    plugboardConnections = plugboard.upper().split(" ")
    plugboardDict = {}
    for pair in plugboardConnections:
        if len(pair) == 2:
            plugboardDict[pair[0]] = pair[1]
            plugboardDict[pair[1]] = pair[0]

    plaintext = plaintext.upper()
    for letter in plaintext:
        encryptedLetter = letter

        if letter in alphabet:
            rotorTrigger = False
            # Третий ротор поворачивается на 1 шаг при каждом нажатии клавиши
            if rotorCLetter == rotorCNotch:
                rotorTrigger = True
            rotorCLetter = alphabet[(alphabet.index(rotorCLetter) + 1) % 26]
            # Проверяем, нужно ли вращать ротор B
            if rotorTrigger:
                rotorTrigger = False
                if rotorBLetter == rotorBNotch:
                    rotorTrigger = True
                rotorBLetter = alphabet[(alphabet.index(rotorBLetter) + rotorStep["II"]) % 26]  # Используем rotorStep
                # Проверяем, нужно ли вращать ротор A
                if rotorTrigger:
                    rotorTrigger = False
                    rotorALetter = alphabet[
                        (alphabet.index(rotorALetter) + rotorStep["I"]) % 26]  # Используем rotorStep

            else:
                if rotorBLetter == rotorBNotch:
                    rotorBLetter = alphabet[(alphabet.index(rotorBLetter) + 1) % 26]
                    rotorALetter = alphabet[(alphabet.index(rotorALetter) + 1) % 26]

            # Implement plugboard encryption!
            if letter in plugboardDict.keys():
                if plugboardDict[letter] != "":
                    encryptedLetter = plugboardDict[letter]

            # Rotors & Reflector Encryption
            offsetA = alphabet.index(rotorALetter)
            offsetB = alphabet.index(rotorBLetter)
            offsetC = alphabet.index(rotorCLetter)

            # Wheel 3 Encryption
            pos = alphabet.index(encryptedLetter)
            let = rotorC[(pos + offsetC) % 26]
            pos = alphabet.index(let)
            encryptedLetter = alphabet[(pos - offsetC + 26) % 26]

            # Wheel 2 Encryption
            pos = alphabet.index(encryptedLetter)
            let = rotorB[(pos + offsetB) % 26]
            pos = alphabet.index(let)
            encryptedLetter = alphabet[(pos - offsetB + 26) % 26]

            # Wheel 1 Encryption
            pos = alphabet.index(encryptedLetter)
            let = rotorA[(pos + offsetA) % 26]
            pos = alphabet.index(let)
            encryptedLetter = alphabet[(pos - offsetA + 26) % 26]

            # Reflector encryption!
            if encryptedLetter in reflectorDict.keys():
                if reflectorDict[encryptedLetter] != "":
                    encryptedLetter = reflectorDict[encryptedLetter]

            # Back through the rotors
            # Wheel 1 Encryption
            pos = alphabet.index(encryptedLetter)
            let = alphabet[(pos + offsetA) % 26]
            pos = rotorA.index(let)
            encryptedLetter = alphabet[(pos - offsetA + 26) % 26]

            # Wheel 2 Encryption
            pos = alphabet.index(encryptedLetter)
            let = alphabet[(pos + offsetB) % 26]
            pos = rotorB.index(let)
            encryptedLetter = alphabet[(pos - offsetB + 26) % 26]

            # Wheel 3 Encryption
            pos = alphabet.index(encryptedLetter)
            let = alphabet[(pos + offsetC) % 26]
            pos = rotorC.index(let)
            encryptedLetter = alphabet[(pos - offsetC + 26) % 26]

            # Implement plugboard encryption!
            if encryptedLetter in plugboardDict.keys():
                if plugboardDict[encryptedLetter] != "":
                    encryptedLetter = plugboardDict[encryptedLetter]

        ciphertext = ciphertext + encryptedLetter

    return ciphertext


# Main Program Starts Here
def plot_frequency_histogram(text, title):
    frequency = {}
    for char in text:
        frequency[char] = frequency.get(char, 0) + 1

    total_chars = sum(frequency.values())

    # Построение гистограммы
    plt.bar(frequency.keys(), frequency.values())
    plt.xlabel('Characters')
    plt.ylabel('Frequency')
    plt.title(title)
    plt.show()


print("  ##### Enigma Encoder #####")
plaintext = input("Enter text to encode or decode:\n")

# with open('input.txt', 'r', encoding='utf-8') as file:
#     plaintext = file.read()

print("\nOriginal text: \n " + plaintext)
plot_frequency_histogram(plaintext, "Frequency Histogram of Original Text")

encrypted_text = encode(plaintext)

print("\nEncoded text: \n " + encrypted_text)
plot_frequency_histogram(encrypted_text, "Frequency Histogram of Encoded Text")

decrypted_text = encode(encrypted_text)

print("\nDecoded text: \n " + decrypted_text)