#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <algorithm>

using namespace std;

typedef unsigned long long ull;

struct Data {
    vector<pair<ull, ull>> ranges;
    vector<ull> products;
};

void parse_input_file(string filename, Data& data) {
    ifstream inFile(filename);

    if (!inFile)
        throw runtime_error("Unable to open input file");

    bool parsing_ranges = true;

    string line;
    while (getline(inFile, line)) {
        if (line.size() == 0) {
            parsing_ranges = false;
            continue;
        }

        if (parsing_ranges) {
            auto pos = line.find('-');
            if (pos == string::npos)
                throw runtime_error("Missing - in range");

            string start_string = line.substr(0, pos);
            string end_string = line.substr(pos + 1);

            ull start = stoull(start_string);
            ull end = stoull(end_string);

            data.ranges.push_back(make_pair(start, end));
        }
        else {
            ull product = stoull(line);
            data.products.push_back(product);
        }
    }

    inFile.close();
}

void part1(string filename, bool verbose) {
    int result = 0;

    Data data;
    parse_input_file(filename, data);


    if (verbose) {
        for (auto& range : data.ranges)
            cout << range.first << "-" << range.second << endl;

        cout << endl;
        for (auto& product : data.products)
            cout << product << endl;

    }

    for (auto& product : data.products) {
        bool fresh = false;
        for (auto& range : data.ranges) {
            if (product >= range.first && product <= range.second) {
                fresh = true;
                break;
            }
        }

        if (fresh)
            result++;
    }

    cout << "Part 1 result: " << result << endl;
}

void part2(string filename, bool verbose) {
    ull result = 0;

    Data data;
    parse_input_file(filename, data);

    sort(data.ranges.begin(), data.ranges.end());
    if (verbose) {
        for (auto& range : data.ranges)
            cout << range.first << "-" << range.second << endl;

        cout << endl << endl;
    }

    vector<pair<ull, ull>> optimized_ranges;

    optimized_ranges.push_back(data.ranges[0]);

    size_t length = data.ranges.size();
    size_t j = 0;
    for (size_t i = 1; i < length; i++) {
        if (data.ranges[i].first <= optimized_ranges[j].second) {
            if (data.ranges[i].second > optimized_ranges[j].second)
                optimized_ranges[j].second = data.ranges[i].second;
        }
        else  {
            optimized_ranges.push_back(data.ranges[i]);
            j++;
        }
    }

    if (verbose) {
        for (auto& range : optimized_ranges)
            cout << range.first << "-" << range.second << endl;

        cout << endl << endl;
    }

    for (auto& range : optimized_ranges)
        result += range.second - range.first + 1;


    cout << "Part 2 result: " << result << endl;
}

int main() {
    string filename = "input.5.run.txt";
    bool verbose = false;

    part1(filename, verbose);
    part2(filename, verbose);

    return 0;
}
