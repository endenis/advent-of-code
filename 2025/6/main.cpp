#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <regex>
#include <sstream>
#include <format>

using namespace std;

typedef unsigned long long ull;

struct PartOneData {
    vector<vector<int>> lines;
    vector<char> operators;
};

struct PartTwoData {
    vector<string> lines;
    vector<char> operators;
};

void remove_empty(vector<string>& collection) {
    collection.erase(
        remove_if(
            begin(collection),
            end(collection),
            [](string value) { return value == ""; }
        ),
        collection.end()
    );
}

vector<string> split(string& input, regex& separator) {
    sregex_token_iterator iterator(cbegin(input), cend(input), separator, -1);
    sregex_token_iterator end;
    vector<string> result = { iterator, end };

    remove_empty(result);

    return result;
}

void parse_input_file_for_part1(string filename, PartOneData& data) {
    ifstream inFile(filename);

    if (!inFile)
        throw runtime_error("Unable to open input file");

    auto convert_number = [](string value) { return stoi(value); };
    auto convert_operator = [](string value) { return value[0]; };

    string input_line;
    while (getline(inFile, input_line)) {
        char first_char = input_line[0];
        char is_operation_line = first_char == '+' || first_char == '*';

        regex whitespaces_regex("\\s+");
        auto input_line_parts = split(input_line, whitespaces_regex);

        if (is_operation_line) {
            transform(
                begin(input_line_parts),
                end(input_line_parts),
                back_inserter(data.operators),
                convert_operator
            );
        }
        else {
            vector<int> numbers;

            transform(
                cbegin(input_line_parts),
                cend(input_line_parts),
                back_inserter(numbers),
                convert_number
            );

            data.lines.push_back(numbers);
        }
    }

    inFile.close();
}

void parse_input_file_for_part2(string filename, PartTwoData& data) {
    ifstream inFile(filename);

    if (!inFile)
        throw runtime_error("Unable to open input file");

    auto convert_operator = [](string value) { return value[0]; };

    string input_line;
    while (getline(inFile, input_line)) {
        char first_char = input_line[0];
        char is_operation_line = first_char == '+' || first_char == '*';

        if (is_operation_line) {
            regex whitespaces_regex("\\s+");
            auto input_line_parts = split(input_line, whitespaces_regex);

            transform(
                begin(input_line_parts),
                end(input_line_parts),
                back_inserter(data.operators),
                convert_operator
            );

            break;
        }

        data.lines.push_back(input_line);
    }

    inFile.close();
}

ull calculate(PartOneData& data) {
    ull result = 0;

    vector<ull> columns;
    for (auto& op : data.operators)
        columns.push_back(op == '*' ? 1 : 0);

    for (auto& line : data.lines) {
        size_t size = line.size();
        for (size_t i = 0; i < size; i++) {
            char op = data.operators[i];

            if (op == '*')
                columns[i] *= line[i];
            else if (op == '+')
                columns[i] += line[i];
            else
                throw runtime_error(format("Uknown operator: {}", op));
        }
    }

    for (ull column : columns)
        result += column;

    return result;
}

ull calculate(PartTwoData& data, bool verbose) {
    ull result = 0;

    vector<ull> columns;
    for (auto& op : data.operators)
        columns.push_back(op == '*' ? 1 : 0);

    size_t line_count = data.lines.size();
    string separator = string(line_count, ' ');

    size_t length = data.lines[0].size();
    size_t block_index = 0;
    for (size_t i = 0; i < length; i++) {
        stringstream buffer;

        int n = 0;
        for (auto& line : data.lines) {
            buffer << line[i];
            n++;
        }

        string resulting_string = buffer.str();

        if (resulting_string == separator) {
            if (verbose)
                cout << "Finished block " << block_index << endl;

            block_index++;
            continue;
        }

        ull number = stoull(resulting_string);
        char op = data.operators[block_index];

        if (op == '*')
            columns[block_index] *= number;
        else if (op == '+')
            columns[block_index] += number;
        else
            throw runtime_error(format("Uknown operator: {}", op));
    }

    for (ull column : columns)
        result += column;

    return result;
}

void part1(string filename) {
    PartOneData data;
    parse_input_file_for_part1(filename, data);

    ull result = calculate(data);

    cout << "Part 1 result: " << result << endl;
}

void part2(string filename, bool verbose) {
    PartTwoData data;
    parse_input_file_for_part2(filename, data);

    ull result = calculate(data, verbose);

    cout << "Part 2 result: " << result << endl;
}

int main() {
    string filename = "input.6.run.txt";
    bool verbose = false;

    part1(filename);
    part2(filename, verbose);

    return 0;
}
