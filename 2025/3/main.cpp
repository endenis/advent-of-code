#include <iostream>
#include <string>
#include <fstream>
#include <vector>

using namespace std;

vector<vector<int>> parse_input_file(string filename) {
    vector<vector<int>> parsed_data;

    ifstream inFile(filename);

    if (!inFile)
        throw runtime_error("Unable to open input file");

    std::string line;
    while (getline(inFile, line)) {
        vector<int> line_vector;

        for (char c : line) {
            int joltage = atoi(&c);
            line_vector.push_back(joltage);
        }
        parsed_data.push_back(line_vector);
    }

    inFile.close();
    return parsed_data;
}

void part1(string filename, bool verbose) {
    int result = 0;
    vector<vector<int>> data = parse_input_file(filename);

    for (auto& line : data) {
        int max = -1;
        int pos = -1;
        auto length = line.size();

        for (int i = 0; i < length; i++) {
            if (line[i] > max) {
                max = line[i];
                pos = i;
            }
        }

        int second_max = -1;
        int second_pos = -1;
        int line_result = 0;

        if (pos == length - 1) {
            for (int i = pos - 1; i >= 0; i--) {
                if (line[i] > second_max) {
                    second_max = line[i];
                    second_pos = i;
                }
            }
            line_result = second_max * 10 + max;
        }
        else {
            for (int i = pos + 1; i < length; i++) {
                if (line[i] > second_max) {
                    second_max = line[i];
                    second_pos = i;
                }
            }
            line_result = max * 10 + second_max;
        }

        if (verbose)
            cout << "line_result = " << line_result << endl;

        result += line_result;
    }

    cout << "Part 1 result: " << result << endl;
}

void part2(string filename, bool verbose) {
    unsigned long long result = 0;
    vector<vector<int>> data = parse_input_file(filename);

    for (auto& line : data) {
        unsigned long long line_result = 0;
        auto length = line.size();
        int pos = -1;

        for (int n = 12; n > 0; n--) {
            int max = 0;

            for (int i = pos + 1; i <= length - n; i++) {
                if (line[i] > max) {
                    max = line[i];
                    pos = i;
                }
            }

            line_result += max * pow(10, n - 1);
        }
        if (verbose)
            cout << "line_result = " << line_result << endl;

        result += line_result;
    }

    cout << "Part 2 result: " << result << endl;
}

int main() {
    string filename = "input.3.run.txt";
    bool verbose = false;

    part1(filename, verbose);
    part2(filename, verbose);

    return 0;
}
