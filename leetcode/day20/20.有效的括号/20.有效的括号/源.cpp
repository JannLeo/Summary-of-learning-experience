#include <iostream>
#include <vector>
#include <stack>
#include <unordered_map>

using namespace std;


bool isValid(string s) {
    stack<char> rightbrackets;
    unordered_map <char, char> bramap{
        {'{','}'},
        {'(',')'},
        {'[',']'}
    };
    for (int i = 0; i < s.size(); i++) {
        if (bramap.find(s[i])!=bramap.end()) {
            rightbrackets.push(bramap.find(s[i])->second);
        }
        else {
            if (rightbrackets.empty())
                return false;
            if (rightbrackets.top() == s[i]) {
                
                rightbrackets.pop();
            }
            else
                return false;
        }

    }
    if (rightbrackets.empty())
        return true;
    return false;
}
void main() {
    string s;
    s = { "[" };
    cout << isValid(s);
}