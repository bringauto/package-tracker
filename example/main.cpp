
#include <nlohmann/json.hpp>

#include <iostream>



int main(int argc, char **argv) {
    nlohmann::json j;

    j["TestJson"] = "ok";
    std::cout << j.dump() << std::endl;
    
    return 0;
}