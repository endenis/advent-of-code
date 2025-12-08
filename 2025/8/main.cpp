#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <regex>
#include <cmath>
#include <unordered_set>

using namespace std;

typedef unsigned long long ull;

struct DistanceEntry {
    ull distance = -1;

    vector<int> first;
    size_t first_id;

    vector<int> second;
    size_t second_id;
};

struct Data {
    vector<vector<int>> jboxes;
    vector<DistanceEntry> distances;

    vector<unordered_set<int>> circuits;
};

vector<int> split(string& input, regex& separator) {
    sregex_token_iterator iterator(input.cbegin(), input.cend(), separator, -1);
    sregex_token_iterator end;
    vector<string> string_parts = { iterator, end };

    vector<int> result;
    for (auto& part : string_parts)
        result.push_back(stoi(part));

    return result;
}

void parse_input_file(string filename, Data& data) {
    ifstream inFile(filename);

    if (!inFile)
        throw runtime_error("Unable to open input file");

    regex separator(",");

    string input_line;
    while (getline(inFile, input_line)) {
        auto jbox = split(input_line, separator);
        data.jboxes.push_back(jbox);
    }

    inFile.close();
}

ull calculate_distance(DistanceEntry& entry) {
    int x1 = entry.first[0];
    int x2 = entry.second[0];

    int y1 = entry.first[1];
    int y2 = entry.second[1];

    int z1 = entry.first[2];
    int z2 = entry.second[2];

    return pow(x2 - x1, 2) + pow(y2 - y1, 2) + pow(z2 - z1, 2);
}

bool distance_comparator(DistanceEntry& a, DistanceEntry& b) {
    return a.distance < b.distance;
}

int find_circuit(Data& data, int jbox_id) {
    for (int i = 0; i < data.circuits.size(); i++) {
        auto& circuit = data.circuits[i];
        auto search = circuit.find(jbox_id);
        if (search != circuit.end())
            return i;
    }

    return -1;
}

void part1(string filename, int limit, bool verbose) {
    Data data;
    parse_input_file(filename, data);

    for (size_t i = 0; i < data.jboxes.size() - 1; i++) {
        if (verbose)
            cout << "Calculating distances for " << i << endl;

        for (size_t j = i + 1; j < data.jboxes.size(); j++) {
            DistanceEntry entry;
            entry.first = data.jboxes[i];
            entry.first_id = i;
            entry.second = data.jboxes[j];
            entry.second_id = j;
            entry.distance = calculate_distance(entry);
            data.distances.push_back(entry);
        }
    }

    if (verbose)
        cout << "Sorting distances of " << data.distances.size() << " elements" << endl;
    sort(data.distances.begin(), data.distances.end(), distance_comparator);

    for (int n = 0; n < limit; n++) {
        auto& entry = data.distances[n];

        if (verbose) {
            cout << "Processing " << n << " / " << limit << endl;
            cout << entry.distance << " " << entry.first_id << " <-> " << entry.second_id << endl;
        }

        int left_existing_circuit = find_circuit(data, entry.first_id);
        int right_existing_circuit = find_circuit(data, entry.second_id);

        if (left_existing_circuit == -1 && right_existing_circuit == -1) {
            unordered_set<int> circuit;
            circuit.insert(entry.first_id);
            circuit.insert(entry.second_id);
            data.circuits.push_back(circuit);

            if (verbose)
                cout << "Added new circuit (" << entry.first_id << ", " << entry.second_id << ")" << endl;
        }
        else if (left_existing_circuit != -1 && right_existing_circuit != -1) {
            if (left_existing_circuit != right_existing_circuit) {
                auto& left_circuit = data.circuits[left_existing_circuit];
                auto& right_circuit = data.circuits[right_existing_circuit];
                for (auto& id : right_circuit)
                    left_circuit.insert(id);

                right_circuit.clear();
                if (verbose)
                    cout << "Merged circuits " << left_existing_circuit << " and " << right_existing_circuit << endl;
            }
        }
        else if (left_existing_circuit != -1) {
            data.circuits[left_existing_circuit].insert(entry.second_id);

            if (verbose)
                cout << "Added right " << entry.second_id << " to circuit " << left_existing_circuit << endl;
        }
        else if (right_existing_circuit != -1) {
            data.circuits[right_existing_circuit].insert(entry.first_id);

            if (verbose)
                cout << "Added  left " << entry.first_id << " to circuit " << right_existing_circuit << endl;
        }
    }

    vector<int> sizes;

    for (auto& circuit : data.circuits) {
        if (circuit.size() == 0)
            continue;

        sizes.push_back(circuit.size());

        if (verbose) {
            for (int id : circuit) {
                cout << id << " ";
            }
            cout << endl;
        }
    }

    sort(sizes.begin(), sizes.end());

    size_t length = sizes.size();
    if (verbose)
        cout << "sizes count = " << length << endl;

    if (length >= 3) {
        ull result = sizes[length - 1] * sizes[length - 2] * sizes[length - 3];
 
        cout << "Part 1 result: " << result << endl;
    }
}

