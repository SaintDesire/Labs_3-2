#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <algorithm>
#include <numeric>
#include <bitset> 

double calculate_entropy(const std::vector<int>& frequencies) {
    double total_count = std::accumulate(frequencies.begin(), frequencies.end(), 0);
    double entropy = 0;
    for (int freq : frequencies) {
        if (freq != 0) {
            double probability = freq / total_count;
            entropy -= probability * log2(probability);
        }
    }
    return entropy;
}

std::string load_text_file(const std::string& filename) {
    std::ifstream file(filename);
    std::string text((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
    return text;
}

std::vector<unsigned char> text_to_binary(const std::string& text) {
    std::vector<unsigned char> binary_data(text.begin(), text.end());
    return binary_data;
}

void write_binary_file(const std::string& filename, const std::vector<unsigned char>& binary_data) {
    std::ofstream file(filename, std::ios::out | std::ios::binary);
    file.write(reinterpret_cast<const char*>(binary_data.data()), binary_data.size());
}

std::vector<unsigned char> load_binary_file(const std::string& filename) {
    std::ifstream file(filename, std::ios::binary);
    std::vector<unsigned char> content((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
    return content;
}

double effective_entropy(double p, double q, bool binary) {
    if (binary && (p == 0 || q == 0)) {
        return 1;
    }
    if (!binary) {
        return 0;
    }
    return 1 - ((-p * log2(p)) - (q * log2(q)));
}

double amount_info_with_error(double entropy, double p, double q, int count, bool binary) {
    return entropy * effective_entropy(p, q, binary) * count;
}

int main() {
    setlocale(LC_ALL, "rus");

    // Задание 1
    std::string macedonian_text = load_text_file("makedon.txt");
    std::string turkish_text = load_text_file("turkey.txt");

    // Определение алфавитов для македонского и турецкого языков
    std::string macedonian_alphabet = "абвгдѓежзѕијклљмнњопрстќуфхцчџш";
    std::string turkish_alphabet = "abcçdefgğhıijklmnoöprsştuüvyz";

    // Анализ текста и расчет энтропии
    std::vector<int> macedonian_frequencies(macedonian_alphabet.size());
    for (char c : macedonian_text) {
        auto it = std::find(macedonian_alphabet.begin(), macedonian_alphabet.end(), c);
        if (it != macedonian_alphabet.end()) {
            int index = std::distance(macedonian_alphabet.begin(), it);
            macedonian_frequencies[index]++;
        }
    }
    double macedonian_entropy = calculate_entropy(macedonian_frequencies);
    std::cout << "Энтропия македонского текста: " << macedonian_entropy << std::endl;

    std::vector<int> turkish_frequencies(turkish_alphabet.size());
    for (char c : turkish_text) {
        auto it = std::find(turkish_alphabet.begin(), turkish_alphabet.end(), c);
        if (it != turkish_alphabet.end()) {
            int index = std::distance(turkish_alphabet.begin(), it);
            turkish_frequencies[index]++;
        }
    }
    double turkish_entropy = calculate_entropy(turkish_frequencies);
    std::cout << "Энтропия турецкого текста: " << turkish_entropy << std::endl;



    // Задание 2
    std::vector<unsigned char> macedonian_binary_data = text_to_binary(macedonian_text);
    std::vector<unsigned char> turkish_binary_data = text_to_binary(turkish_text);

    write_binary_file("macedonian.bin", macedonian_binary_data);
    write_binary_file("turkish.bin", turkish_binary_data);

    // Загрузка бинарных файлов
    macedonian_binary_data = load_binary_file("macedonian.bin");
    turkish_binary_data = load_binary_file("turkish.bin");

    // Расчет частот и энтропии
    std::vector<int> macedonian_binary_frequencies(256, 0);
    for (unsigned char c : macedonian_binary_data) {
        macedonian_binary_frequencies[c]++;
    }
    double macedonian_binary_entropy = calculate_entropy(macedonian_binary_frequencies);
    std::cout << "Энтропия македонского бинарного алфавита: " << macedonian_binary_entropy << std::endl;

    std::vector<int> turkish_binary_frequencies(256, 0);
    for (unsigned char c : turkish_binary_data) {
        turkish_binary_frequencies[c]++;
    }
    double turkish_binary_entropy = calculate_entropy(turkish_binary_frequencies);
    std::cout << "Энтропия турецкого бинарного алфавита: " << turkish_binary_entropy << std::endl;



    // Задание 3
    std::string FIO_macedonian_text = "Коршун Никита Игоревич";
    std::string FIO_turkish_text = "Korşun Nikita İgoreviç";
    std::string binary_FIO;
    for (char c : FIO_macedonian_text) {
        binary_FIO += std::bitset<8>(c).to_string();
    }
    double binary_entropy = calculate_entropy({ (int)std::count(binary_FIO.begin(), binary_FIO.end(), '0'),
                                                (int)std::count(binary_FIO.begin(), binary_FIO.end(), '1') });
    std::cout << "Количество информации на основе македонского сообщения: " << macedonian_entropy * FIO_macedonian_text.length() << std::endl;
    std::cout << "Количество информации на основе турецкого сообщения: " << turkish_entropy * FIO_turkish_text.length() << std::endl;
    std::cout << "Количество информации на основе бинарного сообщения: " << binary_entropy * binary_FIO.length() << std::endl;
    std::cout << "Бинарная энтропия: " << binary_entropy << std::endl;



    // Задание 4
    std::vector<double> error_probabilities = { 0.1, 0.5, 1.0 };

    for (double p : error_probabilities) {
        double q = 1 - p;
        double macedonian_conditional_entropy = (p != 1 && p != 0) ? -p * log2(p) - q * log2(q) : 0;
        double turkish_conditional_entropy = (p != 1 && p != 0) ? -p * log2(p) - q * log2(q) : 0;
        double binary_conditional_entropy = (p != 1 && p != 0) ? -p * log2(p) - q * log2(q) : 0;

        double macedonian_efficiency_entropy = 1 - macedonian_conditional_entropy;
        double turkish_efficiency_entropy = 1 - turkish_conditional_entropy;
        double binary_efficiency_entropy = 1 - binary_conditional_entropy;

        double macedonian_info_with_error = amount_info_with_error(macedonian_efficiency_entropy, p, 1 - p, FIO_macedonian_text.length(), false);
        double turkish_info_with_error = amount_info_with_error(turkish_efficiency_entropy, p, 1 - p, FIO_turkish_text.length(), false);
        double binary_info_with_error = amount_info_with_error(binary_efficiency_entropy, p, 1 - p, binary_FIO.length(), true);

        std::cout << "\nВероятность ошибки: " << p << std::endl;
        std::cout << "Информационное количество с учетом ошибки на основе македонского сообщения: " << macedonian_info_with_error << std::endl;
        std::cout << "Информационное количество с учетом ошибки на основе турецкого сообщения: " << turkish_info_with_error << std::endl;
        std::cout << "Информационное количество с учетом ошибки на основе бинарного представления ФИО: " << binary_info_with_error << std::endl;
    }

    return 0;
}
