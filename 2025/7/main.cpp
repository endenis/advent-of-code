#include <iostream>
#include <string>
#include <fstream>
#include <vector>

using namespace std;

typedef unsigned long long ull;

struct Data {
    vector<vector<pair<ull, char>>> lines;
};

void parse_input_file(string filename, Data& data) {
    ifstream inFile(filename);

    if (!inFile)
        throw runtime_error("Unable to open input file");

    string input_line;
    while (getline(inFile, input_line)) {
        vector<pair<ull, char>> line;

        for (int i = 0; i < input_line.size(); i++) {
            int value = input_line[i] == 'S' ? 1 : 0;
            line.push_back(make_pair(value, input_line[i]));
        }

        data.lines.push_back(line);
    }

    inFile.close();
}

void output_lines(Data& data) {
    for (auto& line : data.lines) {
        for (auto& point : line) {
            cout << point.second;
        }
        cout << endl;
    }
}

void output_lines_with_counts(Data& data) {
    for (auto& line : data.lines) {
        for (auto& point : line) {
            cout << point.second;
        }
        cout << "   ";
        ull sum = 0;
        for (auto& point : line) {
            cout << "[" << (point.second == '^' ? "^" : to_string(point.first)) << "]";
            sum += point.first;
        }
        cout << "   " << to_string(sum) << endl;
    }
}

void part1(string filename, bool verbose) {
    int result = 0;

    Data data;
    parse_input_file(filename, data);

    for (int j = 0; j < data.lines.size() - 1; j++) {
        auto& line = data.lines[j];
        for (int i = 0; i < line.size(); i++) {
            if (line[i].second == 'S' || line[i].second == '|') {
                if (data.lines[j + 1][i].second == '.')
                    data.lines[j + 1][i].second = '|';

                if (data.lines[j + 1][i].second == '^') {
                    data.lines[j + 1][i - 1].second = '|';
                    data.lines[j + 1][i + 1].second = '|';
                    result++;
                }
            }
        }
    }

    if (verbose)
        output_lines(data);

    cout << "Part 1 result: " << result << endl;
}

void part2(string filename, bool verbose) {
    ull result = 0;

    Data data;
    parse_input_file(filename, data);

    for (int j = 0; j < data.lines.size() - 1; j++) {
        auto& line = data.lines[j];
        for (int i = 0; i < line.size(); i++) {
            if (line[i].second == 'S' || line[i].second == '|') {
                if (data.lines[j + 1][i].second == '.') {
                    data.lines[j + 1][i].first += data.lines[j][i].first;
                    data.lines[j + 1][i].second = '|';
                }
                else if (data.lines[j + 1][i].second == '^') {
                    data.lines[j + 1][i - 1].second = '|';
                    data.lines[j + 1][i - 1].first += data.lines[j][i].first;
                    data.lines[j + 1][i + 1].second = '|';
                    data.lines[j + 1][i + 1].first += data.lines[j][i].first;
                }
                else
                    data.lines[j + 1][i].first += data.lines[j][i].first;
            }
        }
    }

    auto last_line = data.lines.back();
    for (auto& point : last_line) {
        result += point.first;
    }

    if (verbose)
        output_lines_with_counts(data);

    cout << "Part 2 result: " << result << endl;
}

int main() {
    string filename = "input.7.run.txt";
    bool verbose = false;

    part1(filename, verbose);
    part2(filename, verbose);

    return 0;
}
