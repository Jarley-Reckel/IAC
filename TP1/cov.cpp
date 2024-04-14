#include <iostream>
#include <vector>




// static std::vector<int> vector01 = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
// static std::vector<int> vector02 = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
static std::vector<int> vector01 = {2, 4, 6, 8, 10, 12, 14, 16, 18, 20};
static std::vector<int> vector02 = {-2, -4, -6, -8, -10, -12, -14, -16, -18, -20};
// static std::vector<int> vector01 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
// static std::vector<int> vector02 = {10, 9, 8, 7, 6, 5, 4, 3, 2, 1};
// static std::vector<int> vector01 = {1, 2, 3, 4};
// static std::vector<int> vector02 = {1, 1, 1, 1};

int media(std::vector<int> vector) {
    int sum = 0;
    int size = vector.size();
    for (int i = 0; i < size; i++) {
        sum += vector[i];
    }
    return sum / size;
}

int main(void) {
    int media01 = media(vector01);
    int media02 = media(vector02);

    int sum = 0;
    int size = vector01.size();
    for(int i = 0; i < size; i++) {
        sum += (vector01[i] - media01) * (vector02[i] - media02); 
    }
    int denominator = size - 1;
    float cov = sum / denominator;
    std::cout << "Covariance: " << cov << std::endl;
    return 0;
}