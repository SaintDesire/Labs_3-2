using System;
using System.Collections.Generic;
using System.Linq;

namespace Lab_6
{
    public class Program
    {
        static void Main(string[] args)
        {
            try
            {
                var folderPath = "C:\\Users\\p1v0var\\Desktop\\labs_3-2\\ИБ\\Lab6\\Data\\";
                var startFileName = "input.txt";

                var enigmaEncrypt = new Enigma(0, 0, 0);
                var enigmaDecrypt = new Enigma(0, 0, 0);

                var startText = "aa";

                //reading from start file
                //using (var sr = new StreamReader(folderPath + startFileName))
                //{
                //    startText = sr.ReadToEnd();
                //}

                //encrypt text
                var encryptedMessage = enigmaEncrypt.Encrypt(startText.ToLower().ToCharArray());
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("Encrypt Enigma:\n" + string.Join("", encryptedMessage));

                //decrypt text
                var decryptedMessage = enigmaDecrypt.Decrypt(encryptedMessage);
                Console.ForegroundColor = ConsoleColor.Blue;
                Console.WriteLine("\n\nDecrypt Enigma:\n" + string.Join("", decryptedMessage));

                // Counting character frequencies
                var characterFrequencies = CountCharacterFrequencies(startText);
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine("\nCharacter Frequencies:");
                foreach (var entry in characterFrequencies)
                {
                    Console.WriteLine($"{entry.Key}: {entry.Value}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] {ex.Message}");
            }
        }

        static Dictionary<char, int> CountCharacterFrequencies(string text)
        {
            var frequencies = new Dictionary<char, int>();

            foreach (char c in text)
            {
                if (char.IsLetter(c)) // Consider only letters, you can adjust this condition as needed
                {
                    if (frequencies.ContainsKey(c))
                    {
                        frequencies[c]++;
                    }
                    else
                    {
                        frequencies[c] = 1;
                    }
                }
            }

            return frequencies;
        }
    }
}
