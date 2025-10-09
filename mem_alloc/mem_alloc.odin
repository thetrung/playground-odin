package main
//$> odin run .
import "core:fmt"
import "core:mem"

// Demo concept :
// buffer: ^u8 = nil
// ptr: ^^u8 = &buffer
allocate_buffer :: proc(ptr: ^^u8, size: int) -> bool {
    // Allocate a chunk of size (in byte)
    buffer, ok := mem.alloc(size)
    if buffer == nil { 
        return false
    }
    // Write pointer to ptr parameter :
    ptr^ = cast(^u8)buffer
    return true
}

main :: proc(){
    buffer: ^u8 = nil
    size := 10

    success := allocate_buffer(&buffer, size);
    if success {
        fmt.printfln("Allocated a chunk of %d bytes", size)
    } else {
        fmt.printfln("Allocation failed.")
    }
}