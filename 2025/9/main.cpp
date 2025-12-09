#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <cmath>
#include <algorithm>

using namespace std;

typedef unsigned long long ull;

struct Data {
    vector<pair<int, int>> red_tiles;
};


void parse_input_file(string filename, Data& data) {
    ifstream inFile(filename);

    if (!inFile)
        throw runtime_error("Unable to open input file");

    string input_line;
    while (getline(inFile, input_line)) {
        auto pos = input_line.find(',');
        if (pos == string::npos)
            throw runtime_error("Missing ,");

        int x = stoi(input_line.substr(0, pos));
        int y = stoi(input_line.substr(pos + 1));

        data.red_tiles.push_back(make_pair(x, y));
    }

    inFile.close();
}

void part1(string filename, bool verbose) {
    ull result = 0;

    Data data;
    parse_input_file(filename, data);

    ull count = 0;

    pair<int, int> a, b;

    size_t length = data.red_tiles.size();
    for (size_t i = 0; i < length - 1; i++) {
        for (size_t j = i + 1; j < length; j++) {
            auto start = data.red_tiles[i];
            auto end = data.red_tiles[j];

            if (start.first == end.first || start.second == end.second)
                continue; // not interested in rectangles that are too narrow

            count++;

            ull area = ((ull)abs(end.first - start.first) + 1) * ((ull)abs(end.second - start.second) + 1);
            if (area > result) {
                result = area;
                a = start;
                b = end;
            }
        }
    }

    if (verbose) {
        cout << format("({}, {}) -> ({}, {})", b.first, b.second, a.first, a.second) << endl;
        cout << "Number of rectangles: " << count << endl;
    }

    cout << "Part 1 result: " << result << endl;
}

bool rectangle_intersects(
    pair<int, int>& edge1,
    pair<int, int>& edge2,
    vector<pair<int, int>>& tiles_for_lines
) {
    int minX = min(edge1.first, edge2.first);
    int maxX = max(edge1.first, edge2.first);

    int minY = min(edge1.second, edge2.second);
    int maxY = max(edge1.second, edge2.second);
     
    for (int i = 1; i < tiles_for_lines.size(); i++) {
        auto& prev = tiles_for_lines[i - 1];
        auto& current = tiles_for_lines[i];

        if ((current.first != prev.first) && (current.second != prev.second))
            throw runtime_error("Incorrect connection between red tiles");

        if (
            minX < max(prev.first, current.first) &&
            maxX > min(prev.first, current.first) &&
            minY < max(prev.second, current.second) &&
            maxY > min(prev.second, current.second)
        )
            return true;
    }

    return false;
}

void part2(string filename, bool verbose) {
    ull result = 0;

    Data data;
    parse_input_file(filename, data);

    vector<pair<int, int>> tiles_for_lines(data.red_tiles);
    tiles_for_lines.push_back(data.red_tiles[0]);

    ull count = 0;

    pair<int, int> a, b;

    size_t length = data.red_tiles.size();
    for (size_t i = 0; i < length - 1; i++) {
        for (size_t j = i + 1; j < length; j++) {
            auto start = data.red_tiles[i];
            auto end = data.red_tiles[j];

            if (start.first == end.first || start.second == end.second)
                continue; // not interested in rectangles that are too narrow

            count++;

            if (verbose && (count % 1000 == 0))
                cout << "Rectangle: " << count << endl;

            ull area = ((ull)abs(end.first - start.first) + 1) * ((ull)abs(end.second - start.second) + 1);
            if (
                (area > result) && !rectangle_intersects(start, end, tiles_for_lines)
            ) {
                result = area;
                a = start;
                b = end;
            }
        }
    }

    if (verbose)
        cout << format("({}, {}) -> ({}, {})", b.first, b.second, a.first, a.second) << endl;

    cout << "Part 2 result: " << result << endl;
}

int main() {
    bool test = false;
    bool verbose = false;

    string filename = test ? "input.9.test.txt" : "input.9.run.txt";

    part1(filename, verbose);
    part2(filename, verbose);

    return 0;
}
