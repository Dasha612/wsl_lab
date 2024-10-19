#!/bin/bash


LOG_DIR=~/log
SIZE_PER_FILE_MB=10


generate_test_data() {
    local num_files=$1  
    rm -rf "$LOG_DIR"/*  
    mkdir -p "$LOG_DIR"
    for i in $(seq 1 $num_files); do
        dd if=/dev/urandom of="$LOG_DIR/logfile_$i.log" bs=1M count=$SIZE_PER_FILE_MB > /dev/null 2>&1
    done
}

# Тест 1: Проверка, что ничего не архивируется, если место меньше 90%
test_case_1() {
    echo "Running Test 1"
    generate_test_data 50  # Создаём 50 файлов, размер логдир  = 50* 10 = 500мб = 500 000 кб. 500000 * 100 /1048576 = 47.6% -> не должно архивироваться
    ./script1.sh "$LOG_DIR" 90 10
}

# Тест 2: Архивирование при заполнении > 60%
test_case_2() {
    echo "Running Test 2"
    generate_test_data 70  # Создаём 70 файлов, размер логдир  = 70* 10 = 700мб = 700 000 кб. 700000 * 100 /1048576 = 66.7% ->  должно архивироваться
    ./script1.sh "$LOG_DIR" 60 5
}


test_case_3() {
    echo "Running Test 3"
    generate_test_data 100  # Создаём 100 файлов, размер логдир  =1000 000 кб. 1000000 * 100 /1048576 = 95.3% ->  должно архивироваться
    ./script1.sh "$LOG_DIR" 50 10
}


test_case_4() {
    echo "Running Test 4"
    generate_test_data 30  
    ./script1.sh "$LOG_DIR" 50 5
}

test_case_5() {
    echo "Running Test 5"

    generate_test_data 20  
    ./script1.sh "$LOG_DIR" 30 10

}

test_case_1
test_case_2
test_case_3
test_case_4
test_case_5

