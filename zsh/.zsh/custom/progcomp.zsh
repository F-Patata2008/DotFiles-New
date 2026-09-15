# ==============================================================================
# Competitive Programming C++ Toolkit for Ryzen 3 3250U (Zen+)
# ==============================================================================

# Fast Production Compile & Run (Max Zen+ throughput, -O3, vectorization)
cpc() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: cpc <file.cpp> [args...]"
        return 1
    fi
    local src="$1"
    shift
    local out="${src%.*}"
    echo -e "\033[0;32m[CPC]\033[0m Compiling $src (-O3 -march=native -std=c++20)..."
    if clang++ -O3 -march=native -std=c++20 -pipe "$src" -o "$out"; then
        echo -e "\033[0;34m[CPC]\033[0m Executing $out:"
        "./$out" "$@"
    fi
}

# Debug Compile & Run (AddressSanitizer + UndefinedBehaviorSanitizer)
# Catches segfaults, out-of-bounds arrays, and integer overflows instantly.
cpc-debug() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: cpc-debug <file.cpp> [args...]"
        return 1
    fi
    local src="$1"
    shift
    local out="${src%.*}_debug"
    echo -e "\033[1;33m[CPC-DEBUG]\033[0m Compiling $src with ASan + UBSan..."
    if clang++ -O1 -g -std=c++20 -Wall -Wextra -Wshadow \
        -fsanitize=address,undefined -fno-omit-frame-pointer \
        "$src" -o "$out"; then
        echo -e "\033[1;33m[CPC-DEBUG]\033[0m Running $out (Sanitizers active):"
        "./$out" "$@"
    fi
}
