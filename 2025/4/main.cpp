#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <queue>

using namespace std;

vector<vector<char>> parse_input_file(string filename) {
    vector<vector<char>> parsed_data;

    ifstream inFile(filename);

    if (!inFile)
        throw runtime_error("Unable to open input file");

    string line;
    while (getline(inFile, line)) {
        vector<char> line_vector;

        for (char c : line)
            line_vector.push_back(c);

        parsed_data.push_back(line_vector);
    }

    inFile.close();
    return parsed_data;
}

void output_data(vector<vector<char>>& data, bool verbose) {
    if (!verbose)
        return;

    for (auto& line : data) {
        for (char c : line) {
            cout << c;
        }
        cout << endl;
    }
    cout << endl << endl << endl;
}

bool is_position_empty(vector<vector<char>>& data, size_t i, size_t j, size_t width, size_t height) {
    if (i < 0 || i >= width)
        return true;

    if (j < 0 || j >= height)
        return true;

    if (data[j][i] == '.')
        return true;

    return false;
}

bool is_accessible(vector<vector<char>>& data, size_t i, size_t j, size_t width, size_t height) {
    int offsets[8][2] = { 
       {-1, -1},
       {-1, 0},
       {-1, 1},
       {0, -1},
       {0, 1},
       {1, -1},
       {1, 0},
       {1, 1},
    };

    int free_positions = 0;

    for (auto& offset : offsets) {
        if (is_position_empty(data, i + offset[0], j + offset[1], width, height)) {
            free_positions++;

            if (free_positions > 4)
                return true;
        }
    }

    return false;
}

void part1(string filename, bool verbose) {
    int result = 0;
    vector<vector<char>> data = parse_input_file(filename);

    output_data(data, verbose);

    size_t width = data.size();
    size_t height = data[0].size();

    for (size_t j = 0; j < height; j++) {
        for (size_t i = 0; i < width; i++) {
            if (data[j][i] == '@' && is_accessible(data, i, j, width, height)) {
                data[j][i] = 'x';
                result++;
            }
        }
    }

    output_data(data, verbose);

    cout << "Part 1 result: " << result << endl;
}

void part2(string filename, bool verbose) {
    int old_result = -1;
    int result = 0;
    vector<vector<char>> data = parse_input_file(filename);

    output_data(data, verbose);

    size_t width = data.size();
    size_t height = data[0].size();

    queue<pair<size_t, size_t>> removal_queue;

    while (result != old_result) {
        old_result = result;

        for (size_t j = 0; j < height; j++) {
            for (size_t i = 0; i < width; i++) {
                if (data[j][i] == '@' && is_accessible(data, i, j, width, height)) {
                    data[j][i] = 'x';
                    removal_queue.push(make_pair(j, i));
                }
            }
        }

        output_data(data, verbose);

        while (!removal_queue.empty()) {
            auto position = removal_queue.front();
            data[position.first][position.second] = '.';
            result++;
            removal_queue.pop();
        }
    }

    cout << "Part 2 result: " << result << endl;
}

int main() {
    string filename = "input.4.run.txt";
    bool verbose = false;

    part1(filename, verbose);
    part2(filename, verbose);

    return 0;
}
