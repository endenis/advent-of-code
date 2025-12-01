#include <iostream>
#include <string>
#include <fstream>
using namespace std;

void part1()
{
    int current_number = 50;
    int counter = 0;

    ifstream inFile("input.1.run.txt");

    if (!inFile) {
        cout << "Unable to open input file";
        exit(1);
    }

    std::string line;
    while (getline(inFile, line)) {
        char op = line[0];

        string numberString = line.erase(0, 1);
        int number = stoi(numberString);

        int old_number = current_number;

        if (op == 'L') {
            current_number -= number;
        }
        else if (op == 'R') {
            current_number += number;
        }
        else {
            cout << "Wrong operation: " << op << endl;
            inFile.close();
            exit(1);
        }

        current_number = current_number % 100;

        if (current_number < 0) {
            current_number += 100;
        }

        if (current_number == 0) {
            counter++;
        }
    }

    inFile.close();

    cout << "Part 1 result: " << counter << endl;
}

void part2() {
    int current_number = 50;
    int counter = 0;

    ifstream inFile("input.1.run.txt");

    if (!inFile) {
        cout << "Unable to open input file";
        exit(1);
    }

    std::string line;
    while (getline(inFile, line)) {
        char op = line[0];

        string numberString = line.erase(0, 1);
        int number = stoi(numberString);

        int old_number = current_number;

        if (op == 'L') {
            current_number -= number;
        }
        else if (op == 'R') {
            current_number += number;
        }
        else {
            cout << "Wrong operation: " << op << endl;
            inFile.close();
            exit(1);
        }

        int overflow_rotations = abs(current_number) / 100;
        counter += overflow_rotations;

        if ((old_number > 0 && current_number < 0) || (old_number < 0 && current_number > 0)) {
            counter++;
        }

        current_number = current_number % 100;

        if (current_number < 0) {
            current_number += 100;
        }

        if (current_number == 0 && overflow_rotations == 0) {
            counter++;
        }
    }

    inFile.close();

    cout << "Part 2 result: " << counter << endl;
}

int main() {
    part1();
    part2();
    return 0;
}
