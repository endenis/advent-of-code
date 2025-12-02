#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <sstream>
#include <string_view>
#include <set>

using namespace std;

typedef unsigned long long ull;

pair<ull, ull> parse_range(string s) {
    ull pos = s.find('-');
    if (pos == string::npos)
        throw runtime_error("Missing - in range");

    string start_string = s.substr(0, pos);
    string end_string = s.substr(pos + 1);

    ull start_int = stoull(start_string);
    ull end_int = stoull(end_string);

    return { start_int, end_int };
}

vector<pair<ull, ull>> parse_input_file(string filename, bool verbose) {
    vector<pair<ull, ull>> ranges;

    ifstream inFile(filename);
    if (!inFile)
        throw runtime_error("Unable to open input file");

    string input_line;
    getline(inFile, input_line);

    if (verbose)
        std::cout << input_line << endl << endl;

    stringstream input_line_stream(input_line);
    string range_string;

    while (getline(input_line_stream, range_string, ',')) {
        auto pair = parse_range(range_string);
        ranges.push_back(pair);
    }

    inFile.close();
    return ranges;
}

void part1(string filename, bool verbose) {
    ull result = 0;
    vector<pair<ull, ull>> ranges = parse_input_file(filename, verbose);
    vector<ull> matching_numbers;

    for (pair<ull, ull> range : ranges) {
        if (verbose)
            std::cout << range.first << " - " << range.second << endl;

        for (auto n = range.first; n <= range.second; n++) {
            auto n_string = to_string(n);
            size_t n_digits = n_string.length();
            if (n_digits % 2)
                continue; // not interested in numbers that have odd number of digits


            auto half_digits = n_digits / 2;

            if (n_string.substr(0, half_digits) == n_string.substr(half_digits))
                matching_numbers.push_back(n);
        }
    }

    if (verbose)
        std::cout << "Matching numbers:" << endl;

    for (auto& match : matching_numbers) {
        if (verbose)
            std::cout << match << endl;

        result += match;
    }

    std::cout << "Part 1 result: " << result << endl;
}

void part2(string filename, bool verbose) {
    ull result = 0;
    vector<pair<ull, ull>> ranges = parse_input_file(filename, verbose);
    set<ull> matching_numbers; // Using a set here to avoid repeating numbers

    for (pair<ull, ull> range : ranges) {
        if (verbose)
            std::cout << range.first << " - " << range.second << endl;

        for (auto n = range.first; n <= range.second; n++) {
            auto n_string = to_string(n);
            size_t n_digits = n_string.length();

            for (size_t block_size = 1; block_size <= n_digits / 2; block_size++) {
                if (n_digits % block_size != 0)
                    continue;

                size_t number_of_blocks = n_digits / block_size;

                auto block = n_string.substr(0, block_size);
                string buffer;

                for (size_t i = 0; i < number_of_blocks; i++)
                    buffer.append(block);

                if (buffer == n_string)
                    matching_numbers.insert(n);

            }
        }
    }

    if (verbose)
        std::cout << "Matching numbers:" << endl;

    for (auto& match : matching_numbers) {
        if (verbose)
            std::cout << match << endl;

        result += match;
    }

    std::cout << "Part 2 result: " << result << endl;
}

int main() {
    auto filename = "input.2.run.txt";
    bool verbose = false;

    part1(filename, verbose);
    part2(filename, verbose);
    return 0;
}