bool is_one_large_circuit(Data& data) {
    for (auto& circuit : data.circuits) {
        if (circuit.size() == 0)
            continue;

        if (circuit.size() != data.jboxes.size())
            return false;
    }
    return true;
}

void part2(string filename, int limit, bool verbose) {

    Data data;
    parse_input_file(filename, data);

    ull result = 0;

    for (size_t i = 0; i < data.jboxes.size() - 1; i++) {
        if (verbose)
            cout << "Calculating distances for " << i << endl;

        for (size_t j = i + 1; j < data.jboxes.size(); j++) {
            DistanceEntry entry;
            entry.first = data.jboxes[i];
            entry.first_id = i;
            entry.second = data.jboxes[j];
            entry.second_id = j;
            entry.distance = calculate_distance(entry);
            data.distances.push_back(entry);
        }
    }

    if (verbose)
        cout << "Sorting distances of " << data.distances.size() << " elements" << endl;
    sort(data.distances.begin(), data.distances.end(), distance_comparator);

    for (int n = 0; n < data.distances.size(); n++) {
        auto& entry = data.distances[n];

        if (verbose) {
            cout << "Processing " << n << " / " << limit << endl;
            cout << entry.distance << " " << entry.first_id << " <-> " << entry.second_id << endl;
        }

        int left_existing_circuit = find_circuit(data, entry.first_id);
        int right_existing_circuit = find_circuit(data, entry.second_id);

        if (left_existing_circuit == -1 && right_existing_circuit == -1) {
            unordered_set<int> circuit;
            circuit.insert(entry.first_id);
            circuit.insert(entry.second_id);
            data.circuits.push_back(circuit);

            if (verbose)
                cout << "Added new circuit (" << entry.first_id << ", " << entry.second_id << ")" << endl;
        }
        else if (left_existing_circuit != -1 && right_existing_circuit != -1) {
            if (left_existing_circuit != right_existing_circuit) {
                auto& left_circuit = data.circuits[left_existing_circuit];
                auto& right_circuit = data.circuits[right_existing_circuit];
                for (auto& id : right_circuit)
                    left_circuit.insert(id);

                right_circuit.clear();
                if (verbose)
                    cout << "Merged circuits " << left_existing_circuit << " and " << right_existing_circuit << endl;
            }
        }
        else if (left_existing_circuit != -1) {
            data.circuits[left_existing_circuit].insert(entry.second_id);

            if (verbose)
                cout << "Added right " << entry.second_id << " to circuit " << left_existing_circuit << endl;
        }
        else if (right_existing_circuit != -1) {
            data.circuits[right_existing_circuit].insert(entry.first_id);

            if (verbose)
                cout << "Added  left " << entry.first_id << " to circuit " << right_existing_circuit << endl;
        }

        if (is_one_large_circuit(data)) {
            result = (ull)entry.first[0] * (ull)entry.second[0];
            if (verbose)
                cout << "result = " << entry.first[0] << " * " << entry.second[0] << " = " << to_string(result) << endl;

            break;
        }
    }

    cout << "Part 2 result: " << result << endl;
}

int main() {
    bool test = false;
    bool verbose = false;

    string filename = test ? "input.8.test.txt" : "input.8.run.txt";
    int limit = test ? 10 : 1000;

    part1(filename, limit, verbose);
    part2(filename, limit, verbose);

    return 0;
}
