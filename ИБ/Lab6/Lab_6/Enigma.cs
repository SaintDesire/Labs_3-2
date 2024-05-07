using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab_6
{
    public class Enigma
    {
        const string openAlphabet = "abcdefghijklmnopqrstuvwxyz";
        Dictionary<char, char> reflectorAlphabet;
        int alphabetLength = openAlphabet.Length;

        string rightRotorAlphabet = "vzbrgityupsdnhlxawmjqofeck";
        string middleRotorAlphabet = "fsokanuerhmbtiycwlqpzxvgjd";
        string leftRotorAlphabet = "leyjvcnixwpbqmdrtakzgfuhos";

        int currentPositionRightRotor = 0;
        int currentPositionMiddleRotor = 0;
        int currentPositionLeftRotor = 0;

        int totalOffsetsRightRotor = 0;
        int totalOffsetsMiddleRotor = 0;
        int totalOffsetsLeftRotor = 0;

        int fullRotationsRightRotor = 0;
        int fullRotationsMiddleRotor = 0;
        int fullRotationsLeftRotor = 0;

        int stepRightRotor = 2;
        int stepMiddleRotor = 2;
        int stepLeftRotor = 0;

        public Enigma(int positionRightRotor, int positionMiddleRotor, int positionLeftRotor)
        {
            if (positionRightRotor >= 0 && positionRightRotor < alphabetLength &&
                positionMiddleRotor >= 0 && positionMiddleRotor < alphabetLength &&
                positionLeftRotor >= 0 && positionLeftRotor < alphabetLength)
            {
                currentPositionRightRotor = positionRightRotor;
                currentPositionMiddleRotor = positionMiddleRotor;
                currentPositionLeftRotor = positionLeftRotor;
            }
            else
            {
                throw new Exception($"Positions of rotors must be between 0 and {alphabetLength - 1}");
            }
            reflectorAlphabet = FillTheRelector();
        }

        public char[] Encrypt(char[] plainText)
        {
            // Если роторы установлены в ненулевое начальное положение,
            // тогда необходимо взять общее количество сдвигов
            // равное текущему положению (необходимо для расчетов ниже)
            totalOffsetsRightRotor = currentPositionRightRotor;
            totalOffsetsMiddleRotor = currentPositionMiddleRotor;
            totalOffsetsLeftRotor = currentPositionLeftRotor;
            var result = new System.Text.StringBuilder();

            foreach (char symbol in plainText)
            {
                if (openAlphabet.Contains(symbol))
                {
                    // 1. Заменяем символ на символ из правого ротора
                    var symbolAfterRightRotor = EncryptWithRotor(symbol, openAlphabet, rightRotorAlphabet, currentPositionRightRotor);

                    // 2. Заменяем символ на символ из среднего ротора
                    var symbolAfterMiddleRotor = EncryptWithRotor(symbolAfterRightRotor, openAlphabet, middleRotorAlphabet, currentPositionMiddleRotor);

                    // 3. Заменяем символ на символ из левого ротора
                    var symbolAfterLeftRotor = EncryptWithRotor(symbolAfterMiddleRotor, openAlphabet, leftRotorAlphabet, currentPositionLeftRotor);

                    // 4. Заменяем символ на символ из рефлектора
                    var symbolAfterReflector = EncryptWithReflector(symbolAfterLeftRotor);

                    // 5. Заменяем символ на символ левого ротора в обратном порядке
                    var symbolAfterLeftRotorBackwards = EncryptWithRotor(symbolAfterReflector, leftRotorAlphabet, openAlphabet, currentPositionLeftRotor);

                    // 6. Заменяем символ на символ среднего ротора в обратном порядке
                    var symbolAfterMiddleRotorBackwards = EncryptWithRotor(symbolAfterLeftRotorBackwards, middleRotorAlphabet, openAlphabet, currentPositionMiddleRotor);

                    // 7. Заменяем символ на символ правого ротора в обратном порядке
                    var symbolAfterRightRotorBackwards = EncryptWithRotor(symbolAfterMiddleRotorBackwards, rightRotorAlphabet, openAlphabet, currentPositionRightRotor);

                    // 8. Сдвигаем правый ротор
                    totalOffsetsRightRotor += stepRightRotor;
                    currentPositionRightRotor = totalOffsetsRightRotor % alphabetLength;   // Сдвигаем правый ротор

                    // 9. Сдвигаем средний и левый роторы
                    if (totalOffsetsRightRotor / alphabetLength > 0)
                    {
                        fullRotationsRightRotor = totalOffsetsRightRotor / alphabetLength;
                        totalOffsetsMiddleRotor = fullRotationsRightRotor * stepMiddleRotor;
                        currentPositionMiddleRotor = totalOffsetsMiddleRotor % alphabetLength;
                    }
                    if (totalOffsetsMiddleRotor / alphabetLength > 0)
                    {
                        fullRotationsMiddleRotor = totalOffsetsMiddleRotor / alphabetLength;
                        totalOffsetsLeftRotor = fullRotationsMiddleRotor * stepLeftRotor;
                        currentPositionLeftRotor = totalOffsetsLeftRotor % alphabetLength;
                    }
                    if (totalOffsetsLeftRotor / alphabetLength > 0)
                    {
                        fullRotationsLeftRotor = totalOffsetsLeftRotor / alphabetLength;
                    }

                    // 10. Записываем символ в результат
                    result.Append(symbolAfterRightRotorBackwards);
                }
                else
                    result.Append(symbol);
            }
            return result.ToString().ToCharArray();
        }

        public char[] Decrypt(char[] cipherText)
        {
            totalOffsetsRightRotor = currentPositionRightRotor;
            totalOffsetsMiddleRotor = currentPositionMiddleRotor;
            totalOffsetsLeftRotor = currentPositionLeftRotor;
            var result = new StringBuilder();

            foreach (char symbol in cipherText)
            {
                if (openAlphabet.Contains(symbol))
                {
                    var symbolAfterRightRotor = DecryptWithRotor(symbol, openAlphabet, rightRotorAlphabet, currentPositionRightRotor);
                    var symbolAfterMiddleRotor = DecryptWithRotor(symbolAfterRightRotor, openAlphabet, middleRotorAlphabet, currentPositionMiddleRotor);
                    var symbolAfterLeftRotor = DecryptWithRotor(symbolAfterMiddleRotor, openAlphabet, leftRotorAlphabet, currentPositionLeftRotor);
                    var symbolAfterReflector = EncryptWithReflector(symbolAfterLeftRotor);
                    var symbolAfterLeftRotorBackwards = DecryptWithRotor(symbolAfterReflector, leftRotorAlphabet, openAlphabet, currentPositionLeftRotor);
                    var symbolAfterMiddleRotorBackwards = DecryptWithRotor(symbolAfterLeftRotorBackwards, middleRotorAlphabet, openAlphabet, currentPositionMiddleRotor);
                    var symbolAfterRightRotorBackwards = DecryptWithRotor(symbolAfterMiddleRotorBackwards, rightRotorAlphabet, openAlphabet, currentPositionRightRotor);

                    totalOffsetsRightRotor += stepRightRotor;
                    currentPositionRightRotor = totalOffsetsRightRotor % alphabetLength;

                    if (totalOffsetsRightRotor / alphabetLength > 0)
                    {
                        fullRotationsRightRotor = totalOffsetsRightRotor / alphabetLength;
                        totalOffsetsMiddleRotor = fullRotationsRightRotor * stepMiddleRotor;
                        currentPositionMiddleRotor = totalOffsetsMiddleRotor % alphabetLength;
                    }
                    if (totalOffsetsMiddleRotor / alphabetLength > 0)
                    {
                        fullRotationsMiddleRotor = totalOffsetsMiddleRotor / alphabetLength;
                        totalOffsetsLeftRotor = fullRotationsMiddleRotor * stepLeftRotor;
                        currentPositionLeftRotor = totalOffsetsLeftRotor % alphabetLength;
                    }
                    if (totalOffsetsLeftRotor / alphabetLength > 0)
                    {
                        fullRotationsLeftRotor = totalOffsetsLeftRotor / alphabetLength;
                    }

                    result.Append(symbolAfterRightRotorBackwards);
                }
                else
                    result.Append(symbol);
            }
            return result.ToString().ToCharArray();
        }

        private char EncryptWithRotor(char symbol, string alphabet, string alphabetEncryption, int offset)
        {
            var index = alphabet.IndexOf(symbol);
            var indexEncrypted = (index + offset) % alphabetLength;
            var letterEncrypted = alphabetEncryption[indexEncrypted];
            return letterEncrypted;
        }

        private char DecryptWithRotor(char symbol, string alphabet, string alphabetEncryption, int offset)
        {
            var index = alphabet.IndexOf(symbol);
            var indexEncrypted = (index - offset + alphabetLength) % alphabetLength;
            var letterEncrypted = alphabetEncryption[indexEncrypted];
            return letterEncrypted;
        }

        private char EncryptWithReflector(char symbol)
        {
            if (reflectorAlphabet.ContainsKey(symbol))
                return reflectorAlphabet[symbol];
            else if (reflectorAlphabet.ContainsValue(symbol))
                return reflectorAlphabet.FirstOrDefault(x => x.Value == symbol).Key;
            else
                return symbol;
        }


        private Dictionary<char, char> FillTheRelector() => new Dictionary<char, char>
    {
        { 'a', 'e' }, { 'b', 'n' }, { 'c', 'k' }, { 'd', 'q' }, { 'f', 'u' },
        { 'g', 'y' }, { 'h', 'w' }, { 'i', 'j' }, { 'l', 'o' }, { 'm', 'p' },
        { 'r', 'x' }, { 's', 'z' }, { 't', 'v' }
    };
    }
}
