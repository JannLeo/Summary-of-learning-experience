#include <iostream>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <ctime>
using namespace std;
#define MAX 50
#define RATE 0.7

int matrix_d[MAX][MAX] = {0};
int matrix_e[MAX][MAX] = {0};
double matrix_s[MAX][MAX] = {0};
int matrix_p[MAX][MAX] = {0};
int same_row[MAX] = {0};

void print_LCS(char *str1, int i, int j)
{
    if (i == 0 || j == 0)
        return;
    if (matrix_e[i][j] == 1)
    {
        print_LCS(str1, i - 1, j - 1);
        cout << str1[i-1];
    }
    else if (matrix_e[i][j] == 2)
    {
        print_LCS(str1, i - 1, j);
    }
    else
    {
        print_LCS(str1, i, j - 1);
    }
}

int LCS_length(char str1[], char str2[])
{
    int n, m, i, j;
    n = strlen(str1);
    m = strlen(str2);
    for (i = 0; i < n; i++)
        matrix_d[0][i] = 0;
    for (i = 0; i < m; i++)
        matrix_d[i][0] = 0;

    for (i = 1; i <= n; ++i)
    {
        for (j = 1; j <= m; ++j)
        {
            if (str1[i-1] == str2[j-1])
            {
                matrix_d[i][j] = matrix_d[i - 1][j - 1] + 1;
                matrix_e[i][j] = 1;
            }
            else if (matrix_d[i - 1][j] >= matrix_d[i][j - 1])
            {
                matrix_d[i][j] = matrix_d[i - 1][j];
                matrix_e[i][j] = 2;
            }
            else
            {
                matrix_d[i][j] = matrix_d[i][j - 1];
                matrix_e[i][j] = 3;
            }
        }
    }

    return matrix_d[n][m];
}


void get_matrix_s(int row, int col, char str1[], char str2[]){
    double temp = min(strlen(str1), strlen(str2));
    matrix_s[row][col] = (double)LCS_length(str1, str2) / (double)temp;
}

void get_matrix_p(){
    int i, j;
    for (i = 0; i < MAX; ++i)
    {
        for (j = 0; j < MAX; ++j)
        {
            if((double)matrix_s[i][j] >= double(RATE)){
                matrix_p[i][j] = 1;
                break;
            }
        }
    }

    for (i = 0; i < MAX; ++i)
    {
        for (j = 0; j < MAX; ++j)
        {
            if (matrix_p[i][j] == 1)
            {
                same_row[i] = 1;
                break;
            }
        }
    }
}


void get_the_same_row()
{
    int i, start, end;
    int max=0, temp=0;
    for(i = 0; i < MAX; ++i){
        if(same_row[i] == 1){
            temp++;
            if(max<temp){
                max = temp;
                end = i;
                start = end - max + 1;
            }          
        }
        else{
            temp = 0;
        }
    }
    cout << "最多重复行为：" << max << endl;
    cout << "起始行数为：" << start << endl;
    cout << "终止行数为:" << end << endl;
}

void delete_note(char *s)
{
    for (int i = 0; s[i] != EOF; ++i)
    {
        if (s[i] == '/' && s[i + 1] == '/')
        {
            s[i] = '\0';
            s[i + 1] = '\0';
            break;
        }

        if (s[i] == '#' && s[i + 1] == 'i')
        {
            s[i] = '\0';
            s[i + 1] = '\0';
            break;
        }
    }
}

void delete_brackets(char *s){
    for (int i = 0; s[i] != EOF; ++i)
    {
        if (s[i] == '{' || s[i] == '}')
        {
            s[i] = ' ';
        }
    }
}

void delete_enter(char *s){
    for (int i = 0; s[i] != EOF; ++i)
    {
        if (s[i] == '\n' || s[i] == '\r')
        {
            s[i] = ' ';
        }
    }
}

void delete_space(char *s){
    int i, j, k;
    for(int i = 0; s[i] != '\0'; ++i){
        if (s[i] == ' ' && s[i+1] == ' ')
        {
            j = i;
            k = 0;
            while(s[j]!= '\0'){
                ++j;
                ++k;
                if(s[j]!=' ')
                    break;
            }
            for (; s[j] != '\0';++j){
                s[i + 1] = s[j];
                ++i;
            }
            s[j-k+1] = '\0';
        }
    }
    if(s[0]==' '){
        for (i = 0; s[i] != '\0'; ++i)
            s[i] = s[i + 1];
    }
}

void pre_deal(){
    ifstream fin("a.txt");
    ofstream fout("ac.txt");
    char str[255];
    while(!fin.eof()){
        fin.getline(str, 250, '\n');
        delete_brackets(str);
        delete_note(str);
        delete_enter(str);
        delete_space(str);
        if(str[0]!='\0')
            fout << str << endl;
    }
    fin.close();
    fout.close();

    fin.open("b.txt");
    fout.open("bc.txt");
    while (!fin.eof())
    {
        fin.getline(str, 250, '\n');
        delete_brackets(str);
        delete_note(str);
        delete_enter(str);
        delete_space(str);
        if (str[0] != '\0')
            fout << str << endl;
    }
    fin.close();
    fout.close();
}



int main()
{
    clock_t TimeInit, TimeFinal;
    TimeInit = clock();

    //pre_deal();
    char str1[255];
    char str2[255];
    ifstream in_a("ac.txt");
    
    int i=0, j=0;
    while(!in_a.eof()){
        in_a.getline(str1, 250, '\n');
        ifstream in_b("bc.txt");
        j = 0;
        while(!in_b.eof()){
            in_b.getline(str2, 250, '\n');
            get_matrix_s(i, j, str1, str2);
            ++j;
        }
        in_b.close();
        ++i;
    }
    in_a.close();
    get_matrix_p();
    get_the_same_row();

    TimeFinal = clock();
    double time_2 = (double)(TimeFinal - TimeInit) / (double)CLOCKS_PER_SEC * 1000;
    cout << "花费的时间为：" << time_2 << "ms" << endl;

    cin >> i;
    return 0;
}