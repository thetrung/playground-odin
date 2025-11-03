package main
//$> odin run .
import "core:slice"
import "core:fmt"
import "core:mem"

allocate_buffer :: proc(ptr: ^^u8, size: int) -> bool {
    // Allocate a chunk of size (u8)
    buffer, ok := mem.alloc(size)
    if buffer == nil { 
        return false
    }
    // Write pointer >> ptr parameter :
    ptr^ = cast(^u8)buffer
    return true
}

main :: proc(){
    // test :
    size := 1 // 1x8 bytes
    buffer: ^u8 = nil
    success := allocate_buffer(&buffer, size);
    // print :
    if success {
        fmt.printfln("Allocated a chunk of %d bytes", size * 8)
        defer mem.free(buffer)
    } else {
        fmt.printfln("Allocation failed.")
    }
    // usage :
    // cast the pointer -> array pointer
    data := cast([^]u8) buffer
    data[0] = 1
    data[1] = 255 // u8_max = 255
    data[2] = 3
    data[33] = 33 // no error ? xD cool.
    for i in 0..<size_of(data) {
        fmt.printfln("data[%d] = %d", i, data[i])
        // still loop 0~7
    }
}
